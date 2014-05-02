#include"stdio.h"
typedef struct Type_* Type;
typedef struct FieldList_* FieldList;
typedef struct Function_* Function;
typedef struct Elem_* Elem;
typedef struct Headline_* Headline;
struct Type_
{
	enum {INT,FLOAT,ARRAY,STRUCTURE} kind;
	union
	{
		float basic_f;
		int basic_i;
		//basic type
		struct {Type elem;int size;}array;
		//information including the type of element and the size of array
		FieldList structure;//represent the struct by listarray
	}u;
	Type next;
};
struct FieldList_
{
	char* name;// the name of field
	Type type; // the type of field
	FieldList tail; // point to next field
};
struct Function_
{
	char* f_name;
	int num_p;
	Type next_p;
};
struct Elem_
{
	char *name;
	Type pointer;
	Elem nextone;
	Elem downone;
}
struct Headline_
{
	Elem thiscol;
	Headline pre;
}
