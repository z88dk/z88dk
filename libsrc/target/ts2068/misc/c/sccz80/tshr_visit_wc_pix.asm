; void tshr_visit_wc_pix(struct r_Rect8 *r, void *function)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_visit_wc_pix

EXTERN asm_tshr_visit_wc_pix

tshr_visit_wc_pix:

   pop af
   pop de
   pop ix
   
   push de
   push de
   push af
   
   jp asm_tshr_visit_wc_pix

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshr_visit_wc_pix
defc _tshr_visit_wc_pix = tshr_visit_wc_pix
ENDIF

