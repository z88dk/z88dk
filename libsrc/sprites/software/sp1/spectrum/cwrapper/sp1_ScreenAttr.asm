
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; uchar sp1_ScreenAttr(uchar row, uchar col)

XLIB sp1_ScreenAttr
LIB SP1ScreenAttr

.sp1_ScreenAttr

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   call SP1ScreenAttr
   ld l,e
   ld h,0
   ret

; enter : d = row coord
;         e = col coord
; exit  : e = attr
; uses  : af, de, hl

