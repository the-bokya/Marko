import qualified Data.Text as T
main :: IO()
main = do
  md <- getContents
  putStr $ convert md

enclose :: String -> String -> String
enclose tag content = "<" ++ tag ++ ">" ++ "\n" ++ content ++ "\n" ++ "</" ++ tag ++ ">"

encloseInline :: String -> String -> String
encloseInline tag content = "<" ++ tag ++ ">" ++ content ++ "</" ++ tag ++ ">" ++ "\n"
-- Some tags
html :: String -> String
html = enclose "html"

body :: String -> String
body = enclose "body"

heading :: String -> String
heading = enclose "head"

h1 :: String -> String
h1 = encloseInline "h1"

h2 :: String -> String
h2 = encloseInline "h2"

h3 :: String -> String
h3 = encloseInline "h3"

h4 :: String -> String
h4 = encloseInline "h4"

h5 :: String -> String
h5 = encloseInline "h5"

h6 :: String -> String
h6 = encloseInline "h6"

strong :: String -> String
strong = encloseInline "strong"

em :: String -> String
em = encloseInline "em"

emStrong :: String -> String
emStrong = em.strong

mainTag :: String -> String
mainTag = enclose "main"
ol :: String -> String
ol = enclose "ol"

ul :: String -> String
ul = enclose "ul"

li :: String -> String
li = enclose "li"

p :: String -> String
p = enclose "p"
-- helper functions

paras :: String -> [[String]]
paras xs = map lines separated
           where separated =  map T.unpack (T.splitOn (T.pack delimiter) (T.pack xs))
                 delimiter = "\n\n"


iter :: [[String]] -> [String]
iter [] = []
iter [x] = [mdfy x]
iter (x:xs) = mdfy x : iter(xs)

mdfy :: [String] -> String
mdfy (xs)
           | isOrderedList $ head xs = ol $ unlines $ map (toListItem.general) xs
           | isUnorderedList $ head xs = ul $ unlines $ map (toListItem.general) xs
           | otherwise = unlines $ breaks $ map general xs

isOrderedList :: String -> Bool
isOrderedList xs = length (numsTaken xs) > 0 && (take 2 $ numsDropped xs) == ". "

isUnorderedList :: String -> Bool
isUnorderedList xs
                      | (head xs == '+' || head xs == '-' || head xs == '*') && (head $ drop 1 xs) == ' ' = True
                      | otherwise = False
numsDropped :: String -> String
numsDropped xs = dropWhile (\x -> elem x "1234567890") xs

numsTaken :: String -> String
numsTaken xs = takeWhile (\x -> elem x "1234567890") xs

toListItem :: String -> String
toListItem xs = li $ drop 2 $ numsDropped xs

general :: String -> String
general xs
       | head xs == '#' = toHead xs
       | otherwise = toEm $ toStrong $ toEmStrong xs

toDeco :: (String -> String) -> String -> String -> String
toDeco f deco xs = let indices = zip (map T.unpack (T.splitOn (T.pack deco) (T.pack xs))) [1..]
                  in
                  concat $ map (\x -> if even (snd x) then f (fst x) else fst x) indices

toEmStrong :: String -> String
toEmStrong xs = toDeco emStrong "***" xs

toEm:: String -> String
toEm xs = toDeco em "*" xs

toStrong :: String -> String
toStrong xs = toDeco strong "**" xs

toHead :: String -> String
toHead xs
         | hs xs == 1 = h1 $ hashKiller xs
         | hs xs == 2 = h2 $ hashKiller xs
         | hs xs == 3 = h3 $ hashKiller xs
         | hs xs == 4 = h4 $ hashKiller xs
         | hs xs == 5 = h5 $ hashKiller xs
         | hs xs == 6 = h6 $ hashKiller xs
         | otherwise = xs
         where hs xs = length $ takeWhile (\x -> x == '#') xs
               hashKiller xs = dropWhile (\x -> x == '#') xs
--

stylesheet :: String -> String
stylesheet styles = "<link rel = \"stylesheet\" href = \"" ++ styles ++ "\">" 

convert :: String -> String
convert = html.inner

inner :: String -> String
inner content = (heading.stylesheet $ "styles.css") ++ (body.mainTag.md $ content)

md :: String -> String
md content = unlines $ map p $ iter.paras $ content

breaks :: [String] -> [String]
breaks [x] = [x]
breaks (x:xs) = x:"<br>":(breaks xs)
