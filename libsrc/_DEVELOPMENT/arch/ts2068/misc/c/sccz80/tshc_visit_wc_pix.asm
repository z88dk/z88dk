; void tshc_visit_wc_pix(struct r_Rect8 *r, void *function)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_visit_wc_pix

EXTERN asm_zx_visit_wc_pix

tshc_visit_wc_pix:

   pop af
   pop de
   pop ix
   
   push de
   push de
   push af
   
   jp asm_zx_visit_wc_pix

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_visit_wc_pix
defc _tshc_visit_wc_pix = tshc_visit_wc_pix
ENDIF

