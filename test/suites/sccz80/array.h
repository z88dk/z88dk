/** array test
    type: char, int
    storage: __xdata, __code,
*/

#define MKNAME(t,s) void t##s (void)
#define FUNCNAME(t,s) MKNAME(t,s)

#define TC(x) (0x10+(x))
#define TI(x) (0x1020+(x) + 0x100*(x))
#define TL(x) (0x10203040+(x))

FUNCNAME(testArrayAccess_, TYPE)
{
static const  unsigned char array_const_char[4] = {TC(0), TC(1), TC(2), TC(3)};
static const  unsigned int  array_const_int [4] = {TI(0), TI(1), TI(2), TI(3)};
static const  unsigned long array_const_long[4] = {TL(0), TL(1), TL(2), TL(3)};

static unsigned char array_char[4] = {TC(0), TC(1), TC(2), TC(3)};
static unsigned int  array_int [4] = {TI(0), TI(1), TI(2), TI(3)};
static unsigned long array_long[4] = {TL(0), TL(1), TL(2), TL(3)};

static volatile unsigned TYPE idx;
static volatile unsigned TYPE idx2;

  idx = 2;

  ASSERT(array_const_char[idx] == TC(2));
  ASSERT(array_const_int [idx] == TI(2));
  ASSERT(array_const_long[idx] == TL(2));

#ifndef SCCZ80
  ASSERT(idx[array_const_char] == TC(2));
  ASSERT(idx[array_const_int ] == TI(2));
  ASSERT(idx[array_const_long] == TL(2));
#endif

  ASSERT(array_const_char[2] == TC(2));
  ASSERT(array_const_int [2] == TI(2));
  ASSERT(array_const_long[2] == TL(2));

  ASSERT(array_char[idx] == TC(2));
  ASSERT(array_int [idx] == TI(2));
  ASSERT(array_long[idx] == TL(2));

  ASSERT(array_char[2] == TC(2));
  ASSERT(array_int [2] == TI(2));
  ASSERT(array_long[2] == TL(2));

  idx = 3;
  idx2 = 1;

  array_char[idx2] = array_const_char[idx] | 0x80;
  array_int [idx2] = array_const_int [idx] | 0x8080;
  array_long[idx2] = array_const_long[idx] | 0x80808080;

  ASSERT(array_char[idx2] == (TC(3) | 0x80));
  ASSERT(array_int [idx2] == (TI(3) | 0x8080));
  ASSERT(array_long[idx2] == (TL(3) | 0x80808080));
}

