; void *ulap_read_palette(void *dst,unsigned char pent,unsigned char num)

SECTION code_clib
SECTION code_arch

PUBLIC _ulap_read_palette

EXTERN asm_ulap_read_palette

_ulap_read_palette:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp asm_ulap_read_palette
