; void tshr_scroll_wc_up_pix(struct r_Rect8 *r, uchar rows, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_scroll_wc_up_pix

EXTERN asm0_tshr_scroll_wc_up_pix

tshr_scroll_wc_up_pix:

   pop af
   pop hl
   pop de
   pop ix
   
   push de
   push de
   push hl
   push af

   jp asm0_tshr_scroll_wc_up_pix

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshr_scroll_wc_up_pix
defc _tshr_scroll_wc_up_pix = tshr_scroll_wc_up_pix
ENDIF

