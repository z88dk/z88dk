/* Issue 2440: a local declared in a switch block is allocated before the
   case label. The dispatcher jumps to the label and skips that allocation,
   then the block exit frees it anyway and corrupts the caller's locals.
*/
#include "test.h"

static void fill(char *p, int n, char v)
{
    int i;
    for (i = 0; i < n; i++) p[i] = v;
}

void test_issue_unused(void)
{
    volatile int a = 1234;
    switch (a) {
        char switchbuf[32];
        case 1234:
            Assert(a == 1234, "unused inside");
            (void)switchbuf;
            break;
    }
    Assert(a == 1234, "unused after");
}

void test_issue_used(void)
{
    volatile int a = 1234;
    switch (a) {
        char switchbuf[32];
        case 1234:
            fill(switchbuf, 32, 0x5a);
            Assert(a == 1234, "used inside");
            Assert(switchbuf[0] == 0x5a && switchbuf[31] == 0x5a, "used buf");
            break;
    }
    Assert(a == 1234, "used after");
}

void test_scalar(void)
{
    volatile int a = 1234;
    switch (a) {
        int b;
        case 1234:
            b = 5;
            Assert(a == 1234 && b == 5, "scalar");
            break;
    }
    Assert(a == 1234, "scalar after");
}

void test_second_case(void)
{
    volatile int a = 7;
    switch (2) {
        char buf[16];
        case 1:
            buf[0] = 1;
            Assert(a == 7, "case 1");
            break;
        case 2:
            fill(buf, 16, 2);
            Assert(a == 7, "case 2");
            Assert(buf[0] == 2 && buf[15] == 2, "case 2 buf");
            break;
    }
    Assert(a == 7, "second after");
}

void test_fall(void)
{
    volatile int a = 5;
    int n = 0;
    switch (a) {
        char buf[8];
        case 5:
            buf[0] = 1;
            n = 1;
        case 9:
            buf[1] = 2;
            Assert(a == 5, "fall a");
            Assert(buf[0] == 1 && buf[1] == 2, "fall buf");
            n++;
            break;
    }
    Assert(n == 2 && a == 5, "fall after");
}

void test_nested_block(void)
{
    volatile int a = 9;
    switch (2) {
    case 1:
        {
            char buf[40];
            fill(buf, 40, 3);
            Assert(a == 9 && buf[39] == 3, "nested block");
        }
        break;
    case 2:
        Assert(a == 9, "other case");
        break;
    }
    Assert(a == 9, "nested after");
}

void test_jump_in(void)
{
    volatile int a = 4;
    switch (2) {
    case 1:
        {
            char buf[16];
            int i;
            case 2:
                for (i = 0; i < 16; i++) buf[i] = 7;
                Assert(a == 4, "jump a");
                Assert(buf[0] == 7 && buf[15] == 7, "jump buf");
        }
        break;
    }
    Assert(a == 4, "jump after");
}

void test_jump_fall(void)
{
    volatile int a = 4;
    switch (1) {
    case 1:
        {
            char buf[16];
            int i;
            buf[3] = 1;
            case 3:
                for (i = 0; i < 16; i++) if (i != 3) buf[i] = 7;
                Assert(a == 4, "jfall a");
                Assert(buf[3] == 1 && buf[0] == 7, "jfall buf");
        }
        break;
    }
    Assert(a == 4, "jfall after");
}

void test_char(void)
{
    volatile int a = 50;
    char c = 3;
    switch (c) {
        char buf[12];
        case 3:
            buf[0] = 9;
            Assert(a == 50 && buf[0] == 9, "char");
            break;
    }
    Assert(a == 50, "char after");
}

void test_default(void)
{
    volatile int a = 8;
    switch (a) {
        char buf[10];
        case 1:
            break;
        default:
            buf[0] = 4;
            Assert(a == 8 && buf[0] == 4, "default");
            break;
    }
    Assert(a == 8, "default after");
}

void test_nest(void)
{
    volatile int a = 2;
    switch (a) {
        char outer[20];
        case 2:
            outer[0] = 1;
            switch (a) {
                char inner[12];
                case 2:
                    inner[0] = 6;
                    Assert(a == 2 && outer[0] == 1 && inner[0] == 6, "nest");
                    break;
            }
            Assert(a == 2 && outer[0] == 1, "nest outer");
            break;
    }
    Assert(a == 2, "nest after");
}

void test_long(void)
{
    volatile int a = 11;
    long v = 100000L;
    switch (v) {
        char buf[8];
        case 100000L:
            buf[0] = 3;
            Assert(a == 11 && buf[0] == 3, "long");
            break;
    }
    Assert(a == 11, "long after");
}

void test_outside(void)
{
    volatile int a = 1234;
    char buf[32];
    switch (a) {
    case 1234:
        buf[0] = 1;
        Assert(a == 1234 && buf[0] == 1, "outside");
        break;
    }
    Assert(a == 1234, "outside after");
}

void test_duff(void)
{
    char from[8], to[8];
    int i, count, n;
    char *t, *f;
    for (i = 0; i < 8; i++) { from[i] = (char)(i + 1); to[i] = 0; }
    count = 8;
    n = (count + 7) / 8;
    t = to;
    f = from;
    switch (count % 8) {
    case 0: do { *t++ = *f++;
    case 7:      *t++ = *f++;
    case 6:      *t++ = *f++;
    case 5:      *t++ = *f++;
    case 4:      *t++ = *f++;
    case 3:      *t++ = *f++;
    case 2:      *t++ = *f++;
    case 1:      *t++ = *f++;
               } while (--n > 0);
    }
    for (i = 0; i < 8; i++) Assert(to[i] == from[i], "duff");
}

int suite_switchscope(void)
{
    suite_setup("Switch scope Tests");
    suite_add_test(test_issue_unused);
    suite_add_test(test_issue_used);
    suite_add_test(test_scalar);
    suite_add_test(test_second_case);
    suite_add_test(test_fall);
    suite_add_test(test_nested_block);
    suite_add_test(test_jump_in);
    suite_add_test(test_jump_fall);
    suite_add_test(test_char);
    suite_add_test(test_default);
    suite_add_test(test_nest);
    suite_add_test(test_long);
    suite_add_test(test_outside);
    suite_add_test(test_duff);
    return suite_run();
}

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;
    exit(suite_switchscope());
}
