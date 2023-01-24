%option noyywrap
%{

#include <stdio.h>
#include "parser2.tab.h"

%}

%option yylineno
%%
[ ] ;
"#".*  ;
[\n] {return NEWLINE;};
[\t] {return TAB;};
"print" return PRINT;
"import"  return IMPORT;
"from" return FROM;
"and" return AND;
"or" return OR;
"def" return DEF;
"if" return IF;
"else" return ELSE;
"elif" return ELIF;
"for" return FOR;
"in" return IN;
"not" return NOT;
"range" return RANGE;
"return" return RETURN;
"class" return CLASS;
"lambda" return LAMBDA;

 
">" return '>';
"<" return '<';
"[" return '[';
"]" return ']';
"+" return '+';
"-" return '-';
"*" return '*';
"/" return '/';
"(" return '(';
")" return ')';
"=" return '=';
";" return ';';
"," return ',';
":" return  ':';
"{" return '{';
"}" return '}';
"%" return '%';
"//" return FLOOR_DIV;
"**" return POWER;
">=" return GE;
"<=" return LE;
"==" return EQ;
"!=" return NE;
"+=" return PEQ;
"-=" return SEQ;
"*=" return MEQ;
"/=" return DEQ;


[a-zA-Z_][a-zA-Z0-9_]*		{return IDENTIFIER;}
[a-zA-Z_][a-zA-Z0-9_]*"."[a-zA-Z_][a-zA-Z0-9_]*	{return IDENTIFIER;}
[+-]?[0-9]+ 			    { return NUMBER; }
[+-]?[0-9]+"."[0-9]+ 		{ return FLOAT; }
[[False][True]]+		    { return BOOLEAN;}
\"(\\.|[^"\\])*\"           {return  STRING;}


%%
