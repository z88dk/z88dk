
; DRAW MASK SPRITE 2 BYTE DEFINITION ROTATED, ON LEFT BORDER
; 01.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC SP1_DRAW_MASK2LB
EXTERN SP1_DRAW_MASK2NR
EXTERN SP1RETSPRDRAW, SP1V_ROTTBL, SP1V_PIXELBUFFER

; following data segment copied into struct sp1_cs

   ld hl,0
   nop
   ld de,0
   call SP1_DRAW_MASK2LB

; following draw code called by way of SP1UpdateNow
;
;  a = hor rot table
; bc = graphic disp
; hl = graphic def ptr
; de = left graphic def ptr
;
; 62 + 174*4 - 6 + 10 = 762 cycles

.SP1_DRAW_MASK2LB

   cp SP1V_ROTTBL/256
   jp z, SP1_DRAW_MASK2NR

   add hl,bc
   ld d,a

   ;  d = shift table
   ; hl = sprite def (mask,graph) pairs
   
   ld e,$ff
   ld a,(de)
   cpl
   exx
   ld b,a
   exx

.SP1Mask2LBRotate

   ; 0

   ld bc,(SP1V_PIXELBUFFER+0)
   ld e,(hl)
   inc hl
   ld a,(de)
   exx
   or b
   exx
   and c
   ld c,a
   ld e,(hl)
   inc hl
   ld a,(de)
   or c
   ld (SP1V_PIXELBUFFER+0),a
   ld e,(hl)
   inc hl
   ld a,(de)
   exx
   or b
   exx
   and b
   ld b,a
   ld e,(hl)
   inc hl
   ld a,(de)
   or b
   ld (SP1V_PIXELBUFFER+1),a

   ; 1

   ld bc,(SP1V_PIXELBUFFER+2)
   ld e,(hl)
   inc hl
   ld a,(de)
   exx
   or b
   exx
   and c
   ld c,a
   ld e,(hl)
   inc hl
   ld a,(de)
   or c
   ld (SP1V_PIXELBUFFER+2),a
   ld e,(hl)
   inc hl
   ld a,(de)
   exx
   or b
   exx
   and b
   ld b,a
   ld e,(hl)
   inc hl
   ld a,(de)
   or b
   ld (SP1V_PIXELBUFFER+3),a

   ; 2

   ld bc,(SP1V_PIXELBUFFER+4)
   ld e,(hl)
   inc hl
   ld a,(de)
   exx
   or b
   exx
   and c
   ld c,a
   ld e,(hl)
   inc hl
   ld a,(de)
   or c
   ld (SP1V_PIXELBUFFER+4),a
   ld e,(hl)
   inc hl
   ld a,(de)
   exx
   or b
   exx
   and b
   ld b,a
   ld e,(hl)
   inc hl
   ld a,(de)
   or b
   ld (SP1V_PIXELBUFFER+5),a

   ; 3

   ld bc,(SP1V_PIXELBUFFER+6)
   ld e,(hl)
   inc hl
   ld a,(de)
   exx
   or b
   exx
   and c
   ld c,a
   ld e,(hl)
   inc hl
   ld a,(de)
   or c
   ld (SP1V_PIXELBUFFER+6),a
   ld e,(hl)
   inc hl
   ld a,(de)
   exx
   or b
   exx
   and b
   ld b,a
   ld e,(hl)
   ld a,(de)
   or b
   ld (SP1V_PIXELBUFFER+7),a

   jp SP1RETSPRDRAW
