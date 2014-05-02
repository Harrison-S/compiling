%{
	#include <stdio.h>
	#include "lex.yy.c"
	#include <string.h>
	#include <stdarg.h>
	static struct node *root=NULL;
	struct node *addnode(int num,...);
	int if_error=0;
%}
%locations
%union{struct node *node;}
%token <node>INT FLOAT ID
%token <node>SEMI COMMA ASSIGNOP
%token <node>RELOP
%token <node>PLUS MINUS
%token <node>STAR DIV
%token <node>AND OR DOT NOT
%token <node>TYPE
%token <node>LP RP LB RB LC RC
%token <node>STRUCT RETURN
%token <node>IF ELSE WHILE

%type <node>Program ExtDefList ExtDef ExtDecList
%type <node>Specifier StructSpecifier OptTag Tag
%type <node>VarDec FunDec VarList ParamDec
%type <node>CompSt StmtList Stmt
%type <node>DefList Def DecList Dec
%type <node>Exp Args
%right ASSIGNOP
%right NOT
%left RELOP AND OR
%left PLUS MINUS
%left STAR DIV
%left DOT LP RP LB RB LC RC
%nonassoc LOWER_THAN_ELSE
%nonassoc STRUCT RETURN IF ELSE WHILE
%nonassoc LOWER_THAN_ERROR
%nonassoc error

%%

Program		:	ExtDefList	{$$=addnode(1,"Program",$1);root=$$;}	
			;
ExtDefList	:	/*empty*/	{$$=NULL;}
			|	ExtDef ExtDefList	{$$=addnode(2,"ExtDefList",$1,$2);}
			;
ExtDef		:	Specifier ExtDecList SEMI	{$$=addnode(3,"ExtDef",$1,$2,$3);}
			|	Specifier SEMI	{$$=addnode(2,"ExtDef",$1,$2);}
			|	Specifier FunDec CompSt		{$$=addnode(3,"ExtDef",$1,$2,$3);}
			|	Specifier FunDec SEMI	{/*函数定义，动作待写*/};
			|	error SEMI {if_error=1;}
			;
ExtDecList	:	VarDec	{$$=addnode(1,"ExtDecList",$1);}
			|	VarDec COMMA ExtDecList	{$$=addnode(3,"ExtDecList",$1,$2,$3);}
			;

Specifier	:	TYPE	{$$=addnode(1,"Specifier",$1);}
			|	StructSpecifier	{$$=addnode(1,"Specifier",$1);}
			;
StructSpecifier	:	STRUCT OptTag LC DefList RC	{$$=addnode(5,"StructSpecifier",$1,$2,$3,$4,$5);}
				|	STRUCT Tag	{$$=addnode(2,"StructSpecifier",$1,$2);}
				;
OptTag		:	ID	{$$=addnode(1,"OptTag",$1);}
			|	{$$=NULL;}
			;
Tag			:	ID	{$$=addnode(1,"Tag",$1);}
			;

VarDec	:	ID	{$$=addnode(1,"VarDec",$1);}
		|	VarDec LB INT RB	{$$=addnode(4,"VarDec",$1,$2,$3,$4);}
		|	error RB {printf("@1\n");if_error=1;}
		;
FunDec	:	ID LP VarList RP	{$$=addnode(4,"FunDec",$1,$2,$3,$4);}
		|	ID LP RP	{$$=addnode(3,"FunDec",$1,$2,$3);}
		|	error RP	{printf("@2\n");if_error=1;}
		;
VarList	:	ParamDec COMMA VarList	{$$=addnode(3,"VarList",$1,$2,$3);}
		|	ParamDec	{$$=addnode(1,"VarList",$1);}
		;
ParamDec:	Specifier VarDec	{$$=addnode(2,"VarList",$1,$2);}
		|	error RC	{printf("@3\n");if_error=1;}
		;

CompSt	:	LC DefList StmtList RC	{$$=addnode(4,"CompSt",$1,$2,$3,$4);}
		|	error RC	{printf("@4\n");if_error=1;}
		;
StmtList:	Stmt StmtList	{$$=addnode(2,"StmtList",$1,$2);}
		|	{$$=NULL;}
		;
Stmt	:	Exp SEMI	{$$=addnode(2,"Stmt",$1,$2);}
		|	CompSt	{$$=addnode(1,"Stmt",$1);}
		|	RETURN Exp SEMI	{$$=addnode(3,"Stmt",$1,$2,$3);}
		|	IF LP Exp RP Stmt	%prec LOWER_THAN_ELSE	{$$=addnode(5,"Stmt",$1,$2,$3,$4,$5);}
		|	IF LP Exp RP Stmt ELSE Stmt	{$$=addnode(7,"Stmt",$1,$2,$3,$4,$5,$6,$7);}
		|	WHILE LP Exp RP Stmt	{$$=addnode(5,"Stmt",$1,$2,$3,$4,$5);}
		|	error SEMI	{printf("@5\n");if_error=1;}
		;

