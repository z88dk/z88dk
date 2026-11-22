/*
 * KR580VM1 (КР580ВМ1) - Soviet extended 8080.
 *
 * Everything the VM1 adds on top of the 8080:
 *
 *   $08/$18       DSUB  - HL <- HL - rr           (sub hl,bc / sub hl,de)
 *   $10/$20/$30   ANX/ORX/XRX - (HL) <- (HL) op A
 *   $CB/$DD       DCMP  - flags from HL - rr      (cp hl,bc / cp hl,de)
 *   $D9           SHLX  - (DE) <- HL
 *   $ED           LHLX  - HL <- (DE)
 *   $FD           JOF   - jump if the overflow flag is set
 *   $28           MB prefix, also called CS
 *   $38           RS prefix
 *   $28 $00/$7F   SMF0/SMF1 - select the current data bank
 *
 * The RS prefix substitutes the alternate pointer pair H1L1 for HL in the
 * following instruction - as source, as destination, and as the (HL) memory
 * pointer. Rather than teach every H/L site about it (the main-page (hl)
 * accesses go through LDRP(h,l,..) and 38 hardcoded l|h<<8 expressions, none
 * of which are altd/alts aware) we simply exchange h/l with the otherwise
 * unused z80 shadow pair h_/l_ for the duration of one instruction. EX AF,AF'
 * and EXX do not exist on this CPU, so the shadow set is free for this.
 *
 * The MB prefix flips the data bank for one instruction. In front of DAD,
 * DSUB and DCMP it is instead called CS and makes them consume the carry.
 */

#include "ticks.h"
#include "memory.h"
#include <stdio.h>

/* KR580VM1 PSW:  S Z OF AC MF P 1 CY  */
#define VM1_CY  0x01
#define VM1_ONE 0x02
#define VM1_P   0x04
#define VM1_MF  0x08
#define VM1_AC  0x10
#define VM1_OF  0x20
#define VM1_Z   0x40
#define VM1_S   0x80

int vm1_mf;         /* PSW bit 3: which bank data accesses use  */
int vm1_mb;         /* MB/CS prefix is pending for this instruction */
int vm1_rs;         /* RS prefix state, see vm1_rs_* below */

/* Bank that data accesses should use: the current bank, inverted for one
   instruction by an MB prefix. Called from memory.c. */
int vm1_bank_select(void)
{
    return (vm1_mf ^ (vm1_mb ? 1 : 0)) & 1;
}

/* The 16 bit ops touch only a few flags, so read/modify/write the composed
   PSW rather than hand-rolling ff/fr/fa/fb for each one. */
static void vm1_setflags(int mask, int value)
{
    setf((f() & ~mask) | (value & mask));
}

static int vm1_carry(void)
{
    return f() & VM1_CY;
}

/* DSUB: HL <- HL - rr, minus the carry when preceded by CS. S, Z and CY. */
void vm1_dsub(uint8_t rh, uint8_t rl)
{
    int hl  = (h << 8) | l;
    int rr  = (rh << 8) | rl;
    int res = hl - rr - (vm1_mb ? (vm1_carry() ? 1 : 0) : 0);

    h = (res >> 8) & 0xff;
    l = res & 0xff;

    vm1_setflags(VM1_S | VM1_Z | VM1_CY,
                 (res & 0x8000 ? VM1_S : 0)
                 | ((res & 0xffff) == 0 ? VM1_Z : 0)
                 | (res < 0 ? VM1_CY : 0));
    st += 10;
}

/* DCMP: as DSUB but the result is discarded. */
void vm1_dcmp(uint8_t rh, uint8_t rl)
{
    int hl  = (h << 8) | l;
    int rr  = (rh << 8) | rl;
    int res = hl - rr - (vm1_mb ? (vm1_carry() ? 1 : 0) : 0);

    vm1_setflags(VM1_S | VM1_Z | VM1_CY,
                 (res & 0x8000 ? VM1_S : 0)
                 | ((res & 0xffff) == 0 ? VM1_Z : 0)
                 | (res < 0 ? VM1_CY : 0));
    st += 10;
}

