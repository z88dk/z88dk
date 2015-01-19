
; DRAW MASK SPRITE 2 BYTE DEFINITION NO ROTATION
; 01.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC SP1_DRAW_MASK2NR
EXTERN SP1RETSPRDRAW, SP1V_PIXELBUFFER

; following data segment copied into struct sp1_cs

   ld hl,0
   nop
   ld de,0
   call SP1_DRAW_MASK2NR

; following draw code called by way of SP1UpdateNow
;
;  a = hor rot table
; bc = graphic disp
; hl = graphic def ptr
; de = left graphic def ptr
;
; 11 + 106*4 - 6 + 10 = 439 cycles

.SP1_DRAW_MASK2NR

   add hl,bc

   ; hl = sprite def = (mask,graph) pairs

   ; 0

   ld de,(SP1V_PIXELBUFFER+0)
   ld a,(hl)
   and e
   inc hl
   or (hl)
   inc hl
   ld (SP1V_PIXELBUFFER+0),a
   ld a,(hl)
   and d
   inc hl
   or (hl)
   inc hl
   ld (SP1V_PIXELBUFFER+1),a

   ; 1

   ld de,(SP1V_PIXELBUFFER+2)
   ld a,(hl)
   and e
   inc hl
   or (hl)
   inc hl
   ld (SP1V_PIXELBUFFER+2),a
   ld a,(hl)
   and d
   inc hl
   or (hl)
   inc hl
   ld (SP1V_PIXELBUFFER+3),a

   ; 2

   ld de,(SP1V_PIXELBUFFER+4)
   ld a,(hl)
   and e
   inc hl
   or (hl)
   inc hl
   ld (SP1V_PIXELBUFFER+4),a
   ld a,(hl)
   and d
   inc hl
   or (hl)
   inc hl
   ld (SP1V_PIXELBUFFER+5),a

   ; 3

   ld de,(SP1V_PIXELBUFFER+6)
   ld a,(hl)
   and e
   inc hl
   or (hl)
   inc hl
   ld (SP1V_PIXELBUFFER+6),a
   ld a,(hl)
   and d
   inc hl
   or (hl)
   ld (SP1V_PIXELBUFFER+7),a

   jp SP1RETSPRDRAW
