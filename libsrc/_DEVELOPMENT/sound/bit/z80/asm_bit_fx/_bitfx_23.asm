
XLIB _bitfx_23

INCLUDE "clib_target_cfg.asm"

_bitfx_23:

   ; noise 7

   ld hl,4000

fx71:

   push hl
   push af
   
   ld a,__sound_bit_toggle
   and l
   ld l,a
   
   pop af
   xor l

   IF __sound_bit_method = 1
   
      out (__sound_bit_port),a
   
   ELSE IF __sound_bit_method = 2
   
      exx
      out (c),a
      exx
   
   ELSE IF __sound_bit_method = 3
   
      ld (__sound_bit_port),a
   
   ENDIF

   pop hl
   dec hl
   
   ld c,a
   
   ld a,h
   or l
   
   ld a,c
   jr nz, fx71
   
   ret
