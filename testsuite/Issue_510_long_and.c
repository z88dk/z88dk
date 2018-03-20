

void func1()
{
	long l = 0;
	l &= 0xFFFFFF12;
}

void func2()
{
	long l = 0;
	l &= 0xFFFF12FF;
}
void func3()
{
	long l = 0;
	l &= 0xFF12FFFF;
}
void func4()
{
	long l = 0;
	l &= 0x12FFFFFF;
}
void func5()
{
	long l = 0;
	l &= 0x12345678;
}
void func6()
{
	long l = 0;
	l &= 0xFFFFFF12;
}
