; void *sms_ldir_vram_to_mem(void *dst, void *src, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC sms_ldir_vram_to_mem_callee

EXTERN asm_sms_ldir_vram_to_mem

sms_ldir_vram_to_mem_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af

   jp asm_sms_ldir_vram_to_mem
