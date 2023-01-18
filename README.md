# Marko

A simple and (currently) incomplete Markdown to HTML converter I put together in a night and am working on while learning Haskell.

## Note

This is currently an incomplete version with numerous bugs and will surely not adhere the standards.

## Building

Building using `ghc`.

```bash
ghc markdown.hs
```

## Usage

Write the Markdown through STDIN and read it from STDOUT.

```bash
cat md.md | ./markdown | cat > md.html
```

Currently, the program can take a single 'styles.css' file and use its CSS.

## Example

Marko converts the following Markdown to HTML (with a custom CSS style):

```markdown
# Report

## About
This is the-bokya!
He is:

1. The ***best***!
2. The **bokya**!

+ yo!
+ bro!
```

Result:

![The converted HTML](Screenshot%202023-01-19%20at%2002-07-16%20Screenshot.png "Output")
