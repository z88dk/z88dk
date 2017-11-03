
struct x {
	char	a,b,d;
};

int ptr_char()
{
	char	*ptr1 = 0;
	char	*ptr2 = 0;

	ptr1 = ptr2 - 2;

	return	ptr2 - ptr1;
}

int ptr_int()
{
	int	*ptr1 = 0;
	int 	*ptr2 = 0;

	ptr1 = ptr2 - 2;

	return	ptr2 - ptr1;
}

int ptr_long()
{
	long	*ptr1 = 0;
	long	*ptr2 = 0;

	ptr1 = ptr2 - 2;

	return	ptr2 - ptr1;
}

int ptr_double()
{
	double	*ptr1 = 0;
	double	*ptr2 = 0;

	ptr1 = ptr2 - 2;

	return	ptr2 - ptr1;
}

int ptr_struct()
{
	struct x *ptr1 = 0;
	struct x *ptr2 = 0;

	ptr1 = ptr2 - 2;

	return ptr2 - ptr1;
}

static struct x array[10];

int struct_offset1()
{
	struct x *ptr1;
	int    c;

	return ptr1 - array;
}

int struct_offset2()
{
	struct x *ptr1;
	int    c;

	return ptr1 - &array[0];
}
int struct_offset3()
{
	struct x *ptr1;
	int    c;

	return ptr1 - (char *)&array[0];
}

