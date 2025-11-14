; ===============================================================
; 2017
; ===============================================================
; 
; void tshc_visit_wc_pix(struct r_Rect8 *r, void *function)
;
; Iterate over the character squares defined by the rectangle
; in left to right, top to bottom order and call the function
; for each square visited.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_visit_wc_pix

EXTERN asm_zx_visit_wc_pix

defc asm_tshc_visit_wc_pix = asm_zx_visit_wc_pix

   ; enter : ix = struct r_Rect8 *r
   ;         de = void (*function)(unsigned char *saddr)
   ;
   ; uses  : af, bc, de, hl, +user function
