/* __sdcccall(1) calling convention — self-consistency (80cc caller calling
 * 80cc-defined __sdcccall(1) functions). Subset: z80/z180/z80n, <=2 args
 * (1st char/int, 2nd int), 1-2 byte returns. Args: 1st A/HL, 2nd DE;
 * return: char->A, int->DE. */

#include "test.h"

int  sc_inc (int a)          __sdcccall(1);
int  sc_inc (int a)          __sdcccall(1) { return a + 1; }
char sc_cinc(char c)         __sdcccall(1);
char sc_cinc(char c)         __sdcccall(1) { return c + 1; }
int  sc_add (int a, int b)   __sdcccall(1);
int  sc_add (int a, int b)   __sdcccall(1) { return a + b; }
int  sc_sub (int a, int b)   __sdcccall(1);
int  sc_sub (int a, int b)   __sdcccall(1) { return a - b; }   /* order matters */
int  sc_ci  (char a, int b)  __sdcccall(1);
int  sc_ci  (char a, int b)  __sdcccall(1) { return a + b; }
char sc_cc  (char a, char b) __sdcccall(1);   /* A,L two-char combo */
char sc_cc  (char a, char b) __sdcccall(1) { return a - b; }   /* order-sensitive */
/* 4-byte longs: HLDE (DE=low, HL=high), sole register arg / return. */
long sc_lid (long a)         __sdcccall(1);
long sc_lid (long a)         __sdcccall(1) { return a; }          /* round-trip */
long sc_linc(long a)         __sdcccall(1);
long sc_linc(long a)         __sdcccall(1) { return a + 1; }      /* carry across words */
int  sc_llo (long a)         __sdcccall(1);
int  sc_llo (long a)         __sdcccall(1) { return (int)a; }     /* long arg -> int ret */
long sc_iext(int a)          __sdcccall(1);
long sc_iext(int a)          __sdcccall(1) { return a; }          /* int arg -> long ret */
/* stacked remainder: 3rd+ args on the stack (STDC R->L). int return =>
   callee cleans; long return => caller cleans. */
int  sc_3 (int a, int b, int c)          __sdcccall(1);
int  sc_3 (int a, int b, int c)          __sdcccall(1) { return a + b - c; }
int  sc_4 (int a, int b, int c, int d)   __sdcccall(1);
int  sc_4 (int a, int b, int c, int d)   __sdcccall(1)
    { return a*8 + b*4 + c*2 + d; }   /* order-sensitive, pow2 (no l_mult) */
long sc_l3(int a, int b, int c)          __sdcccall(1);
long sc_l3(int a, int b, int c)          __sdcccall(1) { return (long)a + b + c; }
/* stacked CHAR args: pushed 1 byte each (SDCC `push af;inc sp`). */
int  sc_iic(int a, int b, char c)              __sdcccall(1);
int  sc_iic(int a, int b, char c)              __sdcccall(1) { return a + b + c; }
int  sc_ccc(char a, char b, char c)            __sdcccall(1);   /* A,L + stacked char */
int  sc_ccc(char a, char b, char c)            __sdcccall(1) { return a*4 + b*2 + c; }
int  sc_iicc(int a, int b, char c, char d)     __sdcccall(1);   /* two stacked chars */
int  sc_iicc(int a, int b, char c, char d)     __sdcccall(1) { return a + b + c*2 + d; }
int  sc_iccc(int a, int b, char c, char d, char e) __sdcccall(1);  /* odd: pair + 1 */
int  sc_iccc(int a, int b, char c, char d, char e) __sdcccall(1)
    { return a + b + c*4 + d*2 + e; }
/* __z88dk_sdccdecl (== __sdcccall(0)): all-stack, but adjacent stacked chars
   pack the same way. */
int  sd_iicc(int a, int b, char c, char d)         __z88dk_sdccdecl;
int  sd_iicc(int a, int b, char c, char d)         __z88dk_sdccdecl { return a + b + c*2 + d; }
int  sd_ccc (char a, char b, char c)               __z88dk_sdccdecl;
int  sd_ccc (char a, char b, char c)               __z88dk_sdccdecl { return a*4 + b*2 + c; }

