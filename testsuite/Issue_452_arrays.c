
int func(int A[])
{
	int    i = 0;
	return A[i];
}


int func1()
{
	int	A[10];
	int    i = 0;
	return A[i];
}

int func2()
{
	static int	A[10]={0};
	int    i = 0;
	return A[i];
}

int func3()
{
	int	A[10];
	return A[2];
}

int multi1()
{
	int	A[2][10];

	return A[1][1];
}

int multi2()
{
	int	A[2][10];
	int	i = 0, j = 0;

	return A[i][j];
}
