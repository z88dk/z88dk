
int i;

int func()
{
	return ((int *)64000)[i];
}

int func2()
{
	return ((int *)64000)[10];
}

int func3()
{
	return ((char *)64000)[i];
}

int func4()
{
	return ((char *)64000)[10];
}

int func5(int off)
{
	return ((char *)64000)[off];
}
