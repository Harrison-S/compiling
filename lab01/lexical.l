%{
	#include<stdio.h>
	#include"syntax.tab.h"
	int yycolumn=1;
	#define YY_USER_ACTION yylloc.first_line=yylloc.last_line=yylineno;\
	yylloc.first_column=yycolumn;yylloc.last_column=yycolumn+yyleng-1;\
	yycolumn+=yyleng;

	struct node
	{
		int token;
		char type[256];
		char content[256];
		int lineno;
		int column;
		struct node *mlc;
		struct node *rneighbor;
	};
	void createnode(char *type,char *content);
%}
%option yylineno
digit [0-9]
letter_ [_a-zA-Z]
pn [+-]
dignozero [1-9]
letter [a-zA-Z]
id {letter_}({letter_}|{digit})*
INT "0"|({dignozero}{digit}*)
INT8 [0][1-7][0-7]*
INT16 [0](X|x)[1-9A-Fa-f][0-9A-Fa-f]*
ERROR_INT "0"{digit}+
optionalFranction  "."{digit}+
SFLOAT ([0-9]*"."[0-9]*)(E|e)(\-|\+|[0-9])[0-9]*
FLOAT ((0|[1-9][0-9]*)"."[0-9]+)
delim [\t ]
ws {delim}+
noteone "//"(.)*\n
notetwo \/\*((\/[^*])|(\*[^\/])|[^\/*])*\*\/
errornoteone \/\*(((\/[^*])|[^\/])*\/\*((\/[^*])|[^\/])*)+\*\/
errornotetwo \/\*(((\*[^\/])|[^*])*\*\/((\*[^\/])|[^*])*)+\*\/
%%
\n {yycolumn=1;}
{ws} {}
while {createnode("WHILE",yytext);return (WHILE);}
if {createnode("IF",yytext);return(IF);}
else {createnode("ELSE",yytext);return(ELSE);}
struct {createnode("STRUCT",yytext);return(STRUCT);}
return {createnode("RETURN",yytext);return(RETURN);}
"int" {createnode("TYPE",yytext);return (TYPE);}
"float" {createnode("TYPE",yytext);return (TYPE);}
{id} {createnode("ID",yytext);return (ID);}
{INT} {
		createnode("INT",yytext);
		return (INT);
	}
{INT8}	{createnode("INT",yytext);return (INT);}
{INT16}	{createnode("INT",yytext);return (INT);}
{FLOAT} {createnode("FLOAT",yytext);return (FLOAT);}
{SFLOAT}	{createnode("FLOAT",yytext);return (FLOAT);}
";" {createnode("SEMI",yytext);return SEMI;}
"," {createnode("COMMA",yytext);return COMMA;}
"<" {createnode("RELOP",yytext);return (RELOP);}
"<=" {createnode("RELOP",yytext);return (RELOP);}
"==" {createnode("RELOP",yytext);return (RELOP);}
"!=" {createnode("RELOP",yytext);return(RELOP);}
"<>" {createnode("RELOP",yytext);return(RELOP);}
">" {createnode("RELOP",yytext);return(RELOP);}
">=" {createnode("RELOP",yytext);return(RELOP);}
"=" {createnode("ASSIGNOP",yytext);return (ASSIGNOP);}
"+" {createnode("PLUS",yytext);return (PLUS);}
"-" {createnode("MINUS",yytext);return (MINUS);}
"*" {createnode("STAR",yytext);return (STAR);}
"/" {createnode("DIV",yytext);return (DIV);}
"&&" {createnode("AND",yytext);return (AND);}
"||" {createnode("OR",yytext);return (OR);}
"." {createnode("DOT",yytext);return (DOT);}
"!" {createnode("NOT",yytext);return (NOT);}
"(" {createnode("LP",yytext);return (LP);}
")" {createnode("RP",yytext);return (RP);}
"[" {createnode("LB",yytext);return (LB);}
"]" {createnode("RB",yytext);return (RB);}
"{" {createnode("LC",yytext);return (LC);}
"}" {createnode("RC",yytext);return (RC);}
{noteone}	{printf("noteone\n");}
{notetwo}	{printf("notetwo\n");}
{errornoteone}	{printf("Error type[C] at line %d column %d : %s\n",yylloc.first_line,yylloc.first_column,yytext);}
{errornotetwo}	{printf("Error type[C] at line %d column %d : %s\n",yylloc.first_line,yylloc.first_column,yytext);}
. {printf("Error type [A] at line %d column %d : %s\n",yylloc.first_line,yylloc.first_column,yytext);}
%%

void createnode(char *type,char *content)
{
	yylval.node=(struct node *)malloc(sizeof(struct node));
	strcpy(yylval.node->type,type);
	strcpy(yylval.node->content,content);
    yylval.node->lineno=yylloc.first_line;
	yylval.node->column=yylloc.first_column;
	yylval.node->mlc=NULL;
	yylval.node->rneighbor=NULL;
	yylval.node->token=1;
}
