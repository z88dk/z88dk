

extern int scall(long x, int y) __z88dk_shortcall(8, 200);
extern int scall2(long x, int y) __z88dk_shortcall(8, 2000);
extern int hlcall1(long x, int y) __z88dk_shortcall_hl(8, 5000);
extern int hlcall2(long x, int y) __z88dk_hl_call(2000, 5000);
extern int hlcall3(long x) __z88dk_shortcall_hl(8, 5000) __z88dk_fastcall;
extern int hlcall4(long x) __z88dk_hl_call(2000, 5000) __z88dk_fastcall;

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

int hlfunc1()
{
    return hlcall1(1L, 2);
}

int hlfunc2()
{
    return hlcall2(1L, 2);
}

int hlfunc3()
{
    return hlcall3(1L);
}

int hlfunc4()
{
    return hlcall4(1L);
}
