
; DRAW LOAD SPRITE 2 BYTE DEFINITION ROTATED, ON LEFT BORDER
; 01.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _SP1_DRAW_LOAD2LB

EXTERN _SP1_DRAW_LOAD2NR
EXTERN SP1RETSPRDRAW

; following data segment copied into struct sp1_cs

   ld hl,0
   nop
   ld de,0
   call _SP1_DRAW_LOAD2LB

; following draw code called by way of SP1UpdateNow
;
;  a = hor rot table
; bc = graphic disp
; hl = graphic def ptr (mask,graph) pairs
; de = left graphic def ptr
;
; 32 + 39*8 - 6 + 10 = 348 cycles

_SP1_DRAW_LOAD2LB:

   cp SP1V_ROTTBL/256
   jp z, _SP1_DRAW_LOAD2NR

   add hl,bc
   ld d,a

   ;  d = shift table
   ; hl = sprite def (graph only)

_SP1Load2LBRotate:

   ; 0

   inc hl
   ld e,(hl)
   inc hl
   ld a,(de)
   ld (SP1V_PIXELBUFFER+0),a

   ; 1

   inc hl
   ld e,(hl)
   inc hl
   ld a,(de)
   ld (SP1V_PIXELBUFFER+1),a

   ; 2

   inc hl
   ld e,(hl)
   inc hl
   ld a,(de)
   ld (SP1V_PIXELBUFFER+2),a

   ; 3

   inc hl
   ld e,(hl)
   inc hl
   ld a,(de)
   ld (SP1V_PIXELBUFFER+3),a

   ; 4

   inc hl
   ld e,(hl)
   inc hl
   ld a,(de)
   ld (SP1V_PIXELBUFFER+4),a

   ; 5

   inc hl
   ld e,(hl)
   inc hl
   ld a,(de)
   ld (SP1V_PIXELBUFFER+5),a

   ; 6

   inc hl
   ld e,(hl)
   inc hl
   ld a,(de)
   ld (SP1V_PIXELBUFFER+6),a

   ; 7

   inc hl
   ld e,(hl)
   ld a,(de)
   ld (SP1V_PIXELBUFFER+7),a

   jp SP1RETSPRDRAW
