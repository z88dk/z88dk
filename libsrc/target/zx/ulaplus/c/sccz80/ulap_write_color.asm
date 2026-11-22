; void ulap_write_color(unsigned char pent,unsigned char color)

SECTION code_clib
SECTION code_arch

PUBLIC ulap_write_color

EXTERN asm_ulap_write_color

ulap_write_color:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   ld h,e
   jp asm_ulap_write_color
