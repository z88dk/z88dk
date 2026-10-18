/* A byte complement stored in a one-byte slot: the word form wrote two
 * bytes and clobbered the saved IX or the return address.
 */
#include <stdint.h>
#include <string.h>
#include "test.h"

static void invert8(uint8_t *dst, const uint8_t *src)
{
    uint8_t i;

    for (i = 0; i < 8; ++i)
        dst[i] = (uint8_t)~src[i];
}

static void check(void)
{
    static const uint8_t in[8] = { 0, 1, 2, 0x55, 0xaa, 0x7f, 0x80, 0xff };
    static const uint8_t want[8] = { 0xff, 0xfe, 0xfd, 0xaa, 0x55, 0x80, 0x7f, 0 };
    uint8_t out[8];

    memset(out, 0, sizeof out);
    invert8(out, in);
    assertEqual(memcmp(out, want, 8), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte complement");
    suite_add_test(check);
    return suite_run();
}
