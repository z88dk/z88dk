; ===============================================================
; 2017
; ===============================================================
; 
; void tshr_cls_wc_pix(struct r_Rect8 *r, uchar pix)
;
; Clear the rectangular area on screen.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_cls_wc_pix

EXTERN asm_tshr_cxy2saddr, asm0_tshr_saddrpdown

asm_tshr_cls_wc_pix:

   ; enter :  l = pix
   ;         ix = rect *
   ;
   ; uses  : af, bc, de, hl

   ; ldir method is more complex but appears to be faster at widths > 17
   ; investigate later

   ld c,l                      ; c = pix

   ld l,(ix+0)                 ; l = rect.x
   ld h,(ix+2)                 ; h = rect.y
   
   call asm_tshr_cxy2saddr     ; hl = screen address

   ; ix = rect *
   ; hl = screen address

   ld e,c                      ; e = pix
   ld c,(ix+3)                 ; c = rect.height

pixel_loop_0:

   ld b,8

pixel_loop_1:

   push bc
   push hl
   
   ld b,(ix+1)                 ; b = rect.width

   bit 5,h
   jr nz, pixel_loop_odd

pixel_loop_even:

   ld (hl),e                   ; clear pixels
   
   dec b
   jr z, pixel_loop_end

   set 5,h
   
pixel_loop_odd:

   ld (hl),e                   ; clear pixels
   
   res 5,h
   inc l
   
   djnz pixel_loop_even
   
pixel_loop_end:

   pop hl
   inc h

   pop bc
   djnz pixel_loop_1

   call asm0_tshr_saddrpdown
   
   dec c
   jr nz, pixel_loop_0

   ret
