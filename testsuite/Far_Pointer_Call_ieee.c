
char *(*__far funcptr)(double val, int id);
char *__far(*__far funcptr2)(double val, int id);

int func() 
{
	return *funcptr(1., 2);
}


    
int func2() 
{
	return *funcptr2(1., 2);
}
