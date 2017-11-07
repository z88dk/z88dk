

int func_char()
{
	char	*ptr = 0;
	char	arr[5];
	return ptr - arr;
}


int func_int()
{
	int *ptr = 0;
	int arr[5];
	return ptr - arr;
}

int func_long()
{
	long	*ptr = 0;
	long	arr[5];
	return ptr - &arr[0];
}

int func_double()
{
	double	*ptr = 0;
	double  arr[5];
	return ptr - arr;
}

int func_double_static()
{
	double	*ptr = 0;
	static double  arr[5];
	return ptr - arr;
}
