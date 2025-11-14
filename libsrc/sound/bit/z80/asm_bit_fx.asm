
; ===============================================================
; Dominic Morris, adapted by Stefano Bodrato
; ===============================================================
;
; void bit_fx(void *effect)
;
; Plays the selected sound effect on the one bit device.
;
; ===============================================================

SECTION code_clib
SECTION code_sound_bit

PUBLIC asm_bit_fx

INCLUDE "config_private.inc"

EXTERN l_jphl, asm_bit_open, asm_bit_close

asm_bit_fx:

   ; enter : hl = void *effect
   ;
   ; uses  : af, bc, de, hl, ix, (bc' if port_16)

   call asm_bit_open
   
   IF __sound_bit_method = 2
   
      exx
      ld bc,__sound_bit_port
      exx
   
   ENDIF
   
   call l_jphl
   ret c                       ; carry set indicates do not close
   
   jp asm_bit_close
