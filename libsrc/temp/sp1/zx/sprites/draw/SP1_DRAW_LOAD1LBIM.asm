
; DRAW LOAD SPRITE 1 BYTE DEFINITION ROTATED, LEFT BORDER WITH IMPLIED MASK
; 04.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _SP1_DRAW_LOAD1LBIM

EXTERN _SP1_DRAW_LOAD1NR
EXTERN SP1RETSPRDRAW

; following data segment copied into struct sp1_cs

   ld hl,0
   nop
   ld de,0
   call _SP1_DRAW_LOAD1LBIM
   
; following draw code called by way of SP1UpdateNow
;
;  a = hor rot table
; bc = graphic disp
; hl = graphic def ptr
; de = left graphic def ptr
;
; 58 + 8*54 - 6 + 10 = 494 cycles

_SP1_DRAW_LOAD1LBIM:

   cp SP1V_ROTTBL/256
   jp z, _SP1_DRAW_LOAD1NR

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

_SP1Load1LBIMRotate:

   ; 0

   ld a,(de)
   inc de
   ld l,a
   ld a,(SP1V_PIXELBUFFER+0)
   and c
   or (hl)
   ld (SP1V_PIXELBUFFER+0),a

   ; 1

   ld a,(de)
   inc de
   ld l,a
   ld a,(SP1V_PIXELBUFFER+1)
   and c
   or (hl)
   ld (SP1V_PIXELBUFFER+1),a

   ; 2

   ld a,(de)
   inc de
   ld l,a
   ld a,(SP1V_PIXELBUFFER+2)
   and c
   or (hl)
   ld (SP1V_PIXELBUFFER+2),a

   ; 3

   ld a,(de)
   inc de
   ld l,a
   ld a,(SP1V_PIXELBUFFER+3)
   and c
   or (hl)
   ld (SP1V_PIXELBUFFER+3),a

   ; 4

   ld a,(de)
   inc de
   ld l,a
   ld a,(SP1V_PIXELBUFFER+4)
   and c
   or (hl)
   ld (SP1V_PIXELBUFFER+4),a

   ; 5

   ld a,(de)
   inc de
   ld l,a
   ld a,(SP1V_PIXELBUFFER+5)
   and c
   or (hl)
   ld (SP1V_PIXELBUFFER+5),a

   ; 6

   ld a,(de)
   inc de
   ld l,a
   ld a,(SP1V_PIXELBUFFER+6)
   and c
   or (hl)
   ld (SP1V_PIXELBUFFER+6),a

   ; 7

   ld a,(de)
   ld l,a
   ld a,(SP1V_PIXELBUFFER+7)
   and c
   or (hl)
   ld (SP1V_PIXELBUFFER+7),a

   jp SP1RETSPRDRAW
