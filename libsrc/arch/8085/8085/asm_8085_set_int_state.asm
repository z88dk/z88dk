;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
; void z80_set_int_state(unsigned int state)
;
; Set the ei/di status previously retrieved.
;
; ===============================================================

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_set_int_state
PUBLIC asm_cpu_set_int_state

asm_z80_set_int_state:
asm_cpu_set_int_state:

   ; enter : l = ei/di status
   ;
   ; uses  : af

   ld a,l
   and $08                     ; RIM bit 3 is IE
   jp Z,di_state

ei_state:

   ei
   ret

di_state:

   di
   ret
