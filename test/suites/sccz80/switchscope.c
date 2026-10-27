/* Issue 2440: a local declared in a switch block is allocated before the
   case label. The dispatcher jumps to the label and skips that allocation,
   then the block exit frees it anyway and corrupts the caller's locals.
*/
#include "test.h"

struct swpkt {
    char b[7];
    int n;
};

static void fill(char *p, int n, char v)
{
    int i;
    for (i = 0; i < n; i++) p[i] = v;
}

static int id(int x)
{
    char tmp[16];
    volatile int y;

    y = x;
    fill(tmp, 16, 4);
    return y + tmp[0] - 4;
}

static int sum3(int x, int y, int z)
{
    volatile int s;

    s = x + y + z;
    return s;
}

static int duff_copy(int count)
{
    char from[16], to[16];
    int i, n;
    char *t, *f;

    for (i = 0; i < count; i++) {
        from[i] = (char)(i + 1);
        to[i] = 0;
    }
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
    for (i = 0; i < count; i++)
        if (to[i] != from[i])
            return 0;
    return 1;
}

/* Scratch is reserved before case 0, so every residue enters it once.
   The do jumps to its own top, which is after that reservation. */
static int duff_scratch(int count)
{
    char from[16], to[16];
    int i, n;
    char *t, *f;
    volatile int guard;

    guard = 4321;
    for (i = 0; i < count; i++) {
        from[i] = (char)(i + 3);
        to[i] = 0;
    }
    n = (count + 7) / 8;
    t = to;
    f = from;
    switch (count % 8) {
        char scratch[4];
        case 0: do { *t++ = *f++;
        case 7:      *t++ = *f++;
        case 6:      *t++ = *f++;
        case 5:      *t++ = *f++;
        case 4:      *t++ = *f++;
        case 3:      *t++ = *f++;
        case 2:      *t++ = *f++;
        case 1:      *t++ = *f++;
                     scratch[0] = 11;
                     scratch[3] = 22;
                     if (scratch[0] != 11 || scratch[3] != 22)
                         guard = 0;
               } while (--n > 0);
    }
    if (guard != 4321)
        return 0;
    for (i = 0; i < count; i++)
        if (to[i] != from[i])
            return 0;
    return 1;
}

/* The scratch declaration is inside the loop, textually before the
   later case labels. A direct entry skips it; the next iteration
   runs it. */
static int duff_inner(int count)
{
    char from[16], to[16];
    int i, n;
    char *t, *f;
    volatile int guard;

    guard = 1234;
    for (i = 0; i < count; i++) {
        from[i] = (char)(i + 1);
        to[i] = 0;
    }
    n = (count + 3) / 4;
    t = to;
    f = from;
    switch (count % 4) {
    case 0:
        do {
            char scratch[6];
            scratch[0] = 1;
            *t++ = *f++;
    case 3:
            *t++ = *f++;
    case 2:
            *t++ = *f++;
    case 1:
            *t++ = *f++;
            scratch[5] = 4;
            if (scratch[5] != 4)
                guard = 0;
        } while (--n > 0);
    }
    if (guard != 1234)
        return 0;
    for (i = 0; i < count; i++)
        if (to[i] != from[i])
            return 0;
    return 1;
}

static int between(int sel)
{
    volatile int a;

    a = 77;
    switch (sel) {
        char b1[10];
        case 1:
            fill(b1, 10, 1);
            if (a != 77 || b1[0] != 1 || b1[9] != 1)
                return 0;
            {
                char b2[24];
                case 2:
                    fill(b1, 10, 8);
                    fill(b2, 24, 2);
                    if (a != 77 || b1[9] != 8 || b2[0] != 2 || b2[23] != 2)
                        return 0;
            }
            break;
    }
    return a == 77;
}

static int ret_case(int x)
{
    volatile int a;

    a = x;
    switch (a) {
        char buf[40];
        case 7:
            fill(buf, 40, 3);
            return a + buf[0] + buf[39];
        default:
            fill(buf, 40, 1);
            return -a;
    }
}

