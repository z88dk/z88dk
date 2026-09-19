
; ===============================================================
; Jan Bobrowski, license GPL
; prior to 2012
; ===============================================================
;
; void z180_delay_tstate(uint tstates)
;
; Z180 inner loop is 19T (add hl,bc 11 + jr c taken 8), not
; Z80's 23T. Same Bobrowski structure, retuned subtracts.
; Remainder 0..18T (jr 8/6 is only 2T, not Z80's 5T tail).
;
; ===============================================================

SECTION code_clib
SECTION code_z180

PUBLIC asm_z180_delay_tstate
PUBLIC asm_cpu_delay_tstate

asm_z180_delay_tstate:
asm_cpu_delay_tstate:

   ; enter : hl = tstates
   ;
   ; uses  : af, bc, hl

   ld bc,-70
   add hl,bc
   
   ld bc,-19

loop:

   add hl,bc
   jr c, loop

   ret
