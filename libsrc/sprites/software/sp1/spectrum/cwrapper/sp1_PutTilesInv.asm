
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; void sp1_PutTilesInv(struct sp_Rect *r, struct sp1_tp *src)

XLIB sp1_PutTilesInv
LIB SP1PutTilesInv

.sp1_PutTilesInv

   ld hl,5
   add hl,sp
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   push hl
   ex de,hl
   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   pop hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a
   jp SP1PutTilesInv

; enter : hl = struct sp1_tp[] array of attr/tile pairs
;          d = row coord
;          e = col coord
;          b = width
;          c = height
; uses  : af, bc, de, hl, af', ix