static int blow(int n)
{
    volatile int a;

    a = n;
    switch (n & 3) {
        char buf[48];
        case 0:
        case 1:
        case 2:
        case 3:
            fill(buf, 48, (char)n);
            if (n == 0)
                return buf[0] == 0 && buf[47] == 0;
            {
                int r;

                r = blow(n - 1);
                if (a != n)
                    return 0;
                if (buf[0] != (char)n || buf[47] != (char)n)
                    return 0;
                return r + 1;
            }
    }
    return 0;
}

static int cont_sum(void)
{
    int i, s;
    volatile int guard;

    guard = 99;
    s = 0;
    for (i = 0; i < 4; i++) {
        volatile int a;

        a = i;
        switch (a) {
            char buf[28];
            case 0:
            case 1:
            case 2:
            case 3:
                fill(buf, 28, (char)(i + 1));
                if (a != i)
                    return -1;
                if (buf[0] != (char)(i + 1) || buf[27] != (char)(i + 1))
                    return -2;
                s += i;
                continue;
        }
        return -3;
    }
    if (guard != 99)
        return -4;
    return s;
}

static int via_goto(int sel)
{
    volatile int a;

    a = 1234;
    if (sel == 0)
        goto inside;
    switch (sel) {
        char buf[20];
        case 1:
            fill(buf, 20, 1);
            if (a != 1234 || buf[0] != 1 || buf[19] != 1)
                return 0;
            break;
        case 2:
        inside:
            fill(buf, 20, 6);
            if (a != 1234 || buf[0] != 6 || buf[19] != 6)
                return 0;
            break;
    }
    return a == 1234;
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
    int count;
    for (count = 1; count <= 16; count++)
        Assert(duff_copy(count), "duff");
}

void test_duff_scratch(void)
{
    int count;
    for (count = 1; count <= 16; count++)
        Assert(duff_scratch(count), "duff scratch");
}

void test_duff_inner(void)
{
    int count;
    for (count = 1; count <= 16; count++)
        Assert(duff_inner(count), "duff inner");
}

void test_between(void)
{
    Assert(between(1), "between fall");
    Assert(between(2), "between jump");
}

void test_sizes(void)
{
    volatile int a;
    a = 1234;
    switch (a) {
        char b1[1];
        case 1234:
            b1[0] = 3;
            Assert(a == 1234 && b1[0] == 3, "size 1");
            break;
    }
    switch (a) {
        char b3[3];
        case 1234:
            fill(b3, 3, 3);
            Assert(a == 1234 && b3[0] == 3 && b3[2] == 3, "size 3");
            break;
    }
    switch (a) {
        char b4[4];
        case 1234:
            fill(b4, 4, 4);
            Assert(a == 1234 && b4[3] == 4, "size 4");
            break;
    }
    switch (a) {
        char b10[10];
        case 1234:
            fill(b10, 10, 10);
            Assert(a == 1234 && b10[9] == 10, "size 10");
            break;
    }
    switch (a) {
        char b11[11];
        case 1234:
            fill(b11, 11, 11);
            Assert(a == 1234 && b11[10] == 11, "size 11");
            break;
    }
    switch (a) {
        char b31[31];
        case 1234:
            fill(b31, 31, 31);
            Assert(a == 1234 && b31[0] == 31 && b31[30] == 31, "size 31");
            break;
    }
    Assert(a == 1234, "sizes after");
}

void test_struct(void)
{
    volatile int a;
    a = 1234;
    switch (a) {
        struct swpkt p;
        case 1234:
            p.n = a;
            p.b[0] = 1;
            p.b[6] = 2;
            Assert(a == 1234 && p.n == 1234 && p.b[0] == 1 && p.b[6] == 2, "struct");
            break;
    }
    Assert(a == 1234, "struct after");
}

