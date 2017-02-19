
; ===============================================================
; Stefano Bodrato
; ===============================================================
;
; void z80_set_int_state(unsigned int state)
;
; Set the ei/di status previously retrieved.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_set_int_state

asm_z80_set_int_state:

   ; enter : hl = ei/di status
   ;
   ; uses  : f

   IF __z80_cpu_info & $01
   
      bit 0,l                  ; check carry flag
   
   ELSE
   
      bit 2,l                  ; check p/v flag
   
   ENDIF
   
   jr z, di_state
   
ei_state:

   ei
   ret

di_state:

   di
   ret
