#include "test.h"
#include <stdio.h>
#include <stdlib.h>

typedef struct test_s test_t;

struct test_s {
	int     a;
	int	b;
	long	c;
	double	d;
	char	array[20];
	int	*f;
	char	*g;
};

void test_offset_of()
{
    assertEqual(0, __builtin_offsetof(test_s, a));
    assertEqual(2, __builtin_offsetof(test_s, b));
    assertEqual(4, __builtin_offsetof(test_s, c));
    assertEqual(8, __builtin_offsetof(test_s, d));
    assertEqual(14, __builtin_offsetof(test_s, array));
    assertEqual(34, __builtin_offsetof(test_s, f));
    assertEqual(36, __builtin_offsetof(test_s, g));
}

void test_offset_of_typedef()
{
    assertEqual(0, __builtin_offsetof(test_t, a));
    assertEqual(2, __builtin_offsetof(test_t, b));
    assertEqual(4, __builtin_offsetof(test_t, c));
    assertEqual(8, __builtin_offsetof(test_t, d));
    assertEqual(14, __builtin_offsetof(test_t, array));
    assertEqual(34, __builtin_offsetof(test_t, f));
    assertEqual(36, __builtin_offsetof(test_t, g));
}

static struct test_s glb;
void test_offset_of_variable()
{
    static struct test_s stc;
    struct test_s loc;
    struct test_s *locptr;

    assertEqual(0, __builtin_offsetof(loc, a));
    assertEqual(2, __builtin_offsetof(locptr, b));
    assertEqual(14, __builtin_offsetof(stc, array));
    assertEqual(34, __builtin_offsetof(glb, f));
}

int suite_offsetof()
{
    suite_setup("Offsetof Tests");
    suite_add_test(test_offset_of);
    suite_add_test(test_offset_of_typedef);
    suite_add_test(test_offset_of_variable);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_offsetof();

    exit(res);
}
