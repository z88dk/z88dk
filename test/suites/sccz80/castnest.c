/* A cast around a cast. The inner cast truncates or sign-extends.
   The outer cast widens that result. */
#include "test.h"
#include <stdint.h>
#include <stdlib.h>

static uint64_t low(uint64_t a)
{
    return (uint64_t)(uint32_t)a;
}

static uint64_t mul32(uint64_t a, uint64_t b)
{
    return (uint64_t)(uint32_t)a * (uint32_t)b;
}

static int64_t sext(uint64_t x)
{
    return (int64_t)(int32_t)x;
}

static int64_t sext_s(int64_t x)
{
    return (int64_t)(int32_t)x;
}

static int from_uchar(int v)
{
    return (int)(unsigned char)v;
}

static uint64_t nest_u8(uint64_t a)
{
    return (uint64_t)(uint8_t)a;
}

static uint64_t single_u8(uint64_t a)
{
    return (uint8_t)a;
}

static int64_t nest_s8(uint64_t a)
{
    return (int64_t)(int8_t)a;
}

static int64_t single_s8(uint64_t a)
{
    return (int8_t)a;
}

static uint64_t nest_u16(uint64_t a)
{
    return (uint64_t)(uint16_t)a;
}

struct S {
    int field;
};

static int member(void *p)
{
    return ((struct S *)(void *)p)->field;
}

static int via_charptr(void *p)
{
    return ((int *)(char *)p)[1];
}

static uint64_t id(uint64_t v)
{
    return v;
}

void test_castnest(void)
{
    struct S s;
    int buf[2];
    uint64_t wide;

    Assert(low(0x1ffffffffULL) == 0xffffffffULL, "(uint64_t)(uint32_t) keeps the low half");
    Assert(low(0x100000000ULL) == 0, "(uint64_t)(uint32_t) clears a high bit");
    Assert(mul32(0x100000003ULL, 2) == 6, "32x32 product truncates the left factor");
    Assert(mul32(0x100000001ULL, 0x100000001ULL) == 1, "32x32 product truncates both factors");
    Assert(sext(0x80000000ULL) == -2147483648LL, "(int64_t)(int32_t) sign-extends");
    Assert(sext(0xffffffffULL) == -1LL, "(int64_t)(int32_t) of a low half of all ones");
    Assert(sext_s(0x80000000LL) == -2147483648LL, "(int64_t)(int32_t) of a signed value");
    Assert(from_uchar(-1) == 255, "(int)(unsigned char) truncates");
    Assert(nest_u8(0x1ffULL) == 0xffULL, "(uint64_t)(uint8_t) masks the low byte");
    Assert(single_u8(0x1ffULL) == 0xffULL, "(uint8_t) of a long long masks the low byte");
    Assert(nest_s8(0x180ULL) == (int64_t)-128, "(int64_t)(int8_t) sign-extends the low byte");
    Assert(single_s8(0x180ULL) == (int64_t)-128, "(int8_t) of a long long sign-extends the low byte");
    Assert(nest_u16(0x1ffffULL) == 0xffffULL, "(uint64_t)(uint16_t) keeps the low half");

    wide = 0x1ffffffffULL;
    Assert(id((uint64_t)(uint32_t)wide) == 0xffffffffULL, "nested cast as a call argument");

    s.field = 42;
    Assert(member(&s) == 42, "member after two pointer casts");
    buf[0] = 1;
    buf[1] = 7;
    Assert(via_charptr(buf) == 7, "subscript after two pointer casts");
}

int suite_castnest(void)
{
    suite_setup("Nested cast Tests");
    suite_add_test(test_castnest);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_castnest();
    exit(res);
}
