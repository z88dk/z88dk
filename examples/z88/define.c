/*
 * Small C+ Example of how to define static strings to minimize
 * memory use and generate correct code!
 *
 * This code doesn't actually do anything, it's just a code example
 *
 * djm 13/3/99
 */

/* Just in case you do want to compile this... */

#include <stdio.h>

struct strprt {
	char *j;
	char k[10];
};

/*
 * From v0.5 of the compiler, this definition now works correctly - a simple
 * rewrite of init() was required, previously it would fail spectacularly!
 * This bug was in the original Small C+
 */

struct strprt mystr2[2] = { {"Hello!","Hellohell"}, {"Hello","Hello"} };

/*
 * Correct amount of Space reserved for it in the static vars at the
 * end.
 */

char blah[1]="hello";



char *j={"Hello"};	/* stored in literal queue */
char *m[]={"Hello"};	/* stored in literal queue */
char *n="Hello";	/* stired in literal queue */
char k[]="Hello";	/* dumped where it is */
char o[10]="Hello";	/* dumped where it is (with padding) */
char *l[3]={"Hello","Hello"};	/* correctly stored and represented (litq) */

/*
 * This construct now works correctly, the bug was in the original
 * Small C+ Code, fixing the struct problem automatically fixed
 * this problem!
 */

char *p[3]="Hello";	/* As above.. */

/*
 * Now for some int testing! - If these work, then longs will as well!
 * The literal queue obviously isn't used for these because we can't
 * initialise pointers except for *ptr=0; - it makes sense ya know!
 */

int ij = 1;
int ik[]= { 1,2,3 };
int il[10]={ 1 };



main()
{
	/* Local statics follow the same rules as for global statics */
	static int l;		/* Dumped at end with other statics */
	static int k=2;		/* Dumped as defw */
	static char *j="Hello";	/* Stored in literal queue */
	puts("fish");
	puts("Hello");
	return;

}
