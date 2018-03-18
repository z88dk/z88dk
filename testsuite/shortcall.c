

extern int scall(long x, int y) __z88dk_shortcall(8, 200);
extern int scall2(long x, int y) __z88dk_shortcall(8, 2000);

int func() 
{
   return scall(1L, 2);
}

int func2() 
{
   return scall2(1L, 2);
}

int func3() 
{
	int (*funcptr)(long x, int y) = scall;

	return funcptr(2L, 3);
}

	
