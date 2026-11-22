
; void bit_beepfx_di(void *effect)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_beepfx_di

EXTERN _bit_beepfx_di_fastcall

_bit_beepfx_di:

   pop af
   pop hl
   
   push hl
   push af

   jp _bit_beepfx_di_fastcall
