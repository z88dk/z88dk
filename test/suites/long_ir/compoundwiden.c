/* Regression: a compound-assign `wide op= narrow` (global / deref lvalue) did
   not widen the narrow RHS to the lvalue width before the op, so the binop
   mixed widths and the wide high bytes read stale storage. e.g.
       long_g  += (short)word_g;   // needs sign-extend short->long
       long_g  += word_g;          // needs zero-extend  u16 -> u32
       *(long*)p += (short)*q;     // deref lvalue, same
   This was the emu.c fp-mode blocker: branch() does
       pc += (type16s) read_w(effective(pc));
   (pc is type32) — the missing sign-extension corrupted the emulated PC. */
#include "test.h"
typedef unsigned short u16;
typedef signed   short s16;
typedef unsigned long  u32;
typedef signed   long  s32;

static u16 wg;
static s16 sgv;
static u32 pg;
static s32 spg;
static u32 pd;

static void run(void){
  /* global lvalue: unsigned narrow -> zero extend */
  wg = 0xFFFB; pg = 0; pg += wg;
  Assert(pg == 65531UL, "u32 += u16 (zero-extend)");

  /* global lvalue: signed narrow -> sign extend */
  wg = 0xFFFB; spg = 0; spg += (s16)wg;
  Assert(spg == -5, "s32 += (s16)u16 (sign-extend)");

  /* signed-short global source (also guards the negative-constant store:
     z80asm's `/256` truncated -5 to a 0x00 high byte on gbz80) */
  sgv = -5; spg = 10; spg += sgv;
  Assert(spg == 5, "s32 += s16 global (sign-extend)");

  /* deref lvalue: signed narrow -> sign extend */
  wg = 0xFFFB; pd = 0; { u32 *p = &pd; *p += (s16)wg; }
  Assert(pd == 0xFFFFFFFBUL, "*(u32*)p += (s16)u16 (sign-extend)");

  /* subtraction too */
  wg = 3; spg = 0; spg -= (s16)wg;
  Assert(spg == -3, "s32 -= (s16)u16");
}
int main(int c,char**v){(void)c;(void)v;suite_setup("compoundwiden");suite_add_test(run);return suite_run();}
