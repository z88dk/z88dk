
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; uint sp1_Screen(uchar row, uchar col)

XLIB sp1_Screen
LIB SP1Screen

.sp1_Screen

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   call SP1Screen
   ex de,hl
   ret

; enter : d = row coord
;         e = col coord
; exit  : d = attr
;         e = tile

