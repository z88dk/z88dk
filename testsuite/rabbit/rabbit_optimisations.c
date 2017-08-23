

int getviapointer(int *x)
{
    return *x;
}

int mult()
{
	int	a,b;

	return  a * b;
}

int negate(int a)
{
    return -a;
}

int or(int a, int b)
{
    int x = a | b;
    x = a | 0xff;

    return a | 0x1ff;
}

int and(int a, int b)
{
    int x = a & b;
    x = a & 0xff;

    return a & 0x1ff;
}

int rshift(unsigned int a)
{
    return a >> 1;
}
int lshift(unsigned int a)
{
    return a << 1;
}

int lshift_long(unsigned long l)
{
    long r = l << 1;
    r = l << 2;
    r = l << 3;
    return 0;
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



