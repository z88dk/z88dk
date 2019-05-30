

void func1(int a);
void func2(int a);


void callit(int val)
{
	(val ? func1 : func2)(val);
}
