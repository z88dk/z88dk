
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; void *sp1_TileEntry(uchar c, uchar *def)

XLIB sp1_TileEntry
LIB SP1TileEntry

.sp1_TileEntry

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld c,(hl)
   call SP1TileEntry
   ex de,hl
   ret

; enter : de = address of udg graphic to associate with character code
;          c = char code
; exit  : de = old udg graphic associated with char code

