
; DRAW ATTR ONLY SPRITE (NO PIXELS)
; 04.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1AttrOnlyData
XREF SP1RETSPRDRAW

; following data segment copied into struct sp1_cs

.SP1AttrOnlyData

   ld hl,0
   nop
   ld de,0
   call SP1RETSPRDRAW

; yes that's it
