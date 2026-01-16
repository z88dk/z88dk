
; DRAW LOAD SPRITE 2 BYTE DEFINITION ROTATED, RIGHT BORDER WITH IMPLIED MASK
; 04.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _SP1_DRAW_LOAD2RBIM

EXTERN _SP1_DRAW_LOAD2LBIM
EXTERN SP1RETSPRDRAW

; following data segment copied into struct sp1_cs

   ld de,0
   nop
   ld hl,0
   call _SP1_DRAW_LOAD2RBIM
   
; following draw code called by way of SP1UpdateNow
;
;  a = hor rot table
; bc = graphic disp
; de = graphic def ptr
; hl = left graphic def ptr
;
; 64 + 8*54 - 6 + 10 = 500 cycles

_SP1_DRAW_LOAD2RBIM:

   cp SP1V_ROTTBL/256
   jp z, SP1RETSPRDRAW

   add hl,bc
   ex de,hl
   ld h,a
   ld l,$ff
   ld c,(hl)
   inc h
   
   ;  h = shift table
   ;  c = constant mask
   ; de = sprite def (graph only)

_SP1Load2RBIMRotate:

   jp _SP1_DRAW_LOAD2LBIM + 13
