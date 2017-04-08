; void *sms_ldir_vram_to_mem_unsafe(void *dst, void *src, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_ldir_vram_to_mem_unsafe_callee

EXTERN asm_sms_ldir_vram_to_mem_unsafe

_sms_ldir_vram_to_mem_unsafe_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af

   jp asm_sms_ldir_vram_to_mem_unsafe
