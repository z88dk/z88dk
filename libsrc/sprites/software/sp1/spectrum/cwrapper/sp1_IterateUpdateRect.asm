
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; void sp1_IterateUpdateRect(struct sp_Rect *r, void *hook)

XLIB sp1_IterateUpdateRect
LIB SP1IterateUpdateRect

.sp1_IterateUpdateRect

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
   ld ixl,e
   ld ixh,d
   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   jp SP1IterateUpdateRect

; enter : d = row coord
;         e = col coord
;         b = width
;         c = height
;        ix = void (*func)(struct sp1_update*), hl also holds parameter
; uses  : af, bc, de, hl  (de can be used by user function to hold state between calls)

