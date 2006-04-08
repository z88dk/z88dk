
; SP1TileEntry
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1TileEntry
XREF SP1V_TileArray

; Associate a new graphic with character code passed in.
;
; enter : de = address of udg graphic to associate with character code
;          c = char code
; exit  : de = old udg graphic associated with char code
; uses  : af, b, de, hl


.SP1TileEntry

   ld hl,SP1V_TileArray
   ld b,0
   add hl,bc
   ld a,(hl)
   ld (hl),e
   ld e,a
   inc h
   ld a,(hl)
   ld (hl),d
   ld d,a

   ret
