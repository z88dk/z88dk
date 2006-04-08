
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; uchar sp1_ScreenStr(uchar row, uchar col)

XLIB sp1_ScreenStr
LIB SP1ScreenStr

.sp1_ScreenStr

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   call SP1ScreenStr
   ld l,e
   ld h,0
   ret

; enter : d = row coord
;         e = col coord
; exit  : e = tile
; uses  : af, de, hl

