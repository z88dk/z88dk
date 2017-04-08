; void *sms_ldir_vram_to_vram_unsafe(void *dst, void *src, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC sms_ldir_vram_to_vram_unsafe_callee

EXTERN asm_sms_ldir_vram_to_vram_unsafe

sms_ldir_vram_to_vram_unsafe_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af

   jp asm_sms_ldir_vram_to_vram_unsafe
