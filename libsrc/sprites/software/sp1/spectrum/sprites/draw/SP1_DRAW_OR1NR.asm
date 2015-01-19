
; DRAW OR SPRITE 1 BYTE DEFINITION NO ROTATION
; 01.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC SP1_DRAW_OR1NR
EXTERN SP1RETSPRDRAW, SP1V_PIXELBUFFER

; following data segment copied into struct sp1_cs

   ld hl,0
   nop
   ld de,0
   call SP1_DRAW_OR1NR

; following draw code called by way of SP1UpdateNow
;
;  a = hor rot table
; bc = graphic disp
; hl = graphic def ptr
; de = left graphic def ptr
;
; 21 + 33*8 - 12 + 10 = 283 cycles

.SP1_DRAW_OR1NR

   add hl,bc
   ld de,SP1V_PIXELBUFFER

   ; hl = sprite def (graph only)
   ; de = pixel buffer

   ; 0

   ld a,(de)
   or (hl)
   ld (de),a
   inc de
   inc hl

   ; 1

   ld a,(de)
   or (hl)
   ld (de),a
   inc de
   inc hl

   ; 2

   ld a,(de)
   or (hl)
   ld (de),a
   inc de
   inc hl

   ; 3

   ld a,(de)
   or (hl)
   ld (de),a
   inc de
   inc hl

   ; 4

   ld a,(de)
   or (hl)
   ld (de),a
   inc de
   inc hl

   ; 5

   ld a,(de)
   or (hl)
   ld (de),a
   inc de
   inc hl

   ; 6

   ld a,(de)
   or (hl)
   ld (de),a
   inc de
   inc hl

   ; 7

   ld a,(de)
   or (hl)
   ld (de),a

   jp SP1RETSPRDRAW
