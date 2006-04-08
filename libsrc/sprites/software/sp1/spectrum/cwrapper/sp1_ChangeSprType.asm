
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; void sp1_ChangeSprType(struct sp1_cs *c, uchar type)

XLIB sp1_ChangeSprType
LIB SP1ChangeSprType

.sp1_ChangeSprType

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   jp SP1ChangeSprType

; enter : hl = struct sp1_cs *
;          e = new type (bit 7 = 1 if sprite should occlude, bits 4:0 draw type id, zero elsewhere)
; uses  : af, bc, de, hl

