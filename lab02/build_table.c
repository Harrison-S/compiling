#include"stdio.h"
#include"node.h"
void ExtDef(struct node *current)
{
	struct node *temp=(current->mlc)->rneighbor;
	if(*(temp->type)=='E')
	{
		ExtDef_first(current);
	}
	else if(*(temp->type)=='S')
	{
		ExtDef_second(current);
	}
	else if(*(temp->type)=='F')
	{
		temp=temp->rneighbor;
		if(*(temp->type)=='C')
		{
			ExtDef_third(current);
		}
		else
		{
			ExtDef_forth(current);
		}
	}
}
void ExtDef_first(struct node *current)
{
	struct node *temp=current->mlc;
	Type type= Specifier(temp);
	temp=temp->rneighbor;
	ExtDecList(temp,type);
}
Type Specifier(sturct node *current)
{
	struct node *temp=current->mlc;
	Type new=NULL;
	if(*(temp->type)=='T')
	{
		new=malloc(sizeof(Type_));
		if(*(temp->content)=='i')
		{
			new->kind=INT;
		}
		else
		{
			new->kind=FLOAT;
		}
	}
	else
	{
		new=malloc(sizeof(Type_));
		new->kind=STRUCTURE;
	}
	return new;
}
Type ExtDecList(struct node *current,Type type)
{
	struct node *temp=current->mlc;
	if(temp->rneighbor==NULL)
	{
		Elem goingtoadd=malloc(sizeof(Elem_));
		goingtoadd->name=temp->content;
		goingtoadd->pointer=type;
		goingtoadd->nextone=NULL;
		goingtoadd->downone=NULL;
	}
	else
	{
		
	}
}
























