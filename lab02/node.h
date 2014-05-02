include"stdio.h"
struct node
{
	int token;
	char type[256];
	char content[256];
	int lineno;
	int column;
	struct node *mlc;
	struct node *rneighbor;
	void createnode(char *type,char *content);
}
