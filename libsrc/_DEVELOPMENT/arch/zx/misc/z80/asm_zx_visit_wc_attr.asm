; ===============================================================
; 2017
; ===============================================================
; 
; void zx_visit_wc_attr(struct r_Rect8 *r, void *function)
;
; Iterate over the attribute squares defined by the rectangle
; in left to right, top to bottom order and call the function
; for each square visited.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_visit_wc_attr

EXTERN l_jphl, asm_zx_cxy2aaddr

asm_zx_visit_wc_attr:

   ; enter : ix = struct r_Rect8 *r
   ;         de = void (*function)(unsigned char *aaddr)
   ;
   ; uses  : af, bc, de, hl, +user function
   
   ld h,(ix+2)                 ; h = rect.y
   ld l,(ix+0)                 ; l = rect.x
   
   call asm_zx_cxy2aaddr       ; hl = attribute address
   
   ld c,(ix+3)                 ; c = rect.height
   ld b,(ix+1)                 ; b = rect.width
   
loop:

   ; visit
   
   push ix
   push bc
   push de
   push hl
   
   push hl
   ex de,hl
   call l_jphl                 ; de = unsigned char *aaddr
   pop hl
   
   pop hl
   pop de
   pop bc
   pop ix
   
   inc l
   djnz loop
   
   dec c
   ret z
   
   ld b,(ix+1)                 ; b = rect.width
   
   ld a,32
   sub b
   
   add a,l
   ld l,a
   adc a,h
   sub l
   ld h,a
   
   jp loop
