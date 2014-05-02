#include"type.h"
Elem table_v[16384];
Function table_f[16384];
Headline head=NULL;
Headline current=NULL;
void init()
{
	head=malloc(sizeof(Headline_));
	current->pre=head;
	current->thiscol=head->thiscol;
}
int atoi(const char *str)
{
	int value=0;
	bool b_plus=true;
	switch(*str)
	{
		case '+':
			str++;
			break;
		case '-':
			b_plus=false;
			str++;
			break;
		default:
			break;
	}
	while(*str!='\0')
	{
		value=(value*10)+(*str-'0');
		str++;
	}
	if(!b_plus)
	{
		value=0-value;
	}
	return value;
}
float atof(const char *str)
{
	bool b_plus=true;
	float num=0.0;
	float pow=1.0;
	if(*str=='-')
	{
		b_plus=false;
		str++;
	}
	else
		str++;
	while(*str!='\0')
	{
		if(*str=='.')
			break;
		num=num*10.0+(float)(*str-'0');
	}
	str++;
	while(*str!='\0')
	{
		num=num*10.0+(float)(*str-'0');
		pow=pow*10.0;
	}
	num=num/pow;
	if(!b_plus)
	{
		num=0-num;
	}
	return num;
}
unsigned int hash_pjw(char* name)
{
	unsigned int val=0;
	unsigned int i=0;
	for(;*name;++name)
	{
		val=(val<<2)+(*name);
		if(i=val&~0x3fff)
			val=(val^(i>>12))&0x3fff;
	}
	return val;
}
void v_table_init()
{
	int i=0;
	for(;i<16384;i++)
	{
		table_v[i]=NULL;
	}
}
void add_elem_v(Elem goingtoadd)
{
	unsigned int index=hash_pjw(goingtoadd->name);
	goingtoadd->nextone=table_v[index];
	table_v[index]=goingtoadd;
	current->thiscol->downone=goingtoadd;
	current->thiscol=goingtoadd;
}

