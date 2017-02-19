
; DRAW XOR SPRITE 1 BYTE DEFINITION ROTATED, ON RIGHT BORDER
; 01.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _SP1_DRAW_XOR1RB

EXTERN _SP1_DRAW_XOR1LB
EXTERN SP1RETSPRDRAW

; following data segment copied into struct sp1_cs

   ld de,0
   nop
   ld hl,0
   call _SP1_DRAW_XOR1RB

; following draw code called by way of SP1UpdateNow
;
;  a = hor rot table
; bc = graphic disp
; de = graphic def ptr
; hl = left graphic def ptr
;
; 42 + 94*4 - 6 + 10 = 422 cycles

_SP1_DRAW_XOR1RB:

   cp SP1V_ROTTBL/256
   jp z, SP1RETSPRDRAW

   add hl,bc
   ld d,a
   inc d

   ;  d = shift table
   ; hl = left sprite def (graph only)

_SP1Xor1RBRotate:

   jp _SP1_DRAW_XOR1LB + 7
