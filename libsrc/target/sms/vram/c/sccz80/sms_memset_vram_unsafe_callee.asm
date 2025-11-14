; void *sms_memset_vram(void *dst, unsigned char c, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC sms_memset_vram_unsafe_callee

EXTERN asm_sms_memset_vram_unsafe

sms_memset_vram_unsafe_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   ld a,l
   jp asm_sms_memset_vram_unsafe

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sms_memset_vram_unsafe_callee
defc _sms_memset_vram_unsafe_callee = sms_memset_vram_unsafe_callee
ENDIF

