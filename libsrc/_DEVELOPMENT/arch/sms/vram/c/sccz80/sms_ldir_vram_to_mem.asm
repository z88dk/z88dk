; void *sms_ldir_vram_to_mem(void *dst, void *src, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC sms_ldir_vram_to_mem

EXTERN asm_sms_ldir_vram_to_mem

sms_ldir_vram_to_mem:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af

   jp asm_sms_ldir_vram_to_mem
