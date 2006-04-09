
; DRAW OR SPRITE 2 BYTE DEFINITION ROTATED, ON RIGHT BORDER
; 01.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1Or2RBData
LIB SP1Or2LBData
XREF SP1RETSPRDRAW, SP1V_ROTTBL, SP1V_PIXELBUFFER

; following data segment copied into struct sp1_cs

.SP1Or2RBData

   ld de,0
   nop
   ld hl,0
   call SP1Or2RB

; following draw code called by way of SP1UpdateNow
;
;  a = hor rot table
; bc = graphic disp
; de = graphic def ptr (mask,graph) pairs
; hl = left graphic def ptr
;
; 46 + 106*4 - 6 + 10 = 474 cycles

.SP1Or2RB

   cp SP1V_ROTTBL/256
   jp z, SP1RETSPRDRAW

   add hl,bc
   ld d,a
   inc d

   ;  d = shift table
   ; hl = left sprite def (mask,graph) pairs

.SP1Or2RBRotate

   jp SP1Or2LBData+17       ; SP1Or2LBRotate
   