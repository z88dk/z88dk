
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; void *sp1_PreShiftSpr(struct sp1_ss *s, uchar rshift, void *destaddr)

XLIB sp1_PreShiftSpr
LIB SP1PreShiftSpr

.sp1_PreShiftSpr

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld iyl,e
   ld iyh,d
   ld a,(hl)
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   ld ixl,e
   ld ixh,d
   call SP1PreShiftSpr
   push iy
   pop hl
   ret

; enter : ix = & struct sp1_ss
;         iy = destination frame address
;          a = right shift amount (will be mod 8 here)
; exit  : iy = next free address after new frame


