
; ===============================================================
; Jan Bobrowski, license GPL
; prior to 2012
; Z180 tail, October 2026
; ===============================================================
;
; void z180_delay_tstate(uint tstates)
;
; Busy wait exactly HL states, including an unconditional call
; and the ret. HL must be >= 115.
;
; Z180 states (Z8018x Family MPU User Manual, UM005003):
;   call 16, ld rr,nn 9, add hl,rr 7, jr cc 8/6,
;   ld r,r 4, sub r 4, rra 3, nop 3, or r 4, ret 9.
; The loop is add hl,bc + jr c (15). A jr over a pad of
; (n+2) states is n states longer when it is not taken, so
; four bits of the 0..14 remainder are 1, 2, 4 and 8.
;
; ===============================================================

SECTION code_clib
SECTION code_z180

PUBLIC asm_z180_delay_tstate
PUBLIC asm_cpu_delay_tstate

asm_z180_delay_tstate:
asm_cpu_delay_tstate:

   ; enter : hl = tstates >= 115
   ;
   ; uses  : af, bc, hl

   ld bc,-115
   add hl,bc

   ld bc,-15

loop:

   add hl,bc
   jr c, loop

   ld a,l
   sub c                       ; a = remainder 0..14, carry = 0

   rra
   jr nc, bit0                 ; +1 when bit 0 is set
   nop

bit0:

   rra
   jr nc, bit1                 ; +2 when bit 1 is set
   or a

bit1:

   rra
   jr nc, bit2                 ; +4 when bit 2 is set
   nop
   nop

bit2:

   rra
   jr nc, bit3                 ; +8 when bit 3 is set
   or a
   nop
   nop

bit3:

   ret
