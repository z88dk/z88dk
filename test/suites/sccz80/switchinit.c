/* Issue 2440. Jumping to a case does not run an initializer.
   Reaching the declaration still does. */
#include "test.h"

static int jump_aggregate(void)
{
    volatile int a;

    a = 1234;
    switch (a) {
        char buf[8] = {1, 2, 3, 4, 5, 6, 7, 8};
        case 1234:
            buf[0] = 42;
            buf[7] = 42;
            if (a != 1234 || buf[0] != 42 || buf[7] != 42)
                return 0;
            break;
    }
    return a == 1234;
}

static int jump_scalar(void)
{
    volatile int a;

    a = 9;
    switch (3) {
        int b = 5;
        case 3:
            b = 6;
            if (a != 9 || b != 6)
                return 0;
            break;
    }
    return a == 9;
}

static int fall_init(void)
{
    volatile int a;

    a = 50;
    switch (1) {
    case 1:
        {
            char buf[4] = {1, 2, 3, 4};
            if (a != 50)
                return 0;
            if (buf[0] != 1 || buf[1] != 2 || buf[2] != 3 || buf[3] != 4)
                return 0;
        }
        break;
    }
    return a == 50;
}

static int jump_inner_init(void)
{
    volatile int a;

    a = 50;
    switch (2) {
    case 1:
        {
            char buf[4] = {1, 2, 3, 4};
            if (buf[0] != 1 || buf[3] != 4)
                return 0;
            case 2:
                buf[0] = 9;
                if (a != 50 || buf[0] != 9)
                    return 0;
        }
        break;
    }
    return a == 50;
}

void test_jump_aggregate(void)
{
    Assert(jump_aggregate(), "jump aggregate");
}

void test_jump_scalar(void)
{
    Assert(jump_scalar(), "jump scalar");
}

void test_fall_init(void)
{
    Assert(fall_init(), "fall init");
}

void test_jump_inner_init(void)
{
    Assert(jump_inner_init(), "jump inner init");
}

int suite_switchinit(void)
{
    suite_setup("Switch init Tests");
    suite_add_test(test_jump_aggregate);
    suite_add_test(test_jump_scalar);
    suite_add_test(test_fall_init);
    suite_add_test(test_jump_inner_init);
    return suite_run();
}

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;
    exit(suite_switchinit());
}
