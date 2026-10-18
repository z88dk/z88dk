/* A short-lived address (the buffer's frame address) packed into IY while a
 * nested conditional of string literals follows. The address was read from IY
 * but never written there, so the number after "JAN " was lost.
 */
#include <stdint.h>
#include <string.h>
#include "test.h"

static uint8_t put_number(char *buf, uint32_t v)
{
    char tmp[11];
    uint8_t n = 0, i;
    if (v == 0) {
        buf[0] = '0';
        return 1;
    }
    while (v) {
        tmp[n++] = (char)('0' + (uint8_t)(v % 10));
        v /= 10;
    }
    for (i = 0; i < n; ++i)
        buf[i] = tmp[n - 1 - i];
    return n;
}

static uint8_t append(char *buf, uint8_t n, const char *s)
{
    while (*s)
        buf[n++] = *s++;
    return n;
}

static void keep(const char *s, char *dst)
{
    while ((*dst++ = *s++) != 0)
        ;
}

volatile uint16_t year = 1902;
volatile uint8_t speed = 1;
char out1[40], out2[40];

static void f(void)
{
    char buf[40];
    uint8_t n;

    n = append(buf, 0, "JAN");
    buf[n++] = ' ';
    n += put_number(buf + n, year);
    buf[n] = 0;
    keep(buf, out1);

    n = append(buf, 0, speed == 3 ? "PAUSED" : speed == 0 ? "FAST" : speed == 1 ? "NORMAL" : "SLOW");
    buf[n] = 0;
    keep(buf, out2);
}


static void check(void)
{
    f();
    assertEqual(strcmp(out1, "JAN 1902"), 0);
    assertEqual(strcmp(out2, "NORMAL"), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("iy temp pack of an address");
    suite_add_test(check);
    return suite_run();
}
