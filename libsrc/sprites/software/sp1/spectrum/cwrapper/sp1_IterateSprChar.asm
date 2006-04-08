
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; void sp1_IterateSprChar(struct sp1_ss *s, void *hook)

XLIB sp1_IterateSprChar
LIB SP1IterateSprChar

.sp1_IterateSprChar

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld ixl,e
   ld ixh,d
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   jp SP1IterateSprChar

; enter : hl = & struct sp1_ss
;         ix = user function
; uses  : af, bc, hl + whatever user function uses

