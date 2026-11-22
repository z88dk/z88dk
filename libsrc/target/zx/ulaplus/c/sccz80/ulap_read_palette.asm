; void *ulap_read_palette(void *dst,unsigned char pent,unsigned char num)

SECTION code_clib
SECTION code_arch

PUBLIC ulap_read_palette

EXTERN asm_ulap_read_palette

ulap_read_palette:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   ld d,c
   jp asm_ulap_read_palette
