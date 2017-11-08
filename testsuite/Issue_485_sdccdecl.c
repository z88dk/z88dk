

int func(char v,char x) __z88dk_sdccdecl
{
	return v + x;
}


void func2()
{
	func(1,2);
}

extern int a;
extern char compute(void) __z88dk_sdccdecl;
extern unsigned char compute2(void) __z88dk_sdccdecl;

void func3()
{
        a = compute();
}

void func4()
{
        a = compute2();
}
