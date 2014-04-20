
XLIB _bitfx_16

INCLUDE "clib_target_cfg.asm"

_bitfx_16:

   ; blirp

   ld b,255

expl:

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
   
   ENDIF
   
   IF __sound_bit_method = 2
   
      exx
      out (c),a
      exx
   
   ENDIF
   
   IF __sound_bit_method = 3
   
      ld (__sound_bit_port),a
   
   ENDIF

   push bc

dly:

   nop
   djnz dly
   
   pop bc
   
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
   
   ENDIF
   
   IF __sound_bit_method = 2
   
      exx
      out (c),a
      exx
   
   ENDIF
   
   IF __sound_bit_method = 3
   
      ld (__sound_bit_port),a
   
   ENDIF

   push bc
   push af
   
   ld a,255
   sub b
   ld b,a
   
   pop af

dly2:

   nop
   djnz dly2
   
   pop bc
   djnz expl
   
   ret
