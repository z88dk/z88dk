; void tshr_scroll_up_pix(uchar prows, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_scroll_up_pix_callee

EXTERN asm0_tshr_scroll_up_pix

_tshr_scroll_up_pix_callee:

   pop hl
   ex (sp),hl
   
   ld e,l
   ld l,h
   jp asm0_tshr_scroll_up_pix
