%{
#include "y.tab.h"
int linenumber = 0;

%}
enter 		\n
blank 		[ \t]+
letter 		[a-zA-Z_]
digit 		[0-9]
id    		{letter}({letter}|{digit})*

desc  		(\/\/.*\n)|(\/*.*\*\/)
intin 		{digit}+
doublein 	{digit}+(\.{digit}+)
charin 		\'{letter}\'
end			$
%%
{enter}		{linenumber++;}
{desc}		{printf("this is omitted");}
{blank} 	{/* do nothing */}
{intin}		{yylval.id = (char*)malloc(strlen(yytext) * sizeof(char)); sscanf(yytext, "%s", yylval.id); return INTIN;}
{doublein}	{yylval.id = (char*)malloc(strlen(yytext) * sizeof(char)); sscanf(yytext, "%s", yylval.id); return DOUBLEIN;}
{charin}	{yylval.id = (char*)malloc(strlen(yytext) * sizeof(char)); sscanf(yytext, "%s", yylval.id); return CHARIN;}
"int"  		{return INT;}
"double"  	{return DOUBLE;}
"char"  	{return CHAR;}
"printf"  	{return PRINT;}
"=="		{return EQUAL;}
"!="		{return NEQUAL;}
"+"         {return PLUS;}
"-"         {return MINUS;}
"*"         {return TIMES;}
"/"         {return DIVIDE;}
"="			{return ASSIGN;}
"while"		{return WHILE;}
"if"		{return IF;}
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

end			{printf("here is end of the file"); return END;}
.			{printf("not accepted!");}
%%



