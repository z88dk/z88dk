
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; void *sp1_PreShiftSpr(uchar flag, uchar height, uchar width, void *srcframe, void *destframe, uchar rshift)

XLIB sp1_PreShiftSpr
LIB SP1PreShiftSpr

.sp1_PreShiftSpr

   ld hl,2
   add hl,sp
   ld a,(hl)
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld iyl,e
   ld iyh,d
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld b,(hl)
   inc hl
   inc hl
   ld c,(hl)
   inc hl
   inc hl
   ld h,(hl)
   ld l,c
   call SP1PreShiftSpr
   ld e,iyl
   ld d,iyh
   ex de,hl
   ret

; enter :  a = right shift amount (0-7)
;          b = width in characters (# columns)
;          h = zero for 1-byte definition; otherwise 2-byte
;         de = source frame graphic
;         iy = destination frame address
;          l = height in characters
; exit  : iy = next available address
