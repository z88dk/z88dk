#include "test.h"
#include <stdio.h>
#include <stdlib.h>


struct {
  char c0_3 : 3;
  char c3_5 : 5;
} c_bf;

#ifndef __SDCC_pdk14 // Lack of memory
#if !defined(__SDCC_pic16)
struct {
  int i0_7 : 7;
  int i7_9 : 9;
} i_bf;

#if 0
struct {
  long l0_7 : 7;
  long l7_10 : 10;
  long l17_15 : 15;
} l_bf;
#endif

struct {
  unsigned int b0 : 1;
  unsigned int b1 : 1;
  unsigned int b2 : 1;
  unsigned int b3 : 1;
  unsigned int b4 : 1;
  unsigned int b5 : 1;
  unsigned int b6 : 1;
  unsigned int b7 : 1;
  unsigned int b8 : 1;
  unsigned int b9 : 1;
} sb_bf;
#endif  /* !__SDCC_pic16 */
#endif

struct {
  unsigned int b0 : 1;
  unsigned int b2 : 1;
} size1a_bf;

struct {
  unsigned int b0 : 1;
  unsigned int b1 : 1;
  unsigned int    : 0;
} size1b_bf;

struct {
  unsigned int b0 : 1;
  unsigned int b1 : 1;
  unsigned int b2 : 6;
} size1c_bf;

struct {
  unsigned int b0 : 1;
  unsigned int    : 0;
  unsigned int b1 : 1;
} size2a_bf;

#if !defined(__SDCC_pic16)
struct {
  unsigned int b0 : 1;
  unsigned int b1 : 1;
  unsigned int b2 : 1;
  unsigned int b3 : 1;
  unsigned int b4 : 1;
  unsigned int b5 : 1;
  unsigned int b6 : 1;
  unsigned int b7 : 1;
  unsigned int b8 : 1;
  unsigned int b9 : 1;
} size2b_bf;

struct {
  unsigned int b0 : 4;
  unsigned int b1 : 5;
} size2c_bf;

struct {
  unsigned int b0 : 12;
  unsigned int b1 : 3;
} size2d_bf;

struct { /* Bit-fields that end on byte boundary */
  unsigned int b0 : 3;
  unsigned int b1 : 5;
  unsigned int b2 : 5;
  unsigned int b3 : 3;
} size2e_bf;

struct {
  unsigned int b0 : 3;
  unsigned int b1 : 12;
} size3a_bf;

struct {
  signed int s0_7  : 7;
  signed int s7_1  : 1;
  signed int s8_9  : 9;
} s_bf;
#endif  /* !__SDCC_pic16 */

void
testBitfieldSizeof(void)
{
  /* Although bitfields are extremely implementation dependant, these
     assertions should hold for all implementations with storage units
     of 8 bits or larger (nearly universal).
  */
  ASSERT( sizeof(size1a_bf) >= 1);
  ASSERT( sizeof(size1b_bf) >= 1);
  ASSERT( sizeof(size1c_bf) >= 1);
#if !defined(__SDCC_pic16)
  ASSERT( sizeof(size2b_bf) >= 2);
  ASSERT( sizeof(size2c_bf) >= 2);
  ASSERT( sizeof(size2d_bf) >= 2);
  ASSERT( sizeof(size3a_bf) >= 2);
  ASSERT( sizeof(size1a_bf) <= sizeof(size1b_bf));
#endif  /* !__SDCC_pic16 */
  /* Some SDCC specific assertions. SDCC uses 8 bit storage units.
     Bitfields that are less than 8 bits, but would (due to earlier
     bitfield declarations) span a storage unit boundary are
     realigned to the next storage unit boundary. Bitfields of
     8 or greater bits are always aligned to start on a storage
     unit boundary.
  */
#ifdef __SDCC
  ASSERT( sizeof(size1a_bf) == 1);
  ASSERT( sizeof(size1b_bf) == 1);
  ASSERT( sizeof(size1c_bf) == 1);
  ASSERT( sizeof(size2a_bf) == 2);
#if !defined(__SDCC_pic16)
  ASSERT( sizeof(size2b_bf) == 2);
  ASSERT( sizeof(size2c_bf) == 2);
  ASSERT( sizeof(size2d_bf) == 2);
  ASSERT( sizeof(size3a_bf) == 3);
#endif  /* !__SDCC_pic16 */
#endif
}


