


int func()
{
	far	char *ptr;

	return *ptr;
}

int func2()
{
	far	char *ptr;

	return *ptr++;
}

int func3()
{
	far	char *ptr;

	return *++ptr;
}

int func4()
{
	far char *ptr;

	return ptr[3];
}

int func5(far char *ptr, char val)
{
	*ptr = val;
	func5(ptr,1);
}

int func6()
{
	char   *ptr;
	func5(ptr,1);
}

struct x {
	int	y;
	char	buf[10];
	int	z;
};

void func7()
{
	far struct x *ptr;

	ptr->z = 1;
}

