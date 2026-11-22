; unsigned char ulap_read_color(unsigned char pent)

SECTION code_clib
SECTION code_arch

PUBLIC _ulap_read_color

EXTERN asm_ulap_read_color

_ulap_read_color:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_ulap_read_color