void
testBitfieldsSingleBitLiteral(void)
{
#ifndef __SDCC_pdk14 // Lack of memory
#if !defined(__SDCC_pic16)
  size2b_bf.b0 = 0;
  size2b_bf.b1 = 0;
  size2b_bf.b2 = 0;
  size2b_bf.b3 = 0;
  size2b_bf.b4 = 0;
  size2b_bf.b5 = 0;
  size2b_bf.b6 = 0;
  size2b_bf.b7 = 0;
  size2b_bf.b8 = 0;
  size2b_bf.b9 = 0;

  /* make sure modulo 2 truncation works */
  size2b_bf.b0 = 0x3fe;
  ASSERT(size2b_bf.b0==0);
  ASSERT(size2b_bf.b1==0);
  ASSERT(size2b_bf.b2==0);
  ASSERT(size2b_bf.b3==0);
  ASSERT(size2b_bf.b4==0);
  ASSERT(size2b_bf.b5==0);
  ASSERT(size2b_bf.b6==0);
  ASSERT(size2b_bf.b7==0);
  ASSERT(size2b_bf.b8==0);
  ASSERT(size2b_bf.b9==0);
  size2b_bf.b0 = 0x3ff;
  ASSERT(size2b_bf.b0==1);
  ASSERT(size2b_bf.b1==0);
  ASSERT(size2b_bf.b2==0);
  ASSERT(size2b_bf.b3==0);
  ASSERT(size2b_bf.b4==0);
  ASSERT(size2b_bf.b5==0);
  ASSERT(size2b_bf.b6==0);
  ASSERT(size2b_bf.b7==0);
  ASSERT(size2b_bf.b8==0);
  ASSERT(size2b_bf.b9==0);

  /* make sure both bytes work */
  size2b_bf.b9 = 0x3ff;
  ASSERT(size2b_bf.b0==1);
  ASSERT(size2b_bf.b1==0);
  ASSERT(size2b_bf.b2==0);
  ASSERT(size2b_bf.b3==0);
  ASSERT(size2b_bf.b4==0);
  ASSERT(size2b_bf.b5==0);
  ASSERT(size2b_bf.b6==0);
  ASSERT(size2b_bf.b7==0);
  ASSERT(size2b_bf.b8==0);
  ASSERT(size2b_bf.b9==1);
#endif  /* !__SDCC_pic16 */
#endif
}