void test_expr(void)
{
    volatile int a;
    volatile int b;
    int sink;

    a = 1234;
    b = 1000;
    sink = 0;
    switch (id(a)) {
        char buf[32];
        case 1234:
            fill(buf, 32, 5);
            Assert(a == 1234 && buf[0] == 5 && buf[31] == 5, "call expr");
            break;
    }
    Assert(a == 1234, "call expr after");
    switch (a + b) {
        char buf[18];
        case 2234:
            fill(buf, 18, 6);
            Assert(a == 1234 && b == 1000 && buf[0] == 6 && buf[17] == 6, "add expr");
            break;
    }
    Assert(a == 1234 && b == 1000, "add expr after");
    switch (sink = a, a) {
        char buf[8];
        case 1234:
            fill(buf, 8, 7);
            Assert(a == 1234 && sink == 1234 && buf[7] == 7, "comma expr");
            break;
    }
    Assert(a == 1234 && sink == 1234, "comma expr after");
}

void test_return(void)
{
    volatile int g;
    int r;

    g = 50;
    r = ret_case(7);
    Assert(r == 7 + 3 + 3 && g == 50, "return case");
    r = ret_case(4);
    Assert(r == -4 && g == 50, "return default");
}

void test_recurse(void)
{
    volatile int g;

    g = 99;
    Assert(blow(0) == 1, "recurse 0");
    Assert(g == 99, "recurse 0 after");
    Assert(blow(6) == 7, "recurse 6");
    Assert(g == 99, "recurse 6 after");
}

void test_continue(void)
{
    Assert(cont_sum() == 6, "continue");
}

void test_loop(void)
{
    volatile int a;
    int i;

    a = 1234;
    for (i = 0; i < 20; i++) {
        switch (a) {
            char buf[32];
            case 1234:
                fill(buf, 32, (char)i);
                Assert(a == 1234 && buf[0] == (char)i && buf[31] == (char)i, "loop");
                break;
        }
    }
    Assert(a == 1234, "loop after");
}

void test_goto(void)
{
    Assert(via_goto(1), "goto case");
    Assert(via_goto(2), "goto label");
    Assert(via_goto(0), "goto in");
}

void test_empty(void)
{
    volatile int a;

    a = 1234;
    switch (a) {
    }
    switch (a) {
    default:
        break;
    }
    Assert(a == 1234, "empty");
}

void test_static(void)
{
    volatile int a;

    a = 1234;
    switch (a) {
        static char buf[4];
        case 1234:
            buf[0] = 7;
            buf[3] = 8;
            Assert(a == 1234 && buf[0] == 7 && buf[3] == 8, "static");
            break;
    }
    Assert(a == 1234, "static after");
}

void test_callout(void)
{
    volatile int a;

    a = 1234;
    switch (a) {
        char buf[64];
        case 1234:
            fill(buf, 64, 9);
            Assert(sum3(a, buf[0], 2) == 1234 + 9 + 2, "callout");
            Assert(a == 1234 && buf[0] == 9 && buf[63] == 9, "callout buf");
            break;
    }
    Assert(a == 1234, "callout after");
}

void test_break_deep(void)
{
    volatile int a;

    a = 1234;
    switch (a) {
        char buf[16];
        case 1234:
            {
                char inner[24];
                fill(buf, 16, 1);
                fill(inner, 24, 2);
                Assert(a == 1234 && buf[15] == 1 && inner[23] == 2, "deep");
                break;
            }
    }
    Assert(a == 1234, "deep after");
}

void test_default_fall(void)
{
    volatile int a;

    a = 3;
    switch (a) {
        char buf[10];
        default:
            fill(buf, 10, 1);
        case 9:
            buf[0] = 2;
            Assert(a == 3 && buf[0] == 2 && buf[9] == 1, "def fall");
            break;
    }
    Assert(a == 3, "def fall after");
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
    suite_add_test(test_duff_scratch);
    suite_add_test(test_duff_inner);
    suite_add_test(test_between);
    suite_add_test(test_sizes);
    suite_add_test(test_struct);
    suite_add_test(test_expr);
    suite_add_test(test_return);
    suite_add_test(test_recurse);
    suite_add_test(test_continue);
    suite_add_test(test_loop);
    suite_add_test(test_goto);
    suite_add_test(test_empty);
    suite_add_test(test_static);
    suite_add_test(test_callout);
    suite_add_test(test_break_deep);
    suite_add_test(test_default_fall);
    return suite_run();
}

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;
    exit(suite_switchscope());
}
