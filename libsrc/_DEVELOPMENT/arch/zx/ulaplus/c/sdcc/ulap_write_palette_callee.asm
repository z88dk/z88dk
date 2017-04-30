; void *ulap_write_palette(void *src,unsigned char pent,unsigned char num)

SECTION code_clib
SECTION code_arch

PUBLIC _ulap_write_palette_callee

EXTERN asm_ulap_write_palette

_ulap_write_palette_callee:

   pop af
   pop hl
   pop de
   push af

   jp asm_ulap_write_palette