void
testBitfieldsSingleBit(void)
{
#ifndef __SDCC_pdk14 // Lack of memory
#if !defined(__SDCC_pic16)
  volatile unsigned char c;

  c = 0;
  size2b_bf.b0 = c;
  size2b_bf.b1 = c;
  size2b_bf.b2 = c;
  size2b_bf.b3 = c;
  size2b_bf.b4 = c;
  size2b_bf.b5 = c;
  size2b_bf.b6 = c;
  size2b_bf.b7 = c;
  size2b_bf.b8 = c;
  size2b_bf.b9 = c;

  /* make sure modulo 2 truncation works */
  c = 0xfe;
  size2b_bf.b0 = c;
  ASSERT(size2b_bf.b0==0);
  ASSERT(size2b_bf.b1==0);
  ASSERT(size2b_bf.b2==0);
  ASSERT(size2b_bf.b3==0);
  ASSERT(size2b_bf.b4==0);
  ASSERT(size2b_bf.b5==0);
  ASSERT(size2b_bf.b6==0);
  ASSERT(size2b_bf.b7==0);
  ASSERT(size2b_bf.b8==0);
  ASSERT(size2b_bf.b9==0);
  c++;
  size2b_bf.b0 = c;
  ASSERT(size2b_bf.b0==1);
  ASSERT(size2b_bf.b1==0);
  ASSERT(size2b_bf.b2==0);
  ASSERT(size2b_bf.b3==0);
  ASSERT(size2b_bf.b4==0);
  ASSERT(size2b_bf.b5==0);
  ASSERT(size2b_bf.b6==0);
  ASSERT(size2b_bf.b7==0);
  ASSERT(size2b_bf.b8==0);
  ASSERT(size2b_bf.b9==0);

  /* make sure both bytes work */
  size2b_bf.b9 = c;
  ASSERT(size2b_bf.b0==1);
  ASSERT(size2b_bf.b1==0);
  ASSERT(size2b_bf.b2==0);
  ASSERT(size2b_bf.b3==0);
  ASSERT(size2b_bf.b4==0);
  ASSERT(size2b_bf.b5==0);
  ASSERT(size2b_bf.b6==0);
  ASSERT(size2b_bf.b7==0);
  ASSERT(size2b_bf.b8==0);
  ASSERT(size2b_bf.b9==1);
#endif  /* !__SDCC_pic16 */
#endif
}

void
testBitfieldsMultibitLiteral(void)
{
#if !defined( __SDCC_pdk14) && !defined( __SDCC_pdk15) // Lack of memory
#if !defined(__SDCC_pic16)
  size2c_bf.b0 = 0xff;   /* should truncate to 0x0f */
  size2c_bf.b1 = 0;
  ASSERT(size2c_bf.b0==0x0f);
  ASSERT(size2c_bf.b1==0);

  size2c_bf.b1 = 0xff;   /* should truncate to 0x1f */
  size2c_bf.b0 = 0;
  ASSERT(size2c_bf.b0==0);
  ASSERT(size2c_bf.b1==0x1f);

  size2c_bf.b0 = 0xff;   /* should truncate to 0x0f */
  size2c_bf.b1 = 0xff;   /* should truncate to 0x1f */
  ASSERT(size2c_bf.b0==0x0f);
  ASSERT(size2c_bf.b1==0x1f);

  size2d_bf.b0 = 0xffff; /* should truncate to 0x0fff */
  size2d_bf.b1 = 0;
  ASSERT(size2d_bf.b0==0x0fff);
  ASSERT(size2d_bf.b1==0);

  size2d_bf.b1 = 0xffff; /* should truncate to 0x07 */
  size2d_bf.b0 = 0;
  ASSERT(size2d_bf.b0==0);
  ASSERT(size2d_bf.b1==0x07);

  size2d_bf.b0 = 0xffff; /* should truncate to 0x0fff */
  size2d_bf.b1 = 0xffff; /* should truncate to 0x07 */
  ASSERT(size2d_bf.b0==0x0fff);
  ASSERT(size2d_bf.b1==0x07);

  size2d_bf.b0 = 0x0321;
  size2d_bf.b1 = 1;
  ASSERT(size2d_bf.b0==0x0321);
  ASSERT(size2d_bf.b1==1);

  size2d_bf.b0 = 0x0a46;
  size2d_bf.b1 = 5;
  ASSERT(size2d_bf.b0==0x0a46);
  ASSERT(size2d_bf.b1==5);

  size2e_bf.b0 = 2;
  size2e_bf.b1 = 2;
  size2e_bf.b2 = 2;
  size2e_bf.b3 = 2;

  ASSERT(size2e_bf.b0==2);
  ASSERT(size2e_bf.b1==2);
  ASSERT(size2e_bf.b2==2);
  ASSERT(size2e_bf.b3==2);
#endif  /* !__SDCC_pic16 */
#endif
}

