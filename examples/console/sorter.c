/*  Small C+ Insertion sort!
 *
 *  Joe Mackay 3/2/1999
 */

#include <stdio.h>

#define SIZE    100

void printarray(int A[]);

int main()
{
        int A[SIZE], i, j, tmp;

        /* Fill array with descending numbers (worst case) */
        i=0;
        while (i<SIZE)
                A[i] = SIZE-i++;

        /* Print initial state of array */
        puts("Before:");
        printarray(A);

        /* Now, er, sort it */
        for (i=1; i<SIZE; i++)
        {
                tmp = A[i];
                j=i;
                while (j!=0 && A[j-1]>tmp)
                        A[j]=A[--j];
                A[j] = tmp;
        }

        /* Print sorted version */
        puts("After:");
        printarray(A);
	return 0;
}

void printarray(int A[])
{
        int i;

        i=0;
        while (i<SIZE)
        {
                printf("%d ", A[i++]);
        }
        puts("");
}
