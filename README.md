# MiniCCompiler

## How to run this:
yacc -d MiniCCompiler.y
lex MiniCCompiler.l
g++ -o test y.tab.c
./test