DefList	:	Def DefList	{$$=addnode(2,"DefList",$1,$2);}
		|	%prec LOWER_THAN_ERROR {$$=NULL;}
		;
Def		:	Specifier DecList SEMI	{$$=addnode(3,"Def",$1,$2,$3);}
		|	Specifier error SEMI	{if_error=1;}
		;
DecList	:	Dec	{$$=addnode(1,"DecList",$1);}
		|	Dec COMMA DecList	{$$=addnode(3,"DecList",$1,$2,$3);}
		;
Dec		:	VarDec	{$$=addnode(1,"Dec",$1);}
		|	VarDec ASSIGNOP Exp	{$$=addnode(3,"Dec",$1,$2,$3);}
		;

Exp		:	Exp ASSIGNOP Exp	{$$=addnode(3,"Exp",$1,$2,$3);}
		|	Exp AND Exp	{$$=addnode(3,"Exp",$1,$2,$3);}
		|	Exp OR Exp	{$$=addnode(3,"Exp",$1,$2,$3);}
		|	Exp RELOP Exp	{$$=addnode(3,"Exp",$1,$2,$3);}
		|	Exp PLUS Exp	{$$=addnode(3,"Exp",$1,$2,$3);}
		|	Exp MINUS Exp	{$$=addnode(3,"Exp",$1,$2,$3);}
		|	Exp STAR Exp	{$$=addnode(3,"Exp",$1,$2,$3);}
		|	Exp DIV Exp		{$$=addnode(3,"Exp",$1,$2,$3);}
		|	LP Exp RP		{$$=addnode(3,"Exp",$1,$2,$3);}
		|	MINUS Exp	{$$=addnode(2,"Exp",$1,$2);}
		|	NOT Exp		{$$=addnode(2,"Exp",$1,$2);}
		|	ID LP Args RP	{$$=addnode(4,"Exp",$1,$2,$3,$4);}
		|	ID LP RP		{$$=addnode(3,"Exp",$1,$2,$3);}
		|	Exp LB Exp RB	{$$=addnode(4,"Exp",$1,$2,$3,$4);}
		|	Exp DOT ID		{$$=addnode(3,"Exp",$1,$2,$3);}
		|	ID				{$$=addnode(1,"Exp",$1);}
		|	INT				{$$=addnode(1,"Exp",$1);}
		|	FLOAT			{$$=addnode(1,"Exp",$1);}
		|  	LP error RP		{printf("@7\n");if_error=1;}
		|	LB error RB		{printf("@8\n");if_error=1;}
		;		
Args	:	Exp	COMMA Args	{$$=addnode(3,"Args",$1,$2,$3);}
		|	Exp				{$$=addnode(1,"Args",$1);}
		;
%%
yyerror(char* msg)
{
	fprintf(stderr,"Error type B at line %d:%s\n",yylineno,msg);
}
struct node *addnode(int num,...){
	int i=1;
	struct node *current = (struct node *)malloc(sizeof(struct node));
	struct node *temp = NULL;
	current->token = 0;
	va_list nodeList;
	va_start(nodeList,num);
	char *type=va_arg(nodeList,char *);
	temp = va_arg(nodeList,struct node*);
	current->lineno = temp->lineno;
//	printf("%s\n",type);
	strcpy(current->type,type);
	//	printf("%s\n",current->type);
	current->mlc = temp;
	for(i = 1 ; i < num ; i++){
		temp->rneighbor = va_arg(nodeList,struct node*);
		if(temp->rneighbor!=NULL)
			temp = temp->rneighbor;
	}
	temp->rneighbor = NULL;
	va_end(nodeList);
	return current;
}

void printTree(struct node *p,int depth){
	int i;
	if(p == NULL) return;
	else{
	for(i = 0 ; i < depth ; i++)
		printf("   ");
	if(p->token==0){
		printf("%s (%d)\n", p->type, p->lineno);
		printTree(p->mlc , depth+1);
	}
	else{
		if(strncmp(p->type,"INT",3) == 0)
			printf("%s: %d\n", p->type, atoi(p->content));
		else if(strncmp(p->type,"FLOAT",5) == 0)
			printf("%s: %f\n", p->type, atof(p->content));
		else if(strncmp(p->type,"TYPE",4) == 0 || strcmp(p->type,"ID") == 0)
			printf("%s: %s\n", p->type, p->content);
		else{
	//		printf("2\n");
			printf("%s\n", p->type);
		}
	}
	printTree(p->rneighbor , depth);
}
}
int main(int argc,char** argv)
{
	
	if(argc<=1)
	{	
		printf("argument error!\n");
	}
	else 
	{
		int i;
		for(i=1;i<argc;i++)
		{
			root=NULL;
			if_error=0;
			FILE* f=fopen(argv[i],"r");
			if(!f)
			{
				perror(argv[i]);
				return 1;
			}
			yyrestart(f);
			yyparse();
			if(root!=NULL&&if_error==0)
				printTree(root,0);
		}
	}
	return 0;
}
























