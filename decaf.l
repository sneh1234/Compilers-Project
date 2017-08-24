%{
#include<bits/stdc++.h>
#include "AST.h"
using namespace std;
#define YY_DECL extern "C" int yylex()
#include "decaf.tab.h"


extern "C" ofstream File;
%}


MultiLineComment "/*"([^*]|(\*+[^*/]))*\*+\/
LineComment "//"[^\n]*"\n" 
ARITHOP [+\-\*\/%]
ASSIGNOP [+-]?=
RELOP <|>|<=|>=
EQOP ==|!=
AND &&
OR "||"
DIGIT [0-9]
INT_LITERAL [0-9]+|0x[0-9][a-fA-F]
BOOL_LITERAL true|false
CHAR_LITERAL \'.[^\']\'
STRING_LITERAL \"(\\.|[^\\"])*\"
ID [a-zA-Z][a-zA-Z0-9]*

%%

{LineComment}  ;
{MultiLineComment} ;
"callout"			{File << "CALLOUT " << endl; return CALLOUT;}
"class Program"		{File << "CLASS " << endl; return CLASS;}
"void"				{return VOID;}
\(       		{ File << "(" << endl; return BO; }
\)       		{File << ")" << endl;return BC; }
if				{return IF;}
else			{return ELSE;}
for				{File << "FOR" ; return FOR;}
return			{return RETURN;}
break			{return BREAK;}
continue		{return CONT;}
"int"			{File << "INT_DECLARATION " << endl; return INT_DECLARATION;}
"boolean"		{File << "BOOLEAN_DECLARATION " << endl; return BOOLEAN_DECLARATION;}



{INT_LITERAL}		{File << "INT: " << yytext << endl; yylval.ival = atoi(yytext); return INT_LITERAL;}
{BOOL_LITERAL}		{File << "BOOLEAN: " << yytext << endl; yylval.bval = atoi(yytext); return BOOL_LITERAL;}
{ID}			{File << "ID: " << yytext << endl; yylval.strval = strdup(yytext); return ID;}
{ARITHOP}		{return yytext[0];}
{RELOP}			{yylval.strval = strdup(yytext);return RELOP;}
{EQOP}			{yylval.strval = strdup(yytext);return EQOP;}
{OR}			{return OR;}
{AND}			{return AND;}
{ASSIGNOP}		{return ASSIGNOP;}

{CHAR_LITERAL}		{File << "CHARACTER: " << yytext << endl; yylval.cval = yytext[0]; return CHAR_LITERAL;}
{STRING_LITERAL}	{File << "STRING: " << yytext << endl; yylval.strval = strdup(yytext); return STRING_LITERAL;}

[ \t\n]+   		; 
. 			{File << yytext[0] << endl; return yytext[0];}

