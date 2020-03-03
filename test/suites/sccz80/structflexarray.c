#include "test.h"
#include <stdio.h>
#include <stdlib.h>


#if defined(__SUNPRO_C) || defined(__GNUC__)
#pragma pack(1)
#endif

#if !defined(__SUNPRO_C) && (!defined(__GNUC__) || (defined(__GNUC__) && __GNUC__ >= 3))
/* flexible array members not supported by gcc < 3 compiler
   and seems not to be supported on SunPro C compiler */
struct str1
{
  char c;
  short i[];
};

struct str1 s11 = { 1, {2, 3} };
struct str1 s12 = { 4, {5, 6, 7} }; /* different size */
#endif

static void
testFlexibleArray1(void)
{
#if !defined(__SUNPRO_C) && (!defined(__GNUC__) || (defined(__GNUC__) && __GNUC__ >= 3))
  /* flexible array members not supported by gcc < 3 compiler
     and seems not to be supported on SunPro C compiler */
  /* test sizeof */
  ASSERT(sizeof(s11) == 1);
  /* test allocation size */
#if !defined(PORT_HOST)
   ASSERT((char *) &s12 - (char *) &s11 == 1 + 4);
#endif
#endif
}


/* test initialisation with string */

#if !defined(__SUNPRO_C) && (!defined(__GNUC__) || (defined(__GNUC__) && __GNUC__ >= 3))
/* flexible array members not supported by gcc < 3 compiler
   and seems not to be supported on SunPro C compiler */
struct str2
{
  short s;
  char str2[];
};

struct str2 s21 = { 1, "sdcc" };
struct str2 s22 = { 2, "sdcc is great" }; /* different size */
#endif

static void
testFlexibleArray2(void)
{
#if !defined(__SUNPRO_C) && (!defined(__GNUC__) || (defined(__GNUC__) && __GNUC__ >= 3))
  /* flexible array members not supported by gcc < 3 compiler
     and seems not to be supported on SunPro C compiler */
  /* test sizeof */
  ASSERT(sizeof(s21) == 2);
  /* test allocation size */
#if !defined(PORT_HOST)
   ASSERT((char *) &s22 - (char *) &s21 == 2 + 5);
#endif
#endif
}

int suite_structflexarray()
{
    suite_setup("Flexible Array Tests");

    suite_add_test(testFlexibleArray1);
    suite_add_test(testFlexibleArray2);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_structflexarray();

    exit(res);
}
