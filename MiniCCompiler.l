%{
#include "y.tab.h"
int linenumber = 1;
/*
enum {
ASSIGN,  LT,      EQ,      GT,      LE,      GE,      NE,      IF,      ELSE, 	NUMBER,	PLUS, 	MINUS, 	TIMES, 	DIVIDE,
FOR, 	WHILE, 	LP,      RP,      LB,      RB,      LBB, 	RBB,     EQUAL,   HEAD,   
SEMI,    COMMA,   PRINT,   INT,     DOUBLE,  CHAR,    END,     BREAK,   RETURN,  DPLUS,   DMINUS, VOID
}
*/

%}
enter 		\n
blank 		[ \t]+
letter 		[a-zA-Z_]
digit 		[0-9]
id    		{letter}({letter}|{digit})*
desc  		(\/\/.*)|(\/\*.*\*\/)
intin 		{digit}+
doublein 	{digit}+(\.{digit}+)
charin 		\'{letter}\'
head		#.*

%%
{head}		{return HEAD;}
{enter}		{linenumber++;}
{desc}		{/* do nothing */}
{blank} 	{/* do nothing */}
{intin}		{yylval.id = (char*)malloc(strlen(yytext) * sizeof(char)); sscanf(yytext, "%s", yylval.id); return INTIN;}
{doublein}	{yylval.id = (char*)malloc(strlen(yytext) * sizeof(char)); sscanf(yytext, "%s", yylval.id); return DOUBLEIN;}
{charin}	{yylval.id = (char*)malloc(strlen(yytext) * sizeof(char)); sscanf(yytext, "%s", yylval.id); return CHARIN;}
"return"	{return RETURN;}
"int"  		{return INT;}
"double"  	{return DOUBLE;}
"char"  	{return CHAR;}
"void"		{return VOID;}
"printf"  	{return PRINT;}
"++"		{return DPLUS;}
"--"		{return DMINUS;}
"=="		{return EQ;}
"!="		{return NE;}
">"			{return GT;}
"<"			{return LT;}
">="		{return GE;}
"<="		{return LE;}
"+"         {return PLUS;}
"-"         {return MINUS;}
"*"         {return TIMES;}
"/"         {return DIVIDE;}
"="			{return ASSIGN;}
"while"		{return WHILE;}
"if"		{return IF;}
"else"		{return ELSE;}
"for" 		{return FOR;}
"break"		{return BREAK;}
{id}        {yylval.id = (char*)malloc(strlen(yytext) * sizeof(char)); sscanf(yytext, "%s", yylval.id); return ID;}
"("			{return LP;}
")"			{return RP;}
"["			{return LB;}
"]"			{return RB;}
"{"			{return LBB;}
"}"			{return RBB;}
";"			{return SEMI;}
","			{return COMMA;}

.			{printf("not accepted for %s", yytext);}
%%



