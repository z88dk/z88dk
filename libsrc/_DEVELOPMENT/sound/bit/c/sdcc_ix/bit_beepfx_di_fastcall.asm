
; void bit_beepfx_di_fastcall(void *effect)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_beepfx_di_fastcall

EXTERN asm_bit_beepfx_di

_bit_beepfx_di_fastcall:
   
   push hl
   ex (sp),ix
   
   call asm_bit_beepfx_di
   
   pop ix
   ret
