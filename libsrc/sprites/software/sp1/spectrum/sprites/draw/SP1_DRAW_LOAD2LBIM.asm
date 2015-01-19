
; DRAW LOAD SPRITE 2 BYTE DEFINITION ROTATED, LEFT BORDER WITH IMPLIED MASK
; 04.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC SP1_DRAW_LOAD2LBIM
EXTERN SP1_DRAW_LOAD2NR
EXTERN SP1RETSPRDRAW, SP1V_ROTTBL, SP1V_PIXELBUFFER

; following data segment copied into struct sp1_cs

   ld hl,0
   nop
   ld de,0
   call SP1_DRAW_LOAD2LBIM
   
; following draw code called by way of SP1UpdateNow
;
;  a = hor rot table
; bc = graphic disp
; hl = graphic def ptr (mask,graph) pairs
; de = left graphic def ptr
;
; 58 + 8*60 - 6 + 10 = 542 cycles

.SP1_DRAW_LOAD2LBIM

   cp SP1V_ROTTBL/256
   jp z, SP1_DRAW_LOAD2NR

   add hl,bc
   ex de,hl
   ld h,a
   ld l,$ff
   ld a,(hl)
   cpl
   ld c,a
   
   ;  h = shift table
   ;  c = constant mask
   ; de = sprite def (graph only)

.SP1Load1LBIMRotate

   ; 0

   inc de
   ld a,(de)
   inc de
   ld l,a
   ld a,(SP1V_PIXELBUFFER+0)
   and c
   or (hl)
   ld (SP1V_PIXELBUFFER+0),a

   ; 1

   inc de
   ld a,(de)
   inc de
   ld l,a
   ld a,(SP1V_PIXELBUFFER+1)
   and c
   or (hl)
   ld (SP1V_PIXELBUFFER+1),a

   ; 2

   inc de
   ld a,(de)
   inc de
   ld l,a
   ld a,(SP1V_PIXELBUFFER+2)
   and c
   or (hl)
   ld (SP1V_PIXELBUFFER+2),a

   ; 3

   inc de
   ld a,(de)
   inc de
   ld l,a
   ld a,(SP1V_PIXELBUFFER+3)
   and c
   or (hl)
   ld (SP1V_PIXELBUFFER+3),a

   ; 4

   inc de
   ld a,(de)
   inc de
   ld l,a
   ld a,(SP1V_PIXELBUFFER+4)
   and c
   or (hl)
   ld (SP1V_PIXELBUFFER+4),a

   ; 5

   inc de
   ld a,(de)
   inc de
   ld l,a
   ld a,(SP1V_PIXELBUFFER+5)
   and c
   or (hl)
   ld (SP1V_PIXELBUFFER+5),a

   ; 6

   inc de
   ld a,(de)
   inc de
   ld l,a
   ld a,(SP1V_PIXELBUFFER+6)
   and c
   or (hl)
   ld (SP1V_PIXELBUFFER+6),a

   ; 7

   inc de
   ld a,(de)
   ld l,a
   ld a,(SP1V_PIXELBUFFER+7)
   and c
   or (hl)
   ld (SP1V_PIXELBUFFER+7),a

   jp SP1RETSPRDRAW
