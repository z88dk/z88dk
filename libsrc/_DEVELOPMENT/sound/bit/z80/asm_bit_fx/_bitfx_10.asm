
XLIB _bitfx_10

INCLUDE "clib_target_cfg.asm"

_bitfx_10:

   ; Dual note with LOT of fuzzy added
   
   ld b,100

ts_loop:

   dec h
   jr nz, ts_jump
   
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
   
   ELSE IF __sound_bit_method = 2
   
      exx
      out (c),a
      exx
   
   ELSE IF __sound_bit_method = 3
   
      ld (__sound_bit_port),a
   
   ENDIF
   
   pop hl
   xor __sound_bit_toggle

   IF __sound_bit_method = 1
   
      out (__sound_bit_port),a
   
   ELSE IF __sound_bit_method = 2
   
      exx
      out (c),a
      exx
   
   ELSE IF __sound_bit_method = 3
   
      ld (__sound_bit_port),a
   
   ENDIF

ts_FR_1:

   ld h,130

ts_jump:

   dec l
   jr nz, ts_loop
   
   push hl
   push af
   
   ld a,__sound_bit_toggle
   ld l,h
   ld h,0
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

   pop hl
   xor __sound_bit_toggle

   IF __sound_bit_method = 1
   
      out (__sound_bit_port),a
   
   ELSE IF __sound_bit_method = 2
   
      exx
      out (c),a
      exx
   
   ELSE IF __sound_bit_method = 3
   
      ld (__sound_bit_port),a
   
   ENDIF

ts_FR_2:

   ld l,155
   djnz ts_loop
   
   ret
