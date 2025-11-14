; void ulap_write_color(unsigned char pent,unsigned char color)

SECTION code_clib
SECTION code_arch

PUBLIC _ulap_write_color

EXTERN asm_ulap_write_color

_ulap_write_color:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_ulap_write_color