static void test_sdcccall1(void)
{
    Assert(sc_inc(41)      == 42,  "sc1 int arg -> HL, int return -> DE");
    Assert(sc_cinc(65)     == 66,  "sc1 char arg -> A, char return -> A");
    Assert(sc_add(40, 2)   == 42,  "sc1 two int args (HL,DE)");
    Assert(sc_sub(50, 8)   == 42,  "sc1 arg order (a-b, not b-a)");
    Assert(sc_ci(10, 32)   == 42,  "sc1 char+int args (A,DE)");
    Assert(sc_cc(70, 5)    == 65,  "sc1 two char args (A,L), a-b order");
    /* a result kept live across another sc1 call */
    Assert(sc_add(1, 2) + sc_add(3, 4) == 10, "sc1 result live across call");
    /* 4-byte longs in HLDE */
    Assert(sc_lid(0x12345678L)  == 0x12345678L, "sc1 long arg+return round-trip (HLDE)");
    Assert(sc_linc(0x0000FFFFL) == 0x00010000L, "sc1 long +1 carry across word boundary");
    Assert(sc_llo(0x00BB1234L)  == 0x1234,      "sc1 long arg -> int return (low word)");
    Assert(sc_iext(-1)          == -1L,         "sc1 int arg -> long return (sign-extend)");
    Assert(sc_iext(1000)        == 1000L,       "sc1 int arg -> long return (positive)");
    /* stacked remainder */
    Assert(sc_3(1000, 200, 30)  == 1170,        "sc1 3rd arg stacked (a+b-c), callee cleans");
    Assert(sc_4(1, 2, 3, 4)     == 26,          "sc1 3rd+4th stacked, R->L order (8+8+6+4)");
    Assert(sc_l3(1, 2, 3)       == 6L,          "sc1 stacked + long return (caller cleans)");
    /* a stacked-arg call's result kept live across another such call */
    Assert(sc_3(10,20,5) + sc_4(0,0,0,7) == 32, "sc1 stacked result live across call");
    /* stacked char args (1-byte pushes) */
    Assert(sc_iic(1000, 200, 30) == 1230,  "sc1 stacked char arg (1-byte push)");
    Assert(sc_ccc(1, 2, 3)       == 11,    "sc1 A,L regs + 3rd stacked char (4+4+3)");
    Assert(sc_iicc(0, 0, 5, 3)   == 13,    "sc1 two stacked char args (odd bytes, 10+3)");
    Assert(sc_iccc(0, 0, 1, 2, 3) == 11,   "sc1 three stacked chars (packed pair + 1)");
    Assert(sd_iicc(0, 0, 5, 3)   == 13,    "sdccdecl two stacked chars (packed)");
    Assert(sd_ccc(1, 2, 3)       == 11,    "sdccdecl three stacked chars (pair + 1)");
}

/* __sdcccall(1) through a function pointer: dispatched via the fastcall
   fc_idx (fnptr in ix/iy, args in A/HL/DE, `call l_jpix`) or fc_ret (push
   [retlabel][fnptr] then `ret`) machinery. Reuses the direct-call functions
   above through pointers carrying the convention. */
static void test_sdcccall1_fnptr(void)
{
    int  (*pi )(int)         __sdcccall(1) = sc_inc;
    char (*pc )(char)        __sdcccall(1) = sc_cinc;
    int  (*ps )(int,int)     __sdcccall(1) = sc_sub;
    char (*pcc)(char,char)   __sdcccall(1) = sc_cc;
    int  (*p3 )(int,int,int) __sdcccall(1) = sc_3;
    long (*pl )(long)        __sdcccall(1) = sc_lid;
    long (*pie)(int)         __sdcccall(1) = sc_iext;
    Assert(pi(41)          == 42,         "sc1 fnptr: int arg HL, int ret DE");
    Assert(pc(65)          == 66,         "sc1 fnptr: char arg/ret A");
    Assert(ps(50, 8)       == 42,         "sc1 fnptr: two int args, a-b order");
    Assert(pcc(70, 5)      == 65,         "sc1 fnptr: A,L two-char combo");
    Assert(p3(1000,200,30) == 1170,       "sc1 fnptr: stacked 3rd arg, callee clean");
    Assert(pl(0x12345678L) == 0x12345678L,"sc1 fnptr: long arg+ret (HLDE)");
    Assert(pie(-1)         == -1L,        "sc1 fnptr: int arg -> long ret");
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("sdcccall1");
    suite_add_test(test_sdcccall1);
    suite_add_test(test_sdcccall1_fnptr);
    return suite_run();
}
