;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
; void z80_push_di(void)
;
; Save the current ei/di status on the stack and disable ints.
;
; ===============================================================

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_push_di
PUBLIC asm_cpu_push_di

asm_z80_push_di:
asm_cpu_push_di:

   ; F bit 3 is always 0, so a return address parked in AF loses that bit.
   ; Read RIM while the return address is still on the stack, then di.
   ; The RIM byte stays in A. pop_ei tests bit 3.
   ;
   ; exit  : stack = ei_di_status
   ;
   ; uses  : af, bc

   rim
   di
   pop bc
   push af
   push bc
   ret
