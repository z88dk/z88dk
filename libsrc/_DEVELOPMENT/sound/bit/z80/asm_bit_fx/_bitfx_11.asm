
XLIB _bitfx_11

INCLUDE "clib_target_cfg.asm"

_bitfx_11:

   ; klaxon 2
   
   ld b,200

cs_loop:

   dec h
   jr nz, cs_jump
   
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
   ld b,250

cswait1:

   djnz cswait1
   
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

cs_FR_1:

   ld h,230

cs_jump:

   inc l
   jr nz, cs_loop
   
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
   ld b,200

cswait2:

   djnz cswait2
   
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

cs_FR_2:

   ld l,0
   djnz cs_loop
   
   ret
