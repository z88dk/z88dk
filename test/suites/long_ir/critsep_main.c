#include "test.h"

extern int crit_sep(int n);

static void test_sep(void)
{
    assertEqual(crit_sep(6), 15);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Statement __critical, separate compilation");
    suite_add_test(test_sep);
    return suite_run();
}
