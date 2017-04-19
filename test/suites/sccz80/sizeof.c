#include "test.h"
#include <stdio.h>

void test_sizeof_types()
{
    assertEqual(1, sizeof(char));
    assertEqual(2, sizeof(int));
    assertEqual(2, sizeof(unsigned int));
    assertEqual(4, sizeof(long));
    assertEqual(6, sizeof(double));
    assertEqual(2, sizeof(char *));
    assertEqual(2, sizeof(int *));
    assertEqual(2, sizeof(long *));
    assertEqual(2, sizeof(double *));
}

void test_sizeof_primitives()
{
    char    c;
    int     i;
    long    l;
    double  d;
    char    *cp;
    int     *ip;
    long    *lp;
    double  *dp;

    assertEqual(1, sizeof(c));
    assertEqual(2, sizeof(i));
    assertEqual(4, sizeof(l));
    assertEqual(6, sizeof(d));

    /* Now pointers */
    assertEqual(2, sizeof(cp));
    assertEqual(2, sizeof(ip));
    assertEqual(2, sizeof(lp));
    assertEqual(2, sizeof(dp));

    /* Now deref the pointers */    
    assertEqual(1, sizeof(*cp));
    assertEqual(2, sizeof(*ip));
    assertEqual(4, sizeof(*lp));
    assertEqual(6, sizeof(*dp));
}


void test_sizeof_arrays()
{
    char    c[10];
    int     i[10];
    long    l[10];
    double  d[10];

    assertEqual(10, sizeof(c));
    assertEqual(20, sizeof(i));
    assertEqual(40, sizeof(l));
    assertEqual(60, sizeof(d));
}


void test_sizeof_ptrarrays()
{
    char    *c[10];
    int     *i[10];
    long    *l[10];
    double  *d[10];

    assertEqual(20, sizeof(c));
    assertEqual(20, sizeof(i));
    assertEqual(20, sizeof(l));
    assertEqual(20, sizeof(d));
    assertEqual(1, sizeof(*c[0]));
    assertEqual(2, sizeof(*i[0]));
    assertEqual(4, sizeof(*l[0]));
    assertEqual(6, sizeof(*d[0]));
}

void test_sizeof_misc()
{
    // Size of a function
    assertEqual(2, sizeof(test_sizeof_misc));
    assertEqual(6, sizeof("Hello"));
    assertEqual(1, sizeof(*"Hello"));
}

struct nested {
   char     c;
   int      i;
   long     l; 
   double   d;
};

struct st {
    char     c;
    int      i;
    long     l;
    double   d;
    char    *cp;
    int     *ip;
    long    *lp;
    double  *dp;
    int     *ia[10];
    struct nested nested1;
    struct nested *nestedp;
};

void test_sizeof_struct()
{
    struct st   val;

    assertEqual(56, sizeof(val));

    assertEqual(1, sizeof(val.c));
    assertEqual(2, sizeof(val.i));
    assertEqual(4, sizeof(val.l));
    assertEqual(6, sizeof(val.d));

    /* Now pointers */
    printf("Val cp %d\n",sizeof(val.cp));
    printf("Val lp %d\n",sizeof(val.lp));
    assertEqual(2, sizeof(val.cp));
    assertEqual(2, sizeof(val.ip));
    assertEqual(2, sizeof(val.lp));
    assertEqual(2, sizeof(val.dp));

    /* Now deref the pointers */    
    assertEqual(1, sizeof(*val.cp));
    assertEqual(2, sizeof(*val.ip));
    assertEqual(4, sizeof(*val.lp));
    assertEqual(6, sizeof(*val.dp));

    assertEqual(20, sizeof(val.ia));
    assertEqual(2, sizeof(*val.ia[0]));

    assertEqual(13, sizeof(val.nested1));
    assertEqual(2, sizeof(val.nestedp));
    assertEqual(13, sizeof(*val.nestedp));
    
}

int suite_sizeof()
{
    suite_setup("Sizeof Tests");
    suite_add_test(test_sizeof_types);
    suite_add_test(test_sizeof_primitives);
    suite_add_test(test_sizeof_arrays);
    suite_add_test(test_sizeof_ptrarrays);
    suite_add_test(test_sizeof_misc);
    suite_add_test(test_sizeof_struct);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_sizeof();

    exit(res);
}
