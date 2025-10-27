; void *ulap_write_palette(void *src,unsigned char pent,unsigned char num)

SECTION code_clib
SECTION code_arch

PUBLIC ulap_write_palette

EXTERN asm_ulap_write_palette

ulap_write_palette:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   ld d,c
   jp asm_ulap_write_palette
