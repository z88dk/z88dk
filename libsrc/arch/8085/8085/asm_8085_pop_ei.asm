;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
; void z80_pop_ei(void)
;
; Pop the ei_di_status from the stack and restore the di/ei
; state to what it was previously when a push was called.
;
; ===============================================================

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_pop_ei
PUBLIC asm0_z80_pop_ei
PUBLIC asm_z80_pop_ei_jp

PUBLIC asm_cpu_pop_ei
PUBLIC asm0_cpu_pop_ei
PUBLIC asm_cpu_pop_ei_jp

asm_z80_pop_ei:
asm_cpu_pop_ei:

   ; F bit 3 is always 0, so the saved HL and the return address stay out of AF.
   ; The status word is the AF image from push_di. IE is bit 3 of A.
   ;
   ; enter : stack = ei_di_status, ret
   ;
   ; uses  : af, bc

   pop bc
   pop af
   push bc
   jp ei_restore

asm0_z80_pop_ei:
asm0_cpu_pop_ei:
asm_z80_pop_ei_jp:
asm_cpu_pop_ei_jp:

   ; enter : stack = ret, ei_di_status
   ;
   ; uses  : af

   pop af

ei_restore:

   and $08                     ; RIM bit 3 is IE
   jp Z,di_state

ei_state:

   ei
   ret

di_state:

   di
   ret
