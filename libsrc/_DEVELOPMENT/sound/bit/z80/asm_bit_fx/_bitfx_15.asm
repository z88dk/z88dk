
XLIB _bitfx_15

INCLUDE "clib_target_cfg.asm"

_bitfx_15:

   ; explosion
   
   ld hl,1

expl:

   push hl
   push af
   
   ld a,__sound_bit_toggle
   ld h,0
   and (hl)
   ld l,a
   
   pop af
   xor l

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

   pop hl
   
   push af
   
   ld b,h
   ld c,l

dly:

   dec bc

   ld a,b
   or c

   jr nz, dly
   
   pop af

   inc hl
   
   bit 1,h
   jr z, expl
   
   ret
