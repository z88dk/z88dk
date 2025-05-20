


extern void func() __nonbanked;

struct y {
	int	a;
};

// Should be placed in code_home
void func() 
{
	// In data_compiler
	static struct y blah = { .a = 2 };
	// Back into code_home
	return 3;
}
