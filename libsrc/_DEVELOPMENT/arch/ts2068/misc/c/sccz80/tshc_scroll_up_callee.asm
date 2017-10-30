; void tshc_scroll_up(uchar prows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_scroll_up

EXTERN asm0_tshc_scroll_up

tshc_scroll_up:

   pop af
   pop hl
   pop de
   push af

   jp asm0_tshc_scroll_up
