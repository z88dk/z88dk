
; DRAW LOAD SPRITE 1 BYTE DEFINITION ROTATED, ON LEFT BORDER
; 01.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1Load1LBData
LIB SP1Load1NRData
XREF SP1RETSPRDRAW, SP1V_ROTTBL, SP1V_PIXELBUFFER

; following data segment copied into struct sp1_cs

.SP1Load1LBData

   ld hl,0
   nop
   ld de,0
   call SP1Load1LB

; following draw code called by way of SP1UpdateNow
;
;  a = hor rot table
; bc = graphic disp
; hl = graphic def ptr
; de = left graphic def ptr
;
; 32 + 33*8 - 6 + 10 = 300 cycles

.SP1Load1LB

   cp SP1V_ROTTBL/256
   jp z, SP1Load1NRData+10            ; SP1Load1NR

   add hl,bc
   ld d,a

   ;  d = shift table
   ; hl = sprite def (graph only)

.SP1Load1LBRotate

   ; 0

   ld e,(hl)
   inc hl
   ld a,(de)
   ld (SP1V_PIXELBUFFER+0),a

   ; 1

   ld e,(hl)
   inc hl
   ld a,(de)
   ld (SP1V_PIXELBUFFER+1),a

   ; 2

   ld e,(hl)
   inc hl
   ld a,(de)
   ld (SP1V_PIXELBUFFER+2),a

   ; 3

   ld e,(hl)
   inc hl
   ld a,(de)
   ld (SP1V_PIXELBUFFER+3),a

   ; 4

   ld e,(hl)
   inc hl
   ld a,(de)
   ld (SP1V_PIXELBUFFER+4),a

   ; 5

   ld e,(hl)
   inc hl
   ld a,(de)
   ld (SP1V_PIXELBUFFER+5),a

   ; 6

   ld e,(hl)
   inc hl
   ld a,(de)
   ld (SP1V_PIXELBUFFER+6),a

   ; 7

   ld e,(hl)
   ld a,(de)
   ld (SP1V_PIXELBUFFER+7),a

   jp SP1RETSPRDRAW
