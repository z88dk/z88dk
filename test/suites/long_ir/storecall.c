/* Regression: storing through a pointer RETURNED BY A FUNCTION CALL.
   `*(T*)func(...) = value` miscompiled — the width-2 store lowering emitted a
   raw `ex de,hl` (value->DE) without swapping the regcache beliefs, so the
   following load_to_hl(base) trusted a stale "base in DE" belief (the base
   arrives in DE as the call result) and copied DE (now the value) into HL:
       ld l,e ; ld h,d ; ld (hl),e ...
   i.e. it stored to the value-as-address instead of the returned pointer, so
   the target was never written. This is exactly emu.c's write_reg:
       write_w(reg_align(ptr,1), (type16)val)
   which corrupted the emulated 68000 register file. Fix: mirror the ex de,hl
   swap in the regcache (ir_lower_ops.inc.c gen_st_mem width-2 path). */
#include "test.h"
#include <intrinsic.h>
typedef unsigned char  u8;
typedef unsigned short u16;
typedef unsigned long  u32;

static u8 mem[8];
/* a normal (non-fastcall) call returning a pointer — the emu.c reg_align shape */
static u8 *ralign(u8 *p, u8 s){ (void)s; return p; }

static void st8 (u8 *p, u8  v){ *ralign(p,0) = v; }
static void st16(u8 *p, u16 v){ *(u16 *)ralign(p,1) = v; }
static void st16sw(u8 *p, u16 v){ *(u16 *)ralign(p,1) = intrinsic_swap_endian_16(v); }
static void st32(u8 *p, u32 v){ *(u32 *)ralign(p,2) = v; }

static void run(void){
  mem[0]=mem[1]=0;
  st16(mem, 0x1234);
  Assert(mem[0]==0x34 && mem[1]==0x12, "st16 via call-ptr");

  mem[0]=mem[1]=0;
  st16sw(mem, 0x1234);                    /* swap16 -> LE bytes 12,34 (emu.c write_w idiom) */
  Assert(mem[0]==0x12 && mem[1]==0x34, "st16sw via call-ptr");

  mem[0]=0;
  st8(mem, 0xA5);
  Assert(mem[0]==0xA5, "st8 via call-ptr");

  mem[0]=mem[1]=mem[2]=mem[3]=0;
  st32(mem, 0x11223344UL);                /* LE bytes 44,33,22,11 */
  Assert(mem[0]==0x44 && mem[1]==0x33 && mem[2]==0x22 && mem[3]==0x11, "st32 via call-ptr");
}
int main(int c,char**v){(void)c;(void)v;suite_setup("storecall");suite_add_test(run);return suite_run();}
