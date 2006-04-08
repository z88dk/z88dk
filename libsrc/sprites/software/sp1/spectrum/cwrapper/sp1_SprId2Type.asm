
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; uchar __FASTCALL__ sp1_SprId2Type(uchar id)

XLIB sp1_SprId2Type
LIB SP1SprId2Type

.sp1_SprId2Type

   ld e,l
   call SP1SprId2Type
   ld h,0
   ld l,a
   ret

; enter : e = sprite id
; exit  : a = sprite type
; used  : af, hl
