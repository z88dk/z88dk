
; ===============================================================
; Jan Bobrowski, license GPL
; prior to 2012
; ===============================================================
;
; void z80_delay_tstate(uint tstates)
;
; Busy wait exactly the number of tstates, which includes the
; time needed for an unconditional call and the ret.
;
; ===============================================================

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_delay_tstate

asm_z80_delay_tstate:

   ; enter : hl = tstates >= 141
   ;
   ; uses  : af, bc, hl

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
