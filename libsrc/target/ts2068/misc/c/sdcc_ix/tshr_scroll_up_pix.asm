; void tshr_scroll_up_pix(uchar prows, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_scroll_up_pix

EXTERN asm0_tshr_scroll_up_pix

_tshr_scroll_up_pix:

   pop af
   pop de
   
   push de
   push af
   
   ld l,d
   jp asm0_tshr_scroll_up_pix
