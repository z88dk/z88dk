#include "test.h"
#include <stdlib.h>

struct S3 { char a, b, c; };

int *bump2(int *p) { return ++p; }
long *bump4(long *p) { return ++p; }
char *bump1(char *p) { return ++p; }
struct S3 *bump3(struct S3 *p) { return ++p; }
int *back2(int *p) { return --p; }
long *back4(long *p) { return --p; }
int *post2(int *p) { return p++; }
long *post4(long *p) { return p++; }
void star2(int **pp) { ++*pp; }
void star4(long **pp) { ++*pp; }

void test_ptrinc(void)
{
    static int ibuf[4];
    static long lbuf[3];
    static char cbuf[4];
    static struct S3 sbuf[3];
    int *ip;
    long *lp;
    char *cp;
    struct S3 *sp;

    ip = ibuf;
    Assert(++ip == ibuf + 1, "int ++");
    Assert(ip == ibuf + 1, "int ++ store");
    Assert(--ip == ibuf, "int --");
    Assert(ip == ibuf, "int -- store");

    lp = lbuf;
    Assert(++lp == lbuf + 1, "long ++");
    Assert(lp == lbuf + 1, "long ++ store");
    Assert(--lp == lbuf, "long --");
    Assert(lp == lbuf, "long -- store");

    cp = cbuf;
    Assert(++cp == cbuf + 1, "char ++");
    Assert(cp == cbuf + 1, "char ++ store");

    sp = sbuf;
    Assert(++sp == sbuf + 1, "s3 ++");
    Assert(sp == sbuf + 1, "s3 ++ store");

    ip = ibuf;
    Assert(ip++ == ibuf, "int post");
    Assert(ip == ibuf + 1, "int post store");
    lp = lbuf;
    Assert(lp++ == lbuf, "long post");
    Assert(lp == lbuf + 1, "long post store");
    Assert(post2(ibuf) == ibuf, "int post fn");
    Assert(post4(lbuf) == lbuf, "long post fn");

    ip = ibuf;
    star2(&ip);
    Assert(ip == ibuf + 1, "int star");
    lp = lbuf;
    star4(&lp);
    Assert(lp == lbuf + 1, "long star");

    Assert(bump2((int *)0x1000) == (int *)0x1002, "int +2");
    Assert(back2((int *)0x1002) == (int *)0x1000, "int -2");
    Assert(bump4((long *)0x1000) == (long *)0x1004, "long +4");
    Assert(back4((long *)0x1000) == (long *)0x0ffc, "long -4");
    Assert(bump1((char *)0x1000) == (char *)0x1001, "char +1");
    Assert(bump3((struct S3 *)0x1000) == (struct S3 *)0x1003, "s3 +3");

    Assert(bump2((int *)0xfffe) == (int *)0x0000, "int wrap");
    Assert(bump4((long *)0xfffe) == (long *)0x0002, "long wrap");
    Assert(bump3((struct S3 *)0xfffe) == (struct S3 *)0x0001, "s3 wrap");
    Assert(back4((long *)0x0001) == (long *)0xfffd, "long wrap dec");
}

int suite_ptrinc(void)
{
    suite_setup("Wide pointer step");
    suite_add_test(test_ptrinc);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    (void)argc;
    (void)argv;
    res += suite_ptrinc();
    exit(res);
}
