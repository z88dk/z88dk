; ===============================================================
; 2017
; ===============================================================
; 
; void tshr_cls_wc(struct r_Rect8 *r, uchar ink)
;
; Clear the rectangular area on screen.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_cls_wc

EXTERN asm_tshr_color
EXTERN asm_tshr_cxy2saddr, asm0_tshr_saddrpdown

asm_tshr_cls_wc:

   ; enter :  l = attr
   ;         ix = rect *
   ;
   ; uses  : af, bc, de, hl

   ld a,l
   cp 8
   call c, asm_tshr_color

   ld l,(ix+0)                 ; l = rect.x
   ld h,(ix+2)                 ; h = rect.y
   
   call asm_tshr_cxy2saddr     ; hl = screen address

   ; ix = rect *
   ; hl = screen address

   ld c,(ix+3)                 ; c = rect.height

pixel_loop_0:

   ld b,8

pixel_loop_1:

   push bc
   push hl
   
   ld b,(ix+1)                 ; b = rect.width
   ld c,0

   bit 5,h
   jr nz, pixel_loop_odd

pixel_loop_even:

   ld (hl),c                   ; clear pixels
   
   dec b
   jr z, pixel_loop_end

   set 5,h
   
pixel_loop_odd:

   ld (hl),c                   ; clear pixels
   
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
