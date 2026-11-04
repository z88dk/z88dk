#include "test.h"
#include <stdlib.h>

int igt0(int x) { return x > 0; }
int ige0(int x) { return x >= 0; }
int ilt0(int x) { return x < 0; }
int ile0(int x) { return x <= 0; }
int igt1(int x) { return x > 1; }
int ige1(int x) { return x >= 1; }
int ilt1(int x) { return x < 1; }
int ile1(int x) { return x <= 1; }
int igtm(int x) { return x > -1; }
int igem(int x) { return x >= -1; }
int iltm(int x) { return x < -1; }
int ilem(int x) { return x <= -1; }
int igtk(int x) { return x > 1000; }
int igek(int x) { return x >= 1000; }
int iltk(int x) { return x < 1000; }
int ilek(int x) { return x <= 1000; }
int igtn(int x) { return x > -1000; }
int igen(int x) { return x >= -1000; }
int iltn(int x) { return x < -1000; }
int ilen(int x) { return x <= -1000; }
int igtmax(int x) { return x > 32767; }
int igemax(int x) { return x >= 32767; }
int igtmin(int x) { return x > (int)0x8000; }
int igemin(int x) { return x >= (int)0x8000; }
int iltmin(int x) { return x < (int)0x8000; }
int ilemin(int x) { return x <= (int)0x8000; }

unsigned ule0(unsigned x) { return x <= 0; }
unsigned uge0(unsigned x) { return x >= 0; }
unsigned ugt0(unsigned x) { return x > 0; }
unsigned ult0(unsigned x) { return x < 0; }

int cge_m1(signed char x) { return x >= -1; }
int cgt_m1(signed char x) { return x > -1; }
int cle_m1(signed char x) { return x <= -1; }
int clt_m1(signed char x) { return x < -1; }
int cge0(signed char x) { return x >= 0; }
int cgt0(signed char x) { return x > 0; }
int cle0(signed char x) { return x <= 0; }
int clt0(signed char x) { return x < 0; }
int cgtmin(signed char x) { return x > (signed char)0x80; }
int cgemin(signed char x) { return x >= (signed char)0x80; }
int cgtmax(signed char x) { return x > 126; }
int cgemax(signed char x) { return x >= 127; }

