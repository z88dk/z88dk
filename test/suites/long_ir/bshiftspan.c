/* A variable byte shift in a conditional block after large loop nests, under
 * --opt-code-size. The shift loop is entered by a jump over its own body;
 * the layout passes move the block, so the jump must be relaxed from its
 * final distance, not assumed short. Checked against a reference that
 * shifts one bit at a time.
 */
#include "test.h"

typedef unsigned char u8;

static u8 tab[32] = { 3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5, 8, 9, 7, 9, 3,
                      2, 3, 8, 4, 6, 2, 6, 4, 3, 3, 8, 3, 2, 7, 9, 5 };
static u8 art[8], ref[8];

static u8 lev(u8 x, u8 y) { return (u8)((x * 5 + y * 3) & 7); }
static u8 (*levp)(u8, u8) = lev;

static u8 shr_ref(u8 x, u8 c) { while (c--) x = (u8)(x / 2); return x; }

#define BODY(OUT, SHR)                                                  \
    u8 r, i, j, y, bits, m, tx, l[4];                                   \
    const u8 *b;                                                        \
    for (j = 0; j < 4; ++j) {                                           \
        for (i = 0; i < 4; ++i) l[i] = levp((u8)(cx * 4 + i), (u8)(ty + j)); \
        for (r = 0; r < 2; ++r) {                                       \
            y = (u8)(ty * 2 + r); bits = 0; m = 0x80;                   \
            for (i = 0; i < 4; ++i) {                                   \
                tx = (u8)(cx * 4 + i);                                  \
                if (kind == 1) b = tab + ((y & 1) << 1);                \
                else if (kind == 2) b = tab + ((y & 3) << 2) + ((tx & 1) << 1); \
                else b = tab + ((ty & 3) << 2) + (tx & 3);             \
                if (l[i] > b[0]) bits |= m;                             \
                m >>= 1;                                                \
                if (l[i] > b[kind == 3 ? 0 : 1]) bits |= m;             \
                m >>= 1;                                                \
            }                                                           \
            OUT[j * 2 + r] = bits;                                      \
        }                                                               \
    }                                                                   \
    if (mark && (cur_x >> 2) == cx && py < 64) {                        \
        r = (u8)(py & 7);                                               \
        OUT[r] ^= (u8)SHR(0xC0, (cur_x & 3) * 2);                       \
        OUT[r + 1] ^= (u8)SHR(0xC0, (cur_x & 3) * 2);                   \
    }

#define SHR_V(x, c) ((x) >> (c))
#define SHR_R(x, c) shr_ref((x), (u8)(c))

static void cell(u8 kind, u8 cx, u8 ty, u8 mark, u8 cur_x, u8 py) { BODY(art, SHR_V) }
static void refcell(u8 kind, u8 cx, u8 ty, u8 mark, u8 cur_x, u8 py) { BODY(ref, SHR_R) }

static void check(void)
{
    u8 kind, cx, ty, cur_x, k;
    int bad = 0;

    for (kind = 1; kind <= 3; ++kind)
        for (cx = 0; cx < 3; ++cx)
            for (ty = 0; ty < 3; ++ty)
                for (cur_x = 0; cur_x < 12; ++cur_x) {
                    cell(kind, cx, ty, 1, cur_x, 2);
                    refcell(kind, cx, ty, 1, cur_x, 2);
                    for (k = 0; k < 8; ++k)
                        if (art[k] != ref[k]) ++bad;
                }
    assertEqual(bad, 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("variable shift after large loop nests");
    suite_add_test(check);
    return suite_run();
}
