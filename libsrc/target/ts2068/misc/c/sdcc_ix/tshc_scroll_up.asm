; void tshc_scroll_up(uchar prows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_scroll_up

EXTERN asm0_tshc_scroll_up

_tshc_scroll_up:

   pop af
   pop de
   
   push de
   push af
   
   ld l,d
   jp asm0_tshc_scroll_up
