; 04.2006 aralbrec

; void *scr_pixelright(void *scrnaddr, uchar *mask)

XLIB scr_pixelright
LIB SCRpixelright

.scr_pixelright

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ld a,(de)
   ld b,a
   call SCRpixelright
   ld a,b
   ld (de),a
   ret

; Adjusts screen address HL and pixel mask B to move right
; one pixel on screen.
;
; enter: HL = valid screen address
;         B = pixel mask for screen byte
; exit : Carry = moved off screen
;        HL, B moved right one pixel
; used : AF, HL
