
; ===============================================================
; Jan Bobrowski, license GPL
; prior to 2012
; ===============================================================
;
; void z80_delay_tstate(uint tstates)
;
; Busy wait the number of tstates, including an unconditional
; call and the ret. Z80 path is exact (Bobrowski). 8080/8085/vm1
; and gbz80 use the same structure with a CPU-sized inner loop
; (jp is always 10T on 8080/vm1; gbz80 jr is 8/8).
;
; ===============================================================

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_delay_tstate
PUBLIC asm_cpu_delay_tstate

asm_z80_delay_tstate:
asm_cpu_delay_tstate:

   ; enter : hl = tstates (>= ~80 on 8080-family / gbz80, >= 141 on Z80)
   ;
   ; uses  : af, bc, hl

IF __CPU_INTEL__

   ; 8080 / 8085 / vm1: add hl,bc = 10T, jp cc = 10T taken (8085 not-taken 7T).
   ; Inner loop 20T. Remainder is 0..19T (no 1T tail: jp has no 7/12 split).

   ld bc,-77
   add hl,bc

   ld bc,-20

loop:

   add hl,bc
   jp c, loop

   ret

ELIF __CPU_GBZ80__

   ; gbz80: add hl,bc = 8, jr cc = 8/8. Inner loop 16 cycles.

   ld bc,-68
   add hl,bc

   ld bc,-16

loop:

   add hl,bc
   jr c, loop

   ret

ELSE

   ld bc,-141
   add hl,bc
   
   ld bc,-23

loop:

   add hl,bc
   jr c, loop
   
   ld a,l
   add a,15
   jr nc, g0
   
   cp 8
   jr c, g1

   or 0

g0:

   inc hl

g1:

   rra
   jr c, b0
   
   nop

b0:

   rra
   jr nc, b1
   
   or 0

b1:

   rra
   ret nc
   
   ret

ENDIF
