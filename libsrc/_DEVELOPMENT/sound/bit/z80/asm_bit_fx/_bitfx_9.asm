
XLIB _bitfx_9

INCLUDE "clib_target_cfg.asm"

_bitfx_9:

   ; Dual note with fuzzy added
   
   ld b,100

ss_loop:

   dec h
   jr nz, ss_jump
   
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

ss_FR_1:

   ld h,230

ss_jump:

   dec l
   jr nz, ss_loop
   
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

ss_FR_2:

   ld l,255
   djnz ss_loop

   ret
