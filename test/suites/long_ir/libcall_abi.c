/* Two 80cc call/ABI codegen regressions:

   1. Taking the ADDRESS of a __LIB__ function (assigning it to a function
      pointer) must emit the symbol with NO leading underscore — classic
      library symbols are unprefixed. gen_ld_sym hardcoded `_%s` and
      produced an undefined `_strlen`.

   2. emit_hl_add_offset emits `ld de,N; add hl,de` for a member/index
      offset |N|>3; it must invalidate the DE/DEHL cache. It didn't, so a
      long held register-resident across that compute (DEHL cache: DE=high,
      BC=low) had its high word silently overwritten by the offset constant
      — the strtol() wrong-result bug (low word right, high word = stale N). */
#include "test.h"
#include <string.h>
#include <stdlib.h>

typedef unsigned int (*strlen_fp)(const char *) __smallc;
static void test_lib_fnptr_address(void)
{
    strlen_fp f = strlen;
    assertEqual((int)f("hello"), 5);
    assertEqual((int)f(""), 0);
}

/* strtol() returns its long in DEHL; the loop reads struct members at
   offsets >3 (`ld de,N; add hl,de`) between the call and consuming the
   result. The high word must survive. */
static struct sd { char *data; int base; long result; } data[] = {
   { "-30000", 10, -30000L },
   { "65535",  10,  65535L },
   { "ffff",   16,  65535L },
   { NULL, 0, 0L }
};
static void test_long_call_result_survives_offset(void)
{
    struct sd *t = &data[0];
    char *end;
    while (t->data) {
        long r = strtol(t->data, &end, t->base);   /* t->base at offset >3 */
        assertEqual((int)(r & 0xffffL), (int)(t->result & 0xffffL));
        assertEqual((int)((r >> 16) & 0xffffL), (int)((t->result >> 16) & 0xffffL));
        t++;
    }
}

int main(int argc, char *argv[])
{
    suite_setup("libcall ABI");
    suite_add_test(test_lib_fnptr_address);
    suite_add_test(test_long_call_result_survives_offset);
    return suite_run();
}
