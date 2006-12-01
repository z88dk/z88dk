
; C Wrapper
; 11.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; void sp1_IterateUpdateSpr(struct sp1_ss *s, void *hook)

XLIB sp1_IterateUpdateSpr
LIB SP1IterateUpdateSpr

.sp1_IterateUpdateSpr

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
   jp SP1IterateUpdateSpr

; enter : hl = & struct sp1_ss
;         ix = user function
; uses  : af, bc, hl + whatever user function uses

