/* Post-render deletion of a dead DE reload (ir_lower.c fold_dead_de_reload,
 * `[IR_DEADDE_FOLD]`, `dead-de-reload`). Shape: a byte global is widened and
 * copied into DE (`ex de,hl`/`ld de,hl`), spilled to a frame slot (needed
 * again later — e.g. the `+idx` term of an `idx*5 = idx*4+idx`
 * strength-reduction expansion), then HL-only ops run a small multiply on
 * the ORIGINAL widened value, then HL is parked (`push hl`) so a
 * `ld hl,N; add hl,sp` can address that same slot and reload DE from it —
 * even though DE was never touched since the original copy. The reload,
 * and the push/park/pop bracket that exists only to perform it, are dead.
 *
 * fire() is lifted directly from examples/gb/paint.c's set_cursor() (the
 * real file this fold was found on, and where it saves 35 B / 5 sites) —
 * the same cursor_info shape, the same nested loop indexing
 * `cursors[current_cursor]` twice per outer iteration, with the hardware
 * sprite calls replaced by a plain counter so it is portable and
 * self-verifying. Proven to exercise the fold (not just pass
 * coincidentally) by diffing `-a` output with IR_OFF=dead-de-reload: two
 * `push hl / ld hl,sp+N / ld a,(hl+) / ld e,a / ld d,(hl) / pop hl`
 * brackets disappear, one per outer-loop indexed access.
 *
 * A wrong deletion here does not abort — DE would silently hold garbage
 * (or a stale value from whatever last touched it) instead of the reload's
 * value, so the sprite offset / hot_x lookup would be wrong and `calls`
 * would sum the wrong bytes. assertEqual catches that as a wrong count,
 * not a crash.
 */
#include "test.h"

typedef struct { unsigned char data_idx, w, h, hot_x, hot_y; } cursor_info;
static cursor_info cursors[10];
static unsigned char current_cursor;
static unsigned int calls;

static void touch(unsigned char i, unsigned char n, unsigned char *p)
{
    (void)i; (void)n;
    calls = (unsigned int)(calls + *p);
}

static unsigned int fire(void)
{
    unsigned char x, y, i;
    calls = 0;
    i = 0;
    for (x = 0; x < cursors[current_cursor].w; x++)
        for (y = 0; y < cursors[current_cursor].h; y++) {
            touch(i, 1, &cursors[current_cursor].hot_x);
            i++;
        }
    return calls;
}

static void test_deaddereload(void)
{
    cursors[2].w = 3;
    cursors[2].h = 4;
    cursors[2].hot_x = 5;
    current_cursor = 2;
    assertEqual(fire(), 60);          /* 3*4 iterations * hot_x(5) */

    cursors[0].w = 1;
    cursors[0].h = 1;
    cursors[0].hot_x = 9;
    current_cursor = 0;
    assertEqual(fire(), 9);

    cursors[7].w = 0;
    cursors[7].h = 5;
    cursors[7].hot_x = 3;
    current_cursor = 7;
    assertEqual(fire(), 0);           /* w==0: loop body never runs */
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Post-render dead-DE-reload deletion");
    suite_add_test(test_deaddereload);
    return suite_run();
}
