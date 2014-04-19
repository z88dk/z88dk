
; ===============================================================
; 2001 Stefano Bodrato
; ===============================================================
;
; void bit_click(void)
;
; Toggle state of 1-bit output device.
;
; ===============================================================

INCLUDE "clib_cfg.asm"

XLIB asm_bit_click

XREF __sound_bit_state

asm_bit_click:

   ; uses : af, c, (bc if port_16)
   
   ld a,(__sound_bit_state)
   
   and __sound_bit_read_mask
   xor __sound_bit_toggle
   
   IF __sound_bit_method = 1
   
      out (__sound_bit_port),a
   
   ELSE IF __sound_bit_method = 2

      ld bc,__sound_bit_port
      out (c),a
   
   ELSE IF __sound_bit_method = 3
   
      ld (__sound_bit_port),a
   
   ENDIF
   
   ld c,a
   ld a,(__sound_bit_state)
   
   and __sound_bit_write_mask
   or c
   
   ld (__sound_bit_state),a
   ret
