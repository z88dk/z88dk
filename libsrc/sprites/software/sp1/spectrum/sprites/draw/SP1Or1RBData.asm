
; DRAW OR SPRITE 1 BYTE DEFINITION ROTATED, ON RIGHT BORDER
; 01.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1Or1RBData
LIB SP1Or1LBData
XREF SP1RETSPRDRAW, SP1V_ROTTBL, SP1V_PIXELBUFFER

; following data segment copied into struct sp1_cs

.SP1Or1RBData

   ld de,0
   nop
   ld hl,0
   call SP1Or1RB

; following draw code called by way of SP1UpdateNow
;
;  a = hor rot table
; bc = graphic disp
; de = graphic def ptr
; hl = left graphic def ptr
;
; 42 + 94*4 - 6 + 10 = 422 cycles

.SP1Or1RB

   cp SP1V_ROTTBL/256
   jp z, SP1RETSPRDRAW

   add hl,bc
   ld d,a
   inc d

   ;  d = shift table
   ; hl = left sprite def (graph only)

.SP1Or1RBRotate

   jp SP1Or1LBData+17       ; SP1Or1LBRotate
