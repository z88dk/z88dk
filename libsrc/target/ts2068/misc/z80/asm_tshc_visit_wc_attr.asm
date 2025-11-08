; ===============================================================
; 2017
; ===============================================================
; 
; void tshc_visit_wc_attr(struct r_Rect8 *r, void *function)
;
; Iterate over the character squares defined by the rectangle
; in left to right, top to bottom order and call the function
; for each square visited.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_visit_wc_attr

EXTERN asm_tshc_cxy2aaddr, asm0_zx_visit_wc_pix

asm_tshc_visit_wc_attr:

   ; enter : ix = struct r_Rect8 *r
   ;         de = void (*function)(unsigned char *saddr)
   ;
   ; uses  : af, bc, de, hl, +user function
   
   ld h,(ix+2)                 ; h = rect.y
   ld l,(ix+0)                 ; l = rect.x
   
   call asm_tshc_cxy2aaddr     ; hl = attr address

   jp asm0_zx_visit_wc_pix
