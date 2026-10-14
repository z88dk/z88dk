/* A byte read-modify-write of a global goes through one HL address: the load,
 * the ALU ops and the store back share it. Volatile globals, element offsets,
 * a different destination, and a store that is not the chain's result must not
 * be mixed up. */
#include "test.h"

static unsigned char g, h, flag, arr[4];
static volatile unsigned char vg;
static unsigned char sink;

static void togg(void)            { flag ^= 255; }
static void addi(void)            { g += 5; }
static void subi(void)            { g -= 3; }
static void inserti(unsigned char b) { g = (g & 0xf8) | (b & 7); }
static void andor(void)           { g = (g & 0x0f) | 0x40; }
static void elem(void)            { arr[2] ^= 0x81; }
static void elem2(void)           { arr[1] = (arr[1] + 7) & 0x3f; }
static void other(void)           { h = g ^ 0x55; }
static void both(void)            { g ^= 0xff; h ^= 0xff; }
static void vol(void)             { vg ^= 255; vg += 1; }
static void useboth(void)         { sink = g; g = g + 1; sink += g; }

void test_rmwglobal(void)
{
    flag = 0x0f; togg(); assertEqual(flag, 0xf0);
    togg(); assertEqual(flag, 0x0f);
    g = 250; addi(); assertEqual(g, 255);
    addi(); assertEqual(g, 4);
    subi(); assertEqual(g, 1);
    g = 0xff; inserti(0x13); assertEqual(g, 0xfb);
    g = 0xaa; andor(); assertEqual(g, 0x4a);
    arr[0] = 1; arr[1] = 0x3e; arr[2] = 0x0f; arr[3] = 9;
    elem(); assertEqual(arr[2], 0x8e);
    assertEqual(arr[0], 1); assertEqual(arr[3], 9);
    elem2(); assertEqual(arr[1], 0x05);
    g = 0x0f; h = 0; other(); assertEqual(h, 0x5a); assertEqual(g, 0x0f);
    g = 0x12; h = 0x34; both(); assertEqual(g, 0xed); assertEqual(h, 0xcb);
    vg = 0x10; vol(); assertEqual(vg, 0xf0);
    g = 7; sink = 0; useboth(); assertEqual(g, 8); assertEqual(sink, 15);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte read-modify-write of a global");
    suite_add_test(test_rmwglobal);
    return suite_run();
}
