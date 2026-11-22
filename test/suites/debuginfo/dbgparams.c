/* Debug-info regression for #3233 (80cc, -debug): parameters. A parameter the
 * function reassigns must show its current value, not the incoming one, at a
 * later breakpoint (ADR 0030). check_params.sh breaks at each marked line and
 * asserts what `info locals` shows. Every marked line is straight-line code: a
 * line that starts a basic block is a label ticks cannot resolve locals after.
 */
#include <stdio.h>
#include <stdint.h>

uint8_t g8;
uint16_t gw;
uint32_t gl;

uint8_t addp(uint8_t a)             /* a byte parameter, reassigned */
{
    a = a + 1;
    g8 = a;                         /* BREAK addp: a = 3 */
    return g8;
}

uint8_t fcp(uint8_t x) __z88dk_fastcall   /* a fastcall parameter, reassigned and read back */
{
    x = x + 3;
    g8 = x + g8;                    /* BREAK fcp: x = 7 */
    return x;
}

uint8_t cal(uint8_t a, uint8_t b) __z88dk_callee   /* a callee-cleanup parameter */
{
    a = a + b;
    g8 = a;                         /* BREAK cal: a = 15 */
    return g8;
}

uint32_t lp(uint32_t x, uint8_t k)  /* a long parameter, reassigned */
{
    x = x + k;
    x = x << 1;                     /* BREAK lp: x = 74568 */
    return x;
}

int main(void)
{
    g8 = addp(2);
    g8 = 0;
    g8 = fcp(4);
    g8 = cal(10, 5);
    gl = lp(74565, 3);
    printf("%u %lu\n", g8, gl);
    return 0;
}
