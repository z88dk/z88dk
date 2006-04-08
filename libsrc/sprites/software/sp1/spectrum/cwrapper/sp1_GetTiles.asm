
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; void sp1_GetTiles(struct sp_Rect *r, struct sp1_tp *dest)

XLIB sp1_GetTiles
LIB SP1GetTiles

.sp1_GetTiles

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
   jp SP1GetTiles

; enter : hl = & struct sp1_tp[] destination array to store tile info
;          d = row coord
;          e = col coord
;          b = width
;          c = height
; uses  : af, bc, de, hl, af'
