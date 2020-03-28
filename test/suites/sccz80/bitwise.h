

/** Test the bitwise operators.

    type: char, short, long
    attr: volatile,
    storage: static,
 */

#define MKNAME(t,s) void t##s (void)
#define FUNCNAME(t,s) MKNAME(t,s)

FUNCNAME(testTwoOpBitwise_,TYPE)
{
  TYPE  left, right;

  left = (TYPE)0x3df7;
  right = (TYPE)0xc1ec;

  assertEqual((TYPE)(left & right), (TYPE)0x1E4);
  assertEqual((TYPE)(right & left), (TYPE)0x1E4);
  assertEqual((TYPE)(left & 0xc1ec), (TYPE)0x1E4);
  assertEqual((TYPE)(0x3df7 & right), (TYPE)0x1E4);

  assertEqual((TYPE)(left | right), (TYPE)0xFDFF);
  assertEqual((TYPE)(right | left), (TYPE)0xFDFF);
  assertEqual((TYPE)(left | 0xc1ec), (TYPE)0xFDFF);
  assertEqual((TYPE)(0x3df7 | right), (TYPE)0xFDFF);

  assertEqual((TYPE)(left ^ right),  (TYPE)0xFC1B);
  assertEqual((TYPE)(right ^ left),  (TYPE)0xFC1B);
  assertEqual((TYPE)(left ^ 0xc1ec), (TYPE)0xFC1B);
  assertEqual((TYPE)(0x3df7 ^ right),(TYPE)0xFC1B);

  assertEqual((TYPE)(~left), (TYPE)0xFFFFC208);
}

FUNCNAME(testAnd_,TYPE)
{
  char res;
  volatile int a;

  /* always false if right literal == 0 */
#if 0
  // fails on pic16
  if (a & 0)
    res = 1;
  else
    res = 0;
  assertEqual(res = 0);

  a = 0x1234;

  if (a & 0)
    res = 1;
  else
    res = 0;
  assertEqual(res = 0);
#endif

  /*
   * result: if, left: var, right: literal
   */
  a = 0x1234;

  if (a & 0x4321)
    res = 1;
  else
    res = 0;
  assertEqual(res, 1);

  if (a & 0x4321)
    /* nothing for true */
    ;
  else
    res = 0;
  assertEqual(res, 1);

  if (!(a & 0x4321))
    res = 1;
  else
    res = 0;
  assertEqual(res, 0);

  if (!(a & 0x4321))
    /* nothing for true */
    ;
  else
    res = 0;
  assertEqual(res, 0);

  /* bitmask literal */
  a = 0xffff;

  if (a & 0x1004)
    res = 1;
  else
    res = 0;
  assertEqual(res, 1);

  if (!(a & 0x1004))
    res = 1;
  else
    res = 0;
  assertEqual(res, 0);

  a = 0x0000;

  if (a & 0x1004)
    res = 1;
  else
    res = 0;
  assertEqual(res, 0);

  if (!(a & 0x1004))
    res = 1;
  else
    res = 0;
  assertEqual(res, 1);

  a = 0x00ff;

  if (a & 0x1004)
    res = 1;
  else
    res = 0;
  assertEqual(res, 1);

  if (!(a & 0x1004))
    res = 1;
  else
    res = 0;
  assertEqual(res, 0);

  a = 0xff00;

  if (a & 0x1004)
    res = 1;
  else
    res = 0;
  assertEqual(res, 1);

  if (!(a & 0x1004))
    res = 1;
  else
    res = 0;
  assertEqual(res, 0);

  /* literal with zero bytes */
  a = 0x1234;

  if (a & 0x4300)
    res = 1;
  else
    res = 0;
  assertEqual(res, 1);
  if (a & 0x0012)
    res = 1;
  else
    res = 0;
  assertEqual(res, 1);

  if (!(a & 0x4300))
    res = 1;
  else
    res = 0;
  assertEqual(res, 0);

  if (!(a & 0x0012))
    res = 1;
  else
    res = 0;
  assertEqual(res, 0);

  /*
   * result: bit, left: var, right: literal
   */
}

FUNCNAME(testOr_,TYPE)
{
  char res;
  volatile int a = 0x1234;

  /*
   * result: if, left: var, right: literal
   */
  res = 1;
  if (a | 0x4321)
    /* nothing for true */
    ;
  else
    res = 0;
  assertEqual(res, 1);

  if (!(a | 0x4321))
    /* nothing for true */
    ;
  else
    res = 0;
  assertEqual(res, 0);
  if (a | 0x4321)
    res = 1;
  else
    res = 0;
  assertEqual(res, 1);

  if (!(a | 0x4321))
    res = 1;
  else
    res = 0;
  assertEqual(res, 0);

  /* or with zero: result is left */
  res = 1;

  if (a | 0)
    /* nothing for true */
    ;
  else
    res = 0;
  assertEqual(res, 1);

  res = 1;

  if (!(a | 0))
    /* nothing for true */
    ;
  else
    res = 0;
  assertEqual(res, 0);

  if (a | 0)
    res = 1;
  else
    res = 0;
  assertEqual(res, 1);

  if (!(a | 0))
    res = 1;
  else
    res = 0;
  assertEqual(res, 0);
}

FUNCNAME(testXor_,TYPE)
{
  char res;
  volatile int a = 0x1234;

  /*
   * result: if, left: var, right: literal
   */
  if (a ^ 0x4321)
    res = 1;
  else
    res = 0;
  assertEqual(res, 1);

  if (a ^ 0x4321)
    /* nothing for true */
    ;
  else
    res = 0;
  assertEqual(res, 1);
  if (!(a ^ 0x4321))
    res = 1;
  else
    res = 0;
  assertEqual(res, 0);

  if (!(a ^ 0x4321))
    /* nothing for true */
    ;
  else
    res = 0;
  assertEqual(res, 0);

  /* literal with 0xff bytes */
  if (a ^ 0xff04)
    res = 1;
  else
    res = 0;
  assertEqual(res, 1);

  if (!(a ^ 0xff04))
    res = 1;
  else
    res = 0;
  assertEqual(res, 0);

  /* literal with zero bytes */
  if (a ^ 0x0004)
    res = 1;
  else
    res = 0;
  assertEqual(res, 1);

  if (!(a ^ 0x0004))
    res = 1;
  else
    res = 0;
  assertEqual(res, 0);
}

