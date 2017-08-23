


int mult()
{
	int	a,b;

	return  a * b;
}

int addition(int a)
{
	int b = a + 10;

	mult();

	return b;
}

int subtract(int a)
{
	int b = a - 10;

	mult();

	return b;
}


long longops(long l)
{
	return l++;
}

long longadd(long l)
{
	return l + 10;
}

long longadd_negative(long l)
{
	long x = l + - 20;
	return l + -50000;
}

long longsub(long l)
{
	long x = l - 20;
	return l -50000;
}


extern void longfunc(long l, int i);
int longcall()
{
    longfunc(10000L, 10);
}



extern void anotherfunc(int, int, int);

long pushinstr()
{
	anotherfunc(1,2,3);
}