/* DAD with a CS prefix: HL <- HL + rr + CY. Only CY is affected. The
   plain form stays on the shared ADDRRRR path in ticks.c. */
void vm1_dadc(uint8_t rh, uint8_t rl)
{
    int res = ((h << 8) | l) + ((rh << 8) | rl) + (vm1_carry() ? 1 : 0);

    h = (res >> 8) & 0xff;
    l = res & 0xff;
    vm1_setflags(VM1_CY, res > 0xffff ? VM1_CY : 0);
    st += 10;
}

/* ANX/ORX/XRX: (HL) <- (HL) op A. S, Z and P set, CY cleared, OF and AC
   left alone. Reuse the 8 bit ALU path for the flags by doing the operation
   into a scratch copy of A, then putting the result back in memory. */
void vm1_memop(uint8_t opcode)
{
    uint16_t addr = l | h << 8;
    uint8_t  m    = get_memory_data(addr);
    uint8_t  res;
    int      flags;

    switch ( opcode ) {
        case 0x10: res = m & a; break;
        case 0x20: res = m | a; break;
        default:   res = m ^ a; break;
    }

    put_memory(addr, res);

    flags = f() & ~(VM1_S | VM1_Z | VM1_P | VM1_CY);
    flags |= (res & 0x80) ? VM1_S : 0;
    flags |= res ? 0 : VM1_Z;
    flags |= (0x9669 >> ((res ^ res >> 4) & 15) & 1) ? VM1_P : 0;
    setf(flags);
    st += 10;
}

/* LHLX: HL <- (DE) */
void vm1_lhlx(void)
{
    uint16_t addr = e | d << 8;

    l = get_memory_data(addr);
    h = get_memory_data(addr + 1);
    st += 10;
}

/* SHLX: (DE) <- HL */
void vm1_shlx(void)
{
    uint16_t addr = e | d << 8;

    put_memory(addr, l);
    put_memory(addr + 1, h);
    st += 10;
}

/* JOF: jump if the overflow flag is set. */
void vm1_jof(void)
{
    uint16_t target = get_memory_inst(pc) | get_memory_inst(pc + 1) << 8;

    if ( f() & VM1_OF ) pc = mp = target;
    else pc += 2;
    st += 10;
}

/* SMF0/SMF1 - $28 $00 and $28 $7F. Select the current data bank. These are
   whole instructions, not a prefix plus an instruction, so they charge the
   full 8T/9T for both bytes. */
void vm1_smf(int bank)
{
    vm1_mf = bank;
    pc++;                       /* eat the $00 / $7F */
    st += bank ? 9 : 8;
}

/*
 * RS prefix. vm1_rs runs 0 -> 2 (armed, registers swapped) -> 1 (the
 * prefixed instruction is executing) -> 0 (swapped back). The step from 2
 * to 1 and the final unwind both happen in vm1_prefix_step(), called once
 * per instruction from cpu_run() after the opcode switch.
 */
static void vm1_swap_hl(void)
{
    uint8_t t;

    t = h; h = h_; h_ = t;
    t = l; l = l_; l_ = t;
}

void vm1_rs_prefix(void)
{
    /* XCHG is the one H/L instruction the doc gives no RS form for: it
       always exchanges DE with the real HL. */
    if ( get_memory_inst(pc) != 0xeb && vm1_rs == 0 ) {
        vm1_swap_hl();
        vm1_rs = 2;
    }
    st += 4;
}

void vm1_mb_prefix(void)
{
    vm1_mb = 2;
    st += 4;
}

/* Retire one instruction's worth of prefix state. */
void vm1_prefix_step(void)
{
    if ( vm1_rs == 2 ) vm1_rs = 1;
    else if ( vm1_rs == 1 ) {
        vm1_swap_hl();
        vm1_rs = 0;
    }

    if ( vm1_mb == 2 ) vm1_mb = 1;
    else if ( vm1_mb == 1 ) vm1_mb = 0;
}

/* True while a prefix is waiting for its instruction - interrupts must not
   land in the middle, exactly as for the Rabbit's altd/alts. */
int vm1_prefix_pending(void)
{
    return vm1_rs || vm1_mb;
}
