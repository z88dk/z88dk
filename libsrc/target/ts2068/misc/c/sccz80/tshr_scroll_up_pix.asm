; void tshr_scroll_up_pix(uchar prows, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_scroll_up_pix

EXTERN asm0_tshr_scroll_up_pix

tshr_scroll_up_pix:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp asm0_tshr_scroll_up_pix

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshr_scroll_up_pix
defc _tshr_scroll_up_pix = tshr_scroll_up_pix
ENDIF

