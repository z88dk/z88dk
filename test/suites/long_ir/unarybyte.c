/* Byte results of promoted unary operations may narrow. Wide consumers keep
 * the full promoted int result, so -(unsigned char)200 remains -200 and
 * ~(unsigned char)200 remains -201 when converted to long.
 */
#include <stdint.h>
#include "test.h"

static uint8_t ret_not(uint8_t x) { return (uint8_t)~x; }
static uint8_t ret_neg(uint8_t x) { return (uint8_t)-x; }
static uint8_t ret_signed_neg(int8_t x) { return (uint8_t)-x; }
static uint8_t ret_not_implicit(uint8_t x) { return ~x; }
static uint8_t ret_neg_implicit(uint8_t x) { return -x; }

static uint8_t call_result;
static uint8_t func(void) { return call_result; }
static uint8_t call_not(void) { return ~func(); }

static uint8_t scroll_dy;
static uint8_t scroll_neg(void) { return (uint8_t)-scroll_dy; }

static long wide_not(uint8_t x) { return ~(unsigned char)x; }
static long wide_neg(uint8_t x) { return -(unsigned char)x; }

void test_unarybyte(void)
{
    assertEqual(ret_not(0), 255);
    assertEqual(ret_not(0x80), 127);
    assertEqual(ret_not(0xff), 0);
    assertEqual(ret_neg(0), 0);
    assertEqual(ret_neg(1), 255);
    assertEqual(ret_neg(0x80), 128);
    assertEqual(ret_signed_neg(-128), 128);
    assertEqual(ret_not_implicit(0x80), 127);
    assertEqual(ret_neg_implicit(1), 255);
    call_result = 0x80;
    assertEqual(call_not(), 127);
    call_result = 0xff;
    assertEqual(call_not(), 0);
    scroll_dy = 1;
    assertEqual(scroll_neg(), 255);
    assertEqual(wide_not(200), -201);
    assertEqual(wide_neg(200), -200);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte narrowing of promoted unary operations");
    suite_add_test(test_unarybyte);
    return suite_run();
}
