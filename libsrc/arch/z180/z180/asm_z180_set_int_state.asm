
; ===============================================================
; Stefano Bodrato
; ===============================================================
;
; void z180_set_int_state(unsigned int state)
;
; Set the ei/di status previously retrieved.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_z180

PUBLIC asm_z180_set_int_state
PUBLIC asm_cpu_set_int_state

asm_z180_set_int_state:
asm_cpu_set_int_state:

   ; enter : l = ei/di status
   ;
   ; uses  : f

   bit 2,l                  ; check p/v flag
   jr z, di_state
   
ei_state:

   ei
   ret

di_state:

   di
   ret
