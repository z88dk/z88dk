

#include <stdio.h>
#include "test.h"

#pragma scanf "%2d %u %x %c %s %B %o %ld %lu %lx %lc %ls %lB %lo %i %li %n"

/** \test Test %d handling of scanf() Test takes about 40 seconds to run
 */
void test_scanf_d()
{
    char    buf[100];
    int     i,j;
    unsigned int     failures = 0;
    unsigned int     success = 0;
        

    for ( i = -32767; i < 32767; i+=7 ) {
        j = -1;
        if ( i % 1000 == 0 ) {
            printf("%d ",i);
        }
        sprintf(buf,"%d",i);
        sscanf(buf,"%d",&j);
        if ( i != j ) {            
            sprintf(buf,"Failed conversion for %d != %d",i,j);
            Assert(0, buf);
        }
    }
}

void test_scanf_ws() 
{
	int      i, j, r;

        r = sscanf("12 \t\n32","%d %d",&i,&j);
        Assert(r == 2, "Expected to parse two values");
        Assert(i == 12, "Failed ot parse value 1");
        Assert(j == 32, "Failed ot parse value 2");
}

void test_scanf_c()
{
	char  c,d;

	sscanf("a b","%c %c", &c, &d);

        Assert(c == 'a', "c not matching");
        Assert(d == 'b', "d not matching");
}

void test_scanf_s()
{
	char	buf[20];

	sscanf("hellothere","%s", buf);

        Assert(strcmp(buf,"hellothere") == 0, "Full string match failed");

	sscanf("hellothere","%5s", buf);
        Assert(strcmp(buf,"hello") == 0, "Partial string match failed");
}

typedef struct {
   char *str;
   char *fmt;
   char *msg;
   int   ret;
   int   v1;
} nscanf;

static nscanf tests[] = {
   {"-32767", "%d", "%d -32767", 1, -32767},
   {"10000",  "%d", "%d 10000", 1, 10000},
   {"32768",  "%d", "%d 32768", 1, 32768},
   {"10000",  "%u", "%u 10000", 1, 10000},
   {"65535",  "%u", "%u 65535",  1, 65535},
   {"FFFF",   "%x", "%x ffff", 1, 65535},
   {"0x8000", "%x", "%x 0x8000", 1, 32768},
   {"0X7fff", "%x", "%x 0x7fff", 1, 32767},
   {"0123",   "%x", "%x 0123", 1, 0x123},
   {"0123",   "%o", "%o 0123", 1,83},
   {"123",    "%o", "%o 123", 1, 83},
   {"%111",   "%B", "%B 111",  1, 7},
   {"0123",   "%i", "%i 0123", 1, 83},
   {"0x7fff", "%i", "%i 0x7fff", 1, 32767},
   {"%111",   "%i", "%i 111",  1, 7},
   {"123",    "%i", "%i 111",  1, 123},
   {NULL, NULL, 0 }
};

void test_scanf_numeric() {
   nscanf *ns = &tests[0];

   while ( ns->str != NULL ) {
      int ret;
      int v1 = 0;

      ret = sscanf(ns->str, ns->fmt, &v1);
      Assert(v1== ns->v1, ns->msg);
      Assert(ret == ns->ret, "Incorrect return value");
      ns++;
   }
}

typedef struct {
   char *str;
   char *fmt;
   char *msg;
   int   ret;
   long  v1;
} nslcanf;

static nslcanf ltests[] = {
   {"-32767", "%ld", "%ld -32767", 1, -32767},
   {"10000",  "%ld", "%ld 10000", 1, 10000},
   {"32768",  "%ld", "%ld 32768", 1, 32768},
   {"10000",  "%lu", "%lu 10000", 1, 10000},
   {"65535",  "%lu", "%lu 65535",  1, 65535},
   {"FFFF",   "%lx", "%lx ffff", 1, 65535},
   {"0x8000", "%lx", "%lx 0x8000", 1, 32768},
   {"0X7fff", "%lx", "%lx 0x7fff", 1, 32767},
   {"ffffffff","%lx", "%lx 0xffffffff", 1, 0xffffffff},
   {"0123",   "%lx", "%lx 0123", 1, 0x123},
   {"0123",   "%lo", "%lo 0123", 1,83},
   {"123",    "%lo", "%lo 123", 1, 83},
   {"%111",   "%lB", "%lB 111",  1, 7},
   {"0123",   "%li", "%li 0123", 1, 83},
   {"0x7fff", "%li", "%li 0x7fff", 1, 32767},
   {"%111",   "%li", "%li 111",  1, 7},
   {"123",    "%li", "%li 111",  1, 123},
   {NULL, NULL, 0 }
};

void test_scanf_long_numeric() {
   nslcanf *ns = &ltests[0];

   while ( ns->str != NULL ) {
      int ret;
      long int v1 = 0;

      ret = sscanf(ns->str, ns->fmt, &v1);
      Assert(v1== ns->v1, ns->msg);
      Assert(ret == ns->ret, "Incorrect return value");
      ns++;
   }
}


void test_scanf_skip() {
    int   v1 = -2;
    int   ret = -2;

    ret = sscanf("skip 12","%*s %d",&v1);

    Assert(ret == 1, "Invalid number of conversions");
    Assert(v1 == 12, "%d parsed incorrectly");
}

void test_scanf_percent_n() {
    int   v1 = -2;
    int   v2 = -2;
    int   ret = -2;

    ret = sscanf("skip 12","%*s %d %n",&v1,&v2);
    Assert(ret == 1, "Invalid number of conversions");
    Assert(v1 == 12, "%d parsed incorrectly");
    Assert(v2 == 7, "%n parsed incorrectly");
}



int test_scanf()
{
    suite_setup("Scanf Tests");

//    suite_add_test(test_scanf_d);
    suite_add_test(test_scanf_c);
    suite_add_test(test_scanf_s);
    suite_add_test(test_scanf_ws);
    suite_add_test(test_scanf_numeric);
    suite_add_test(test_scanf_long_numeric);
    suite_add_test(test_scanf_skip);
    suite_add_test(test_scanf_percent_n);

    return suite_run();
}

int main(int argc, char *argv[])
{
    int  res = 0;

    res += test_scanf();

    return res;
}
