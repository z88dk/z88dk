; void *sms_ldir_vram_to_mem_unsafe(void *dst, void *src, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC sms_ldir_vram_to_mem_unsafe

EXTERN asm_sms_ldir_vram_to_mem_unsafe

sms_ldir_vram_to_mem_unsafe:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af

   jp asm_sms_ldir_vram_to_mem_unsafe
