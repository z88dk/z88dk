
; ===============================================================
; 2001 Stefano Bodrato
; ===============================================================
;
; void bit_click(void)
;
; Toggle state of 1-bit output device.
;
; ===============================================================

INCLUDE "clib_target_cfg.asm"

SECTION code_clib
SECTION code_sound_bit

PUBLIC asm_bit_click

EXTERN __sound_bit_state

asm_bit_click:

   ; uses : af, c, (bc if port_16)
   
   ld a,(__sound_bit_state)
   
   and __sound_bit_read_mask
   xor __sound_bit_toggle
   
   IF __sound_bit_method = 2
   
      ld bc,__sound_bit_port
   
   ENDIF
   
   INCLUDE "sound/bit/z80/output_bit_device_1.inc"
      
   ld c,a
   ld a,(__sound_bit_state)
   
   and __sound_bit_write_mask
   or c
   
   ld (__sound_bit_state),a
   ret