void
testBitfieldsMultibit(void)
{
#if !defined( __SDCC_pdk14) && !defined( __SDCC_pdk15) // Lack of memory
#if !defined(__SDCC_pic16)
  volatile int allones = 0xffff;
  volatile int zero = 0;
  volatile int x;

  size2c_bf.b0 = allones; /* should truncate to 0x0f */
  size2c_bf.b1 = zero;
  ASSERT(size2c_bf.b0==0x0f);
  ASSERT(size2c_bf.b1==0);

  size2c_bf.b1 = allones; /* should truncate to 0x1f */
  size2c_bf.b0 = zero;
  ASSERT(size2c_bf.b0==0);
  ASSERT(size2c_bf.b1==0x1f);

  size2d_bf.b0 = allones; /* should truncate to 0x0fff */
  size2d_bf.b1 = zero;
  ASSERT(size2d_bf.b0==0x0fff);
  ASSERT(size2d_bf.b1==0);

  size2d_bf.b1 = allones; /* should truncate to 0x07 */
  size2d_bf.b0 = zero;
  ASSERT(size2d_bf.b0==0);
  ASSERT(size2d_bf.b1==0x07);

  x = 0x0321;
  size2d_bf.b0 = x;
  x = 1;
  size2d_bf.b1 = x;
  ASSERT(size2d_bf.b0==0x0321);
  ASSERT(size2d_bf.b1==1);

  x = 0x0a46;
  size2d_bf.b0 = x;
  x = 5;
  size2d_bf.b1 = x;
  ASSERT(size2d_bf.b0==0x0a46);
  ASSERT(size2d_bf.b1==5);

  x = 2;
  size2e_bf.b0 = x;
  size2e_bf.b1 = x;
  size2e_bf.b2 = x;
  size2e_bf.b3 = x;

  ASSERT(size2e_bf.b0==2);
  ASSERT(size2e_bf.b1==2);
  ASSERT(size2e_bf.b2==2);
  ASSERT(size2e_bf.b3==2);
#endif  /* !__SDCC_pic16 */
#endif
}

void
testBitfields(void)
{
  c_bf.c0_3 = 2;
  c_bf.c3_5 = 3;
#if defined(PORT_HOST) && (defined(__ppc__) || defined(__PPC__) || defined(__sparc) || defined(__sparc64__))
  /* bitfields on powerpc and sparc architectures are allocated from left to right */
  ASSERT(*(char *)(&c_bf) == ((2<<(8-3)) + 3) );
#else
  ASSERT(*(char *)(&c_bf) == (2 + (3<<3)) );
#endif

#if 0 // not yet
  i_bf.i0_7 = 23;
  i_bf.i7_9 = 234;
  ASSERT(*(int *)(&i_bf) == (23 + (234<<7)) );

  l_bitfield.l0_7 = 23;
  l_bitfield.l7_10 = 234;
  l_bitfield.l17_15 = 2345;
  ASSERT(*(long *)(&l_bf) == (23 + (234<<7) + (2345<<17)) );
#endif
}

void
testSignedBitfields(void)
{
#if !defined( __SDCC_pdk14) && !defined( __SDCC_pdk15) // Lack of memory
#if !defined(__SDCC_pic16)
  s_bf.s0_7 =   0xf0;
  s_bf.s7_1 =      1;
  s_bf.s8_9 = 0xfff8;
  ASSERT(s_bf.s0_7 == -16);
  ASSERT(s_bf.s7_1 == - 1);
  ASSERT(s_bf.s8_9 == - 8);
  ASSERT(s_bf.s0_7 < 0);
  ASSERT(s_bf.s7_1 < 0);
  ASSERT(s_bf.s8_9 < 0);

  s_bf.s0_7 =   0x3f;
  s_bf.s7_1 =      2;
  s_bf.s8_9 = 0x00ff;
  ASSERT(s_bf.s0_7 == 0x3f);
  ASSERT(s_bf.s7_1 ==    0);
  ASSERT(s_bf.s8_9 == 0xff);
  ASSERT(s_bf.s0_7 > 0);
  ASSERT(s_bf.s8_9 > 0);
#endif  /* !__SDCC_pic16 */
#endif
}

