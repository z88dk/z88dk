
XLIB _bitfx_21

INCLUDE "clib_target_cfg.asm"

_bitfx_21:

   ; ascending buzzer

   ld hl,1023

hdesc1:

   push hl
   ld b,16

hdesc2:

   rl l
   rl h
   
   jr nc, hdesc3
   
   xor __sound_bit_toggle

   IF __sound_bit_method = 1
   
      out (__sound_bit_port),a
   
   ENDIF
   
   IF __sound_bit_method = 2
   
      exx
      out (c),a
      exx
   
   ENDIF
   
   IF __sound_bit_method = 3
   
      ld (__sound_bit_port),a
   
   ENDIF

hdesc3:

   djnz hdesc2
   
   pop hl
   inc hl
   
   ld c,a
   
   ld a,h
   or l
   
   ld a,c
   jr nz, hdesc1
   
   ret
