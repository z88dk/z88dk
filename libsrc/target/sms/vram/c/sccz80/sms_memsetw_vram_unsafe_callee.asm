; void *sms_memsetw_vram_unsafe(void *dst, unsigned int c, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC sms_memsetw_vram_unsafe_callee

EXTERN asm_sms_memsetw_vram_unsafe

sms_memsetw_vram_unsafe_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   jp asm_sms_memsetw_vram_unsafe

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sms_memsetw_vram_unsafe_callee
defc _sms_memsetw_vram_unsafe_callee = sms_memsetw_vram_unsafe_callee
ENDIF

