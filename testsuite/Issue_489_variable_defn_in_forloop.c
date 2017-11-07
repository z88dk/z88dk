void func2(int i);

void func()
{
	int	k;
	for ( int i = 0; i < 10; i++ ) {
		func2(i);
	}
	func2(100);
}

int func3()
{
	int	k;
	for ( long i = 0; i < 10; i++ ) {
		func2(i);
	}
	func2(100);
	return k;
}
