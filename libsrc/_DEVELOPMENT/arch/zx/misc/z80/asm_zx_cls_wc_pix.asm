
; ===============================================================
; 2014
; ===============================================================
; 
; void zx_cls_wc_pix(struct r_Rect8 *r, uchar pix)
;
; Clear the rectangular area on screen.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_cls_wc_pix
PUBLIC asm0_zx_cls_wc_pix

EXTERN asm_zx_cxy2saddr
EXTERN asm0_zx_saddrpdown

asm_zx_cls_wc_pix:

   ; enter :  l = screen byte
   ;         ix = rect *
   ;
   ; uses  : af, bc, de, hl

   ld c,l                      ; save screen byte

   ld l,(ix+0)                 ; l = rect.x
   ld h,(ix+2)                 ; h = rect.y
   
   call asm_zx_cxy2saddr       ; hl = screen address

asm0_zx_cls_wc_pix:

   ld a,c
   
   ; ix = rect *
   ; hl = screen address
   ;  a = screen byte

   ld c,(ix+3)                 ; bc = rect.height

pixel_loop_0:

   ld b,8

pixel_loop_1:

   push bc

   ld c,(ix+1)                 ; bc = rect.width
   
   ld (hl),a
   
   dec c
   jr z, end_x
   
   push hl
   
   ld e,l
   ld d,h
   inc e
   
   ld b,0
   ldir

   pop hl

end_x:

   inc h
   
   pop bc
   djnz pixel_loop_1
   
   ld e,a
   call asm0_zx_saddrpdown
   ld a,e
   
   dec c
   jr nz, pixel_loop_0

   ret
