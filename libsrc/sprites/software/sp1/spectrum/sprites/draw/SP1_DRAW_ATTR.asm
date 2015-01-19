
; DRAW ATTR ONLY SPRITE (NO PIXELS)
; 04.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC SP1_DRAW_ATTR
EXTERN SP1RETSPRDRAW

; following data segment copied into struct sp1_cs

   ld hl,0
   nop
   ld de,0
   call SP1RETSPRDRAW

.SP1_DRAW_ATTR

; yes that's it
