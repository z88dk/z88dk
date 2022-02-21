
; void bit_beepfx(void *effect)

SECTION code_clib
SECTION code_sound_bit

IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_RABBIT__
PUBLIC bit_beepfx
PUBLIC _bit_beepfx

EXTERN asm_bit_beepfx

bit_beepfx:
_bit_beepfx:
   push hl
   ex (sp),ix

   call asm_bit_beepfx

   pop ix
   ret

ENDIF
