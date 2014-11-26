
; DRAW XOR SPRITE 1 BYTE DEFINITION ROTATED, ON RIGHT BORDER
; 01.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

INCLUDE "clib_target_cfg.asm"

SECTION seg_code_sp1

PUBLIC SP1_DRAW_XOR1RB

EXTERN SP1_DRAW_XOR1LB
EXTERN SP1RETSPRDRAW

; following data segment copied into struct sp1_cs

   ld de,0
   nop
   ld hl,0
   call SP1_DRAW_XOR1RB

; following draw code called by way of SP1UpdateNow
;
;  a = hor rot table
; bc = graphic disp
; de = graphic def ptr
; hl = left graphic def ptr
;
; 42 + 94*4 - 6 + 10 = 422 cycles

.SP1_DRAW_XOR1RB

   cp SP1V_ROTTBL/256
   jp z, SP1RETSPRDRAW

   add hl,bc
   ld d,a
   inc d

   ;  d = shift table
   ; hl = left sprite def (graph only)

.SP1Xor1RBRotate

   jp SP1_DRAW_XOR1LB + 7
