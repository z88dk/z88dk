
; DRAW XOR SPRITE 2 BYTE DEFINITION ROTATED, ON RIGHT BORDER
; 01.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC SP1_DRAW_XOR2RB
EXTERN SP1_DRAW_XOR2LB
EXTERN SP1RETSPRDRAW, SP1V_ROTTBL, SP1V_PIXELBUFFER

; following data segment copied into struct sp1_cs

   ld de,0
   nop
   ld hl,0
   call SP1_DRAW_XOR2RB

; following draw code called by way of SP1UpdateNow
;
;  a = hor rot table
; bc = graphic disp
; de = graphic def ptr (mask,graph) pairs
; hl = left graphic def ptr
;
; 46 + 106*4 - 6 + 10 = 474 cycles

.SP1_DRAW_XOR2RB

   cp SP1V_ROTTBL/256
   jp z, SP1RETSPRDRAW

   add hl,bc
   ld d,a
   inc d

   ;  d = shift table
   ; hl = left sprite def (mask,graph) pairs

.SP1Xor2RBRotate

   jp SP1_DRAW_XOR2LB + 7
