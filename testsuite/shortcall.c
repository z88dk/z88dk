

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

