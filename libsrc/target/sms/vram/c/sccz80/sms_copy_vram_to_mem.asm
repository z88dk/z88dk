; void *sms_copy_vram_to_mem(void *dst, unsigned int n)

SECTION code_clib
SECTION code_crt_common

PUBLIC sms_copy_vram_to_mem

EXTERN asm_sms_copy_vram_to_mem

sms_copy_vram_to_mem:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_sms_copy_vram_to_mem

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sms_copy_vram_to_mem
defc _sms_copy_vram_to_mem = sms_copy_vram_to_mem
ENDIF

