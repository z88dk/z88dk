; void *ulap_read_palette(void *dst,unsigned char pent,unsigned char num)

SECTION code_clib
SECTION code_arch

PUBLIC _ulap_read_palette_callee

EXTERN asm_ulap_read_palette

_ulap_read_palette_callee:

   pop af
   pop hl
   pop de
   push af

   jp asm_ulap_read_palette
