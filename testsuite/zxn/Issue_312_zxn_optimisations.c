


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


extern void anotherfunc(int, int, int);

long pushinstr()
{
	anotherfunc(1,2,3);
}



