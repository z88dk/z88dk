; void tshc_scroll_up(uchar prows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_scroll_up

EXTERN asm0_tshc_scroll_up

_tshc_scroll_up:

   pop hl
   ex (sp),hl
   
   ld e,l
   ld l,h
   jp asm0_tshc_scroll_up
