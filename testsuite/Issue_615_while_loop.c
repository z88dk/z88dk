
void func0();

int func() 
{
	while ( 1 ) {
		func0();
	}
}

int func1() 
{
	while ( 0 ) {
		func0();
	}
}

int func2() 
{
	int a;
	while ( a ) {
		func0();
	}
}
