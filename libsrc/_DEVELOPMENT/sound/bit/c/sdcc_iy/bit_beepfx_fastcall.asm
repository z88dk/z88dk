
; void bit_beepfx_fastcall(void *effect)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_beepfx_fastcall

EXTERN asm_bit_beepfx

_bit_beepfx_fastcall:

   push hl
   pop ix
   
   jp asm_bit_beepfx
