


#include <stdio.h>

void func(double x) 
{
}

void test ()
{
	double	y = 3.0;

	func(y - 2.0);
	func(y - 2);
	func(2.0 - y );
	func(2 - y );
}
