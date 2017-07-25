; ===============================================================
; 2017
; ===============================================================
; 
; void zx_visit_wc_pix(struct r_Rect8 *r, void *function)
;
; Iterate over the character squares defined by the rectangle
; in left to right, top to bottom order and call the function
; for each square visited.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_visit_wc_pix

EXTERN l_jphl, asm_zx_cxy2saddr, asm_zx_saddrcdown

asm_zx_visit_wc_pix:

   ; enter : ix = struct r_Rect8 *r
   ;         de = void (*function)(unsigned char *saddr)
   ;
   ; uses  : af, bc, de, hl, +user function
   
   ld h,(ix+2)                 ; h = rect.y
   ld l,(ix+0)                 ; l = rect.x
   
   call asm_zx_cxy2saddr       ; hl = screen address
   
   ld c,(ix+3)                 ; c = rect.height

loop_y:

   ld b,(ix+1)                 ; b = rect.width
   push hl                     ; save screen address

loop_x:

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
   djnz loop_x
   
   pop hl                      ; hl = screen address at left side
   
   dec c
   ret z

   call asm_zx_saddrcdown
   
   jp loop_y
