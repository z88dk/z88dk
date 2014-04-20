
XLIB _bitfx_17

INCLUDE "clib_target_cfg.asm"

_bitfx_17:

   ; blirp 2

   ld b,100

blrp:

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

dlyb:

   nop
   djnz dlyb
   
   pop bc
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

   push bc

dlya:

   nop
   djnz dlya
   
   pop bc
   djnz blrp
   
   ret
