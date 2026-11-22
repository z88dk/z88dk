
; ===============================================================
; 2001 Stefano Bodrato
; ===============================================================
;
; void bit_click(void)
;
; Toggle state of 1-bit output device.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_sound_bit

PUBLIC asm_bit_click

EXTERN __sound_bit_state

asm_bit_click:

   ; uses : af, c, (bc if port_16)
   
   ld a,(__sound_bit_state)
   
   and __SOUND_BIT_READ_MASK
   xor __SOUND_BIT_TOGGLE
   
   IF __SOUND_BIT_METHOD = 2
   
      ld bc,__SOUND_BIT_PORT
   
   ENDIF
   
   INCLUDE "sound/bit/z80/output_bit_device_1.inc"
      
   ld c,a
   ld a,(__sound_bit_state)
   
   and __SOUND_BIT_WRITE_MASK
   or c
   
   ld (__sound_bit_state),a
   ret
