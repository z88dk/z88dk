/* Small recursive program that calculates Fibonacci numbers.
 *
 * This program was originally featured in the "Embedded Systems Magazine"
 * April 1989
 */

#include <stdio.h>
#pragma string name Fibonacci numbers

int fib(int n);
unsigned results[11];

int main()
{
	int loop;
	for (loop=1; loop < 10; loop++)
	{
		results[loop] = fib(loop);
		printf("fib(%d) = %d\n",loop,results[loop]);
	}
	return 0;
}

int fib(int n)
{
	if (n <= 2) return 1;
	return fib(n-1) + fib(n-2);
}
