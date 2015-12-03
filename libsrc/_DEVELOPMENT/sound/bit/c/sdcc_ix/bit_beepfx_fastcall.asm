
; void bit_beepfx_fastcall(void *effect)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_beepfx_fastcall

EXTERN asm_bit_beepfx

_bit_beepfx_fastcall:
   
   push hl
   ex (sp),ix
   
   call asm_bit_beepfx
   
   pop ix
   ret
