
; void bit_beepfx(void *effect)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_beepfx

EXTERN _bit_beepfx_fastcall

_bit_beepfx:

   pop af
   pop hl
   
   push hl
   push af

   jp _bit_beepfx_fastcall