/* test case for enhancement request #2291335 : Unnamed bit-field initialization */

struct s2291335_1 {
  int a : 2;
  char  : 2;
  int b : 2;
};

struct s2291335_2 {
  int a : 2;
  char  : 0;
  int b : 2;
};

struct s2291335_1 gs2291335_1 = {1, 2};
struct s2291335_2 gs2291335_2 = {1, 2};

void
__test2291335(void)
{
  struct s2291335_1 ls2291335_1 = {1, 2};
  struct s2291335_2 ls2291335_2 = {1, 2};

  ASSERT(gs2291335_1.a == 1);
  ASSERT(gs2291335_1.b == 2);
  ASSERT(gs2291335_2.a == 1);
  ASSERT(gs2291335_2.b == 2);

  ASSERT(ls2291335_1.a == 1);
  ASSERT(ls2291335_1.b == 2);
  ASSERT(ls2291335_2.a == 1);
  ASSERT(ls2291335_2.b == 2);
}

/* test case for bug #2366757: segfault when initializing structure with bitfield */

struct
{
  char a : 1;
  char b : 1;
} s2366757 = {0};

/* test case for const struct with bitfields */

#if !defined( __SDCC_pdk14) && !defined( __SDCC_pdk15) // Lack of memory
#ifndef __SDCC_pic16 // TODO: enable when the pic16 ports supports bitfields of size greater than 8 bits!
const struct
{
  unsigned int a : 4;
  unsigned int b : 3;
  unsigned int c : 12;
  unsigned int d : 3;
  unsigned int e : 2;
  unsigned int   : 4;
  unsigned int f : 2;
  unsigned int g;
} cs = { 1, 2, 345, 6, 2, 1, 54321};
#endif
#endif

#if defined(PORT_HOST) && (defined(__x86_64__) || defined(__i386__)) && defined(__GNUC__) && (__GNUC__ == 4 && __GNUC_MINOR__ == 6)
/* Workaround to fix the (cs.f == 1) test failure, which appeared in svn build 6665, when -O2 gcc option was included.
 * The failure only occurs on i386 and x86_64 host architectures with gcc 4.6 if -O2 is set. 
 * This seems like a gcc bug to me. (Borut)
 */
#pragma GCC push_options
#pragma GCC optimize ("O0")
#endif
void
testCS(void)
{
#if !defined( __SDCC_pdk14) && !defined( __SDCC_pdk15) // Lack of memory
#ifndef __SDCC_pic16 // TODO: enable when the pic16 ports supports bitfields of size greater than 8 bits!
  ASSERT(cs.a == 1);
  ASSERT(cs.b == 2);
  ASSERT(cs.c == 345);
  ASSERT(cs.d == 6);
  ASSERT(cs.e == 2);
  ASSERT(cs.f == 1);
  ASSERT(cs.g == 54321U);
#endif
#endif
}
#if defined(PORT_HOST) && defined(__sun) && defined(__i386__) && defined(__GNUC__) && (__GNUC__ == 4 && __GNUC_MINOR__ == 6)
#pragma GCC pop_options
#endif


int suite_bitfield()
{
    suite_setup("Bitfield Tests");

    suite_add_test(testBitfieldSizeof);
    suite_add_test(testBitfieldsSingleBitLiteral);
    suite_add_test(testBitfieldsSingleBit);
    suite_add_test(testBitfieldsMultibitLiteral);
    suite_add_test(testBitfieldsMultibit);
    suite_add_test(testBitfields);
    suite_add_test(testSignedBitfields);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_bitfield();

    exit(res);
}
