/* A compare against a cast constant expression. The constant folds in the
 * type of its first operand, so (unsigned char)(0xFF + 1) held 256 and the
 * compare against a byte was dropped as always true.
 */
#include "test.h"
#include <stdio.h>
#include <stdlib.h>

static int ne_uchar(unsigned char v)  { return v != (unsigned char)(0xFF + 1); }
static int eq_uchar(unsigned char v)  { return v == (unsigned char)(0xFF + 1); }
static int lt_uchar(unsigned char v)  { return v < (unsigned char)(0x100 + 3); }
static int eq_schar(signed char v)    { return v == (signed char)(0xFF + 1); }
static int eq_wrap(unsigned char v)   { return v == (unsigned char)(0x7F + 0x81); }
static int eq_plain(unsigned char v)  { return v == (unsigned char)256; }
static int eq_mask(unsigned char v)   { return v == (unsigned char)0x1FF; }
static int eq_uint(unsigned int v)    { return v == (unsigned int)(0x7FFF + 0x8001u); }
static int lt_schar(signed char v)    { return v < (signed char)(0x7F + 2); }

void test_castconst(void)
{
    Assert(ne_uchar(0) == 0, "0 != (unsigned char)(0xFF + 1)");
    Assert(ne_uchar(1) == 1, "1 != (unsigned char)(0xFF + 1)");
    Assert(eq_uchar(0) == 1, "0 == (unsigned char)(0xFF + 1)");
    Assert(eq_uchar(255) == 0, "255 == (unsigned char)(0xFF + 1)");
    Assert(lt_uchar(2) == 1, "2 < (unsigned char)(0x100 + 3)");
    Assert(lt_uchar(3) == 0, "3 < (unsigned char)(0x100 + 3)");
    Assert(eq_schar(0) == 1, "0 == (signed char)(0xFF + 1)");
    Assert(eq_schar(-1) == 0, "-1 == (signed char)(0xFF + 1)");
    Assert(eq_wrap(0) == 1, "0 == (unsigned char)(0x7F + 0x81)");
    Assert(eq_wrap(1) == 0, "1 == (unsigned char)(0x7F + 0x81)");
    Assert(eq_plain(0) == 1, "0 == (unsigned char)256");
    Assert(eq_mask(255) == 1, "255 == (unsigned char)0x1FF");
    Assert(eq_mask(0) == 0, "0 == (unsigned char)0x1FF");
    Assert(eq_uint(0) == 1, "0 == (unsigned int)(0x7FFF + 0x8001u)");
    Assert(eq_uint(1) == 0, "1 == (unsigned int)(0x7FFF + 0x8001u)");
    Assert(lt_schar(-128) == 1, "-128 < (signed char)(0x7F + 2)");
    Assert(lt_schar(-127) == 0, "-127 < (signed char)(0x7F + 2)");
}

int suite_castconst()
{
    suite_setup("Compare cast constant Tests");
    suite_add_test(test_castconst);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_castconst();
    exit(res);
}
