
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; void __FASTCALL__ sp1_Validate(struct sp_Rect *r)

XLIB sp1_Validate
LIB SP1Validate

.sp1_Validate

   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   jp SP1Validate

; enter : d = row coord
;         e = col coord
;         b = width
;         c = height
; uses  : af, bc, de, hl
