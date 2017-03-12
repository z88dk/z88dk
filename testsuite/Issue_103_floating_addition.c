#include <stdio.h>

double add_int()
{
	double x = 1.0;
	x += 2;
	return x;
}

double add_int_longform()
{
	double x = 1.0;
	x = x + 2;
	return x;
}

double add_int_longform2()
{
	double x = 1.0;
	x = 2 +  x;
	return x;
}


double add_double()
{
	double x = 1.0;
	x += 2.0;
	return x;
}

double sub_int()
{
	double x = 2.0;
	x -= 1;
	return x;
}

double sub_int_longform()
{
	double x = 2.0;
	x =  x - 1;
	return x;
}

double sub_int_longform2()
{
	double x = 2.0;
	x =  1 - x;
	return x;
}

double sub_double()
{
	double x = 2.0;
	x -= 1.0;
	return x;
}

double mult_int()
{
	double x = 1.0;
	x *= 2;
	return x;
}
double mult_double()
{
	double x = 1.0;
	x *= 2.0;
	return x;
}
double mult_double_longform()
{
	double x = 1.0;
	x = x * 2;
	return x;
}
double mult_double_longform2()
{
	double x = 1.0;
	x = 2 * x;
	return x;
}



double div_int()
{
	double x = 1.0;
	x /= 2;
	return x;
}

double div_double()
{
	double x = 1.0;
	x /= 2.0;
	return x;
}
double div_double_longform()
{
	double x = 1.0;
	x = x / 2;
	return x;
}
double div_double_longform2()
{
	double x = 2.0;
	x = 1 / x;
	return x;
}




int main()
{
	printf("add_int %f\n",add_int());
	printf("add_int_longform %f\n",add_int_longform());
	printf("add_int_longform2 %f\n",add_int_longform2());
	printf("add_double %f\n",add_double());
	printf("sub_int %f\n",sub_int());
	printf("sub_int_longform %f\n",sub_int_longform());
	printf("sub_double %f\n",sub_double());
	printf("sub_int_longform2 %f\n",sub_int_longform2());
	printf("mult_int %f\n",mult_int());
	printf("mult_double %f\n",mult_double());
	printf("mult_double_longform %f\n",mult_double_longform());
	printf("mult_double_longform2 %f\n",mult_double_longform2());
	printf("div_int %f\n",div_int());
	printf("div_double %f\n",div_double());
	printf("div_double_longform %f\n",div_double_longform());
	printf("div_double_longform2 %f\n",div_double_longform2());
}
