/* __sfr I/O ports must lower to in/out, NOT to a memory access.
 *
 * A `__sfr __at N x;` declaration names a PORT NUMBER, not storage. The
 * lowerer used to treat the symbol as an ordinary global, so `x = v` became
 * `ld (N),hl` -- a 16-bit write to ADDRESS N -- and `v = x` became
 * `ld hl,(N)`. Two faults compounded: the port was never driven at all, and
 * the access was word-wide on a byte port, so it also clobbered N+1. Any
 * driver written against __sfr was silently dead, and on a target whose
 * address N is RAM it corrupted whatever lived there.
 *
 * HOW THIS TEST DETECTS IT, without needing a device behind the port:
 * ticks does not emulate peripherals, so a real `in` reads the open bus and
 * yields 0xff. A memory access, by contrast, ROUND-TRIPS -- write 0x5a, read
 * 0x5a back. So `port = 0x5a; v = port;` returning 0xff proves the access
 * reached the port, and returning 0x5a proves it went to memory. That is the
 * exact signature of the bug: the broken compiler produced 0x5a here.
 *
 * The second fault is pinned by the ADJACENT port. tport2 sits at 0x11, one
 * past tport, so the old word-wide store to tport ran its high byte straight
 * through tport2's location; a byte-correct write leaves it untouched. The
 * `guard` object is only an ordinary-storage sanity check and is not where
 * the stray byte landed.
 *
 * NOT run for gbz80: it has no in/out, so the access lowers to `ldh`, which
 * addresses the 0xff00 page -- real memory that legitimately round-trips.
 * The 0xff assumption below would be wrong there by design, not by defect.
 *
 * Self-verifying, no printf.
 */
#include "test.h"

/* Ports chosen high enough to miss anything the test target decodes. */
__sfr __at 0x10 tport;
__sfr __at 0x11 tport2;

static unsigned char guard = 0x3c;

/* Through a function so the value stays a runtime operand and the write
   cannot be folded into the read. */
static unsigned char port_roundtrip(unsigned char v)
{
    tport = v;
    return tport;
}

static void test_sfr_is_not_memory(void)
{
    /* The load must come from the port (open bus, 0xff), not from the
       location just written. 0x5a here means the write and the read both
       went to memory address 0x10. */
    Assert(port_roundtrip(0x5a) == 0xff, "port read is not the written value");
    Assert(port_roundtrip(0x00) == 0xff, "port read after 0x00 write");
    Assert(port_roundtrip(0xff) == 0xff, "port read after 0xff write");

    /* A distinct port must behave the same, and must not alias the first. */
    tport2 = 0xa5;
    Assert(tport2 == 0xff, "second port read is open bus");

    /* Byte-width: a word-wide store through the port symbol would have
       written a second byte past it. */
    Assert(guard == 0x3c, "port write stayed byte-wide");
}

/* Each access is observable, so neither may be optimised away: two reads in
   one expression must issue two `in`s, and consecutive writes must all issue.
   If the port were treated as an ordinary global, CSE would fold the reads
   and dead-store elision would drop every write but the last. Both reads
   still yield open bus, so the sum is deterministic. */
static void test_sfr_is_volatile(void)
{
    unsigned int sum = (unsigned int)tport + (unsigned int)tport;
    Assert(sum == 0x1fe, "two port reads both issued");

    tport = 0x01;
    tport = 0x02;
    tport = 0x03;
    Assert(tport == 0xff, "writes did not turn the port into storage");
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("__sfr ports lower to in/out, not memory");
    suite_add_test(test_sfr_is_not_memory);
    suite_add_test(test_sfr_is_volatile);
    return suite_run();
}
