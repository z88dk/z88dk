
char *(*__far funcptr)(long val, int id);
char *__far(*__far funcptr2)(long val, int id);

int func() 
{
	return *funcptr(1L, 2);
}


    
int func2() 
{
	return *funcptr2(1L, 2);
}
