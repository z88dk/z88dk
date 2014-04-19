
XLIB _bitfx_19

INCLUDE "clib_target_cfg.asm"

_bitfx_19:

  ; blurp

   ld b,255

blurp2:

   push af
   
   ld a,__sound_bit_toggle
   ld h,0
   ld l,b
   and (hl)
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

   push af
   
   ld a,(hl)

dblurp:

   dec a
   jr nz, dblurp
   
   pop af
   djnz blurp2
   
   ret
