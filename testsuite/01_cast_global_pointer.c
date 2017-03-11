
char *a;

main()
{
   static char *c = 0;
   int *b;
   
   b = (int *)(a);
   b = ((int *)c);
}


int test(char *v)
{
	int *a = (int *)v;
	int x = 1;
}