void test_signcmp(void)
{
    int minv = (int)0x8000;
    int x;
    signed char c;
    unsigned u;

    assertEqual(igt0(minv), 0);
    assertEqual(igt0(-1), 0);
    assertEqual(igt0(0), 0);
    assertEqual(igt0(1), 1);
    assertEqual(igt0(32767), 1);
    assertEqual(ige0(minv), 0);
    assertEqual(ige0(0), 1);
    assertEqual(ige0(1), 1);
    assertEqual(ilt0(minv), 1);
    assertEqual(ilt0(0), 0);
    assertEqual(ilt0(-1), 1);
    assertEqual(ile0(minv), 1);
    assertEqual(ile0(-1), 1);
    assertEqual(ile0(0), 1);
    assertEqual(ile0(1), 0);

    assertEqual(igt1(0), 0);
    assertEqual(igt1(1), 0);
    assertEqual(igt1(2), 1);
    assertEqual(igt1(minv), 0);
    assertEqual(igt1(32767), 1);
    assertEqual(ige1(0), 0);
    assertEqual(ige1(1), 1);
    assertEqual(ige1(minv), 0);
    assertEqual(ilt1(0), 1);
    assertEqual(ilt1(1), 0);
    assertEqual(ilt1(minv), 1);
    assertEqual(ile1(0), 1);
    assertEqual(ile1(1), 1);
    assertEqual(ile1(2), 0);
    assertEqual(ile1(32767), 0);

    assertEqual(igtm(-1), 0);
    assertEqual(igtm(0), 1);
    assertEqual(igtm(minv), 0);
    assertEqual(igem(-1), 1);
    assertEqual(igem(-2), 0);
    assertEqual(igem(0), 1);
    assertEqual(iltm(-1), 0);
    assertEqual(iltm(-2), 1);
    assertEqual(iltm(minv), 1);
    assertEqual(ilem(-1), 1);
    assertEqual(ilem(0), 0);
    assertEqual(ilem(minv), 1);

    assertEqual(igtk(1000), 0);
    assertEqual(igtk(1001), 1);
    assertEqual(igtk(999), 0);
    assertEqual(igtk(minv), 0);
    assertEqual(igek(1000), 1);
    assertEqual(igek(999), 0);
    assertEqual(iltk(1000), 0);
    assertEqual(iltk(999), 1);
    assertEqual(ilek(1000), 1);
    assertEqual(ilek(1001), 0);
    assertEqual(igtn(-1000), 0);
    assertEqual(igtn(-999), 1);
    assertEqual(igtn(minv), 0);
    assertEqual(igen(-1000), 1);
    assertEqual(igen(-1001), 0);
    assertEqual(iltn(-1000), 0);
    assertEqual(iltn(-1001), 1);
    assertEqual(ilen(-1000), 1);
    assertEqual(ilen(-999), 0);

    assertEqual(igtmax(32767), 0);
    assertEqual(igtmax(32766), 0);
    assertEqual(igtmax(minv), 0);
    assertEqual(igemax(32767), 1);
    assertEqual(igemax(32766), 0);
    assertEqual(igtmin(minv), 0);
    assertEqual(igtmin((int)0x8001), 1);
    assertEqual(igtmin(32767), 1);
    assertEqual(igemin(minv), 1);
    assertEqual(iltmin(minv), 0);
    assertEqual(iltmin((int)0x8001), 0);
    assertEqual(ilemin(minv), 1);
    assertEqual(ilemin(0), 0);

    assertEqual(ule0(0), 1);
    assertEqual(ule0(1), 0);
    assertEqual(ule0(0x8000u), 0);
    assertEqual(ule0(0xffffu), 0);
    assertEqual(uge0(0), 1);
    assertEqual(uge0(0x8000u), 1);
    assertEqual(ugt0(0), 0);
    assertEqual(ugt0(0x8000u), 1);
    assertEqual(ult0(0), 0);
    assertEqual(ult0(0xffffu), 0);

    assertEqual(cge_m1((signed char)-128), 0);
    assertEqual(cge_m1((signed char)-2), 0);
    assertEqual(cge_m1((signed char)-1), 1);
    assertEqual(cge_m1(0), 1);
    assertEqual(cge_m1(127), 1);
    assertEqual(cgt_m1((signed char)-1), 0);
    assertEqual(cgt_m1(0), 1);
    assertEqual(cgt_m1((signed char)-128), 0);
    assertEqual(cle_m1((signed char)-1), 1);
    assertEqual(cle_m1((signed char)-2), 1);
    assertEqual(cle_m1(0), 0);
    assertEqual(clt_m1((signed char)-1), 0);
    assertEqual(clt_m1((signed char)-2), 1);
    assertEqual(clt_m1((signed char)-128), 1);
    assertEqual(cge0((signed char)-1), 0);
    assertEqual(cge0(0), 1);
    assertEqual(cgt0(0), 0);
    assertEqual(cgt0(1), 1);
    assertEqual(cgt0((signed char)-128), 0);
    assertEqual(cle0(0), 1);
    assertEqual(cle0(1), 0);
    assertEqual(cle0((signed char)-128), 1);
    assertEqual(clt0(0), 0);
    assertEqual(clt0((signed char)-1), 1);
    assertEqual(cgtmin((signed char)-128), 0);
    assertEqual(cgtmin((signed char)-127), 1);
    assertEqual(cgemin((signed char)-128), 1);
    assertEqual(cgtmax(126), 0);
    assertEqual(cgtmax(127), 1);
    assertEqual(cgemax(126), 0);
    assertEqual(cgemax(127), 1);

    asm("scf");
    assertEqual(ile0(1), 0);
    asm("scf");
    assertEqual(igt0(minv), 0);
    asm("scf");
    assertEqual(ige1(1), 1);
    asm("scf");
    assertEqual(ule0(0x8000u), 0);

    x = minv;
    asm("scf");
    if (x > 0) Assert(0, "min > 0");
    if (x >= 0) Assert(0, "min >= 0");
    if (x < 0) {} else Assert(0, "min < 0");
    if (x <= 0) {} else Assert(0, "min <= 0");
    if (x > (int)0x8000) Assert(0, "min > min");
    if (x >= (int)0x8000) {} else Assert(0, "min >= min");
    if (x < (int)0x8000) Assert(0, "min < min");
    if (x <= (int)0x8000) {} else Assert(0, "min <= min");

    x = 0;
    asm("scf");
    if (x > 0) Assert(0, "0 > 0");
    if (x >= 0) {} else Assert(0, "0 >= 0");
    if (x < 0) Assert(0, "0 < 0");
    if (x <= 0) {} else Assert(0, "0 <= 0");
    if (x > -1) {} else Assert(0, "0 > -1");
    if (x >= -1) {} else Assert(0, "0 >= -1");

    x = 1;
    if (x > 1) Assert(0, "1 > 1");
    if (x >= 1) {} else Assert(0, "1 >= 1");
    if (x < 1) Assert(0, "1 < 1");
    if (x <= 1) {} else Assert(0, "1 <= 1");

    x = 1000;
    if (x > 1000) Assert(0, "1000 > 1000");
    if (x >= 1000) {} else Assert(0, "1000 >= 1000");
    if (x < -1000) Assert(0, "1000 < -1000");
    if (x > -1000) {} else Assert(0, "1000 > -1000");
    x = -1000;
    if (x > -1000) Assert(0, "-1000 > -1000");
    if (x >= -1000) {} else Assert(0, "-1000 >= -1000");
    if (x < -1000) Assert(0, "-1000 < -1000");
    if (x <= -1000) {} else Assert(0, "-1000 <= -1000");

    x = 32767;
    if (x > 32767) Assert(0, "max > max");
    if (x >= 32767) {} else Assert(0, "max >= max");
    if (x > (int)0x8000) {} else Assert(0, "max > min");

    u = 0x8000u;
    asm("scf");
    if (u <= 0) Assert(0, "8000 <= 0");
    if (u > 0) {} else Assert(0, "8000 > 0");
    if (u >= 0) {} else Assert(0, "8000 >= 0");
    if (u < 0) Assert(0, "8000 < 0");
    u = 0;
    if (u <= 0) {} else Assert(0, "u0 <= 0");
    u = 0xffffu;
    if (u <= 0) Assert(0, "ffff <= 0");

    c = (signed char)-1;
    asm("scf");
    if (c >= -1) {} else Assert(0, "char -1 >= -1");
    if (c > -1) Assert(0, "char -1 > -1");
    if (c <= -1) {} else Assert(0, "char -1 <= -1");
    if (c < -1) Assert(0, "char -1 < -1");
    c = (signed char)-128;
    if (c > (signed char)0x80) Assert(0, "char min > min");
    if (c >= (signed char)0x80) {} else Assert(0, "char min >= min");
    if (c < -1) {} else Assert(0, "char min < -1");
    c = 127;
    if (c >= -1) {} else Assert(0, "char 127 >= -1");
    if (c >= 127) {} else Assert(0, "char 127 >= 127");
    if (c > 126) {} else Assert(0, "char 127 > 126");
}

int suite_signcmp(void)
{
    suite_setup("Signed constant compares");
    suite_add_test(test_signcmp);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    (void)argc;
    (void)argv;
    res += suite_signcmp();
    exit(res);
}
