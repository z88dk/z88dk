
; ===============================================================
; 2014
; ===============================================================
; 
; void zx_cls_wc_attr(struct r_Rect8 *r, uchar attr)
;
; Clear the rectangular area on screen.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_cls_wc_attr

EXTERN asm_zx_cxy2aaddr

asm_zx_cls_wc_attr:

   ; enter :  l = attr
   ;         ix = rect *
   ;
   ; uses  : af, bc, de, hl

   ld c,l                      ; save attribute

   ld l,(ix+0)                 ; l = rect.x
   ld h,(ix+2)                 ; h = rect.y
   
   call asm_zx_cxy2aaddr       ; hl = attr address

   ld a,c
   
   ; ix = rect *
   ; hl = attr address
   ;  a = attr

   ld b,0
   ld c,(ix+3)                 ; bc = rect.height

attr_loop:

   push bc

   ld c,(ix+1)                 ; bc = rect.width
   
   ld (hl),a
   
   dec c
   jr z, end_x
   
   push hl
   
   ld e,l
   ld d,h
   inc e
   
   ldir

   pop hl

end_x:

   ld c,32
   add hl,bc
   
   pop bc
   
   dec c
   jr nz, attr_loop

   ret
