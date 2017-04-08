; void *sms_ldir_mem_to_vram_unsafe(void *dst, void *src, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC sms_ldir_mem_to_vram_unsafe

EXTERN asm_sms_ldir_mem_to_vram_unsafe

sms_ldir_mem_to_vram_unsafe:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af

   jp asm_sms_ldir_mem_to_vram_unsafe
