; void *ulap_read_palette(void *dst,unsigned char pent,unsigned char num)

SECTION code_clib
SECTION code_arch

PUBLIC ulap_read_palette_callee

EXTERN asm_ulap_read_palette

ulap_read_palette_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   ld d,c
   jp asm_ulap_read_palette
