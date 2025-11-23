; void *sms_set_vram_unsafe(unsigned char c, unsigned int n)

SECTION code_clib
SECTION code_crt_common

PUBLIC sms_set_vram_unsafe_callee

EXTERN asm_sms_set_vram_unsafe

sms_set_vram_unsafe_callee:

   pop hl
   pop bc
   ex (sp),hl

   ld a,l
   jp asm_sms_set_vram_unsafe

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sms_set_vram_unsafe_callee
defc _sms_set_vram_unsafe_callee = sms_set_vram_unsafe_callee
ENDIF

