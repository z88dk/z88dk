
; DRAW XOR SPRITE 1 BYTE DEFINITION ROTATED, ON LEFT BORDER
; 01.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _SP1_DRAW_XOR1LB

EXTERN _SP1_DRAW_XOR1NR
EXTERN SP1RETSPRDRAW

; following data segment copied into struct sp1_cs

   ld hl,0
   nop
   ld de,0
   call _SP1_DRAW_XOR1LB

; following draw code called by way of SP1UpdateNow
;
;  a = hor rot table
; bc = graphic disp
; hl = graphic def ptr
; de = left graphic def ptr
;
; 32 + 94*4 - 6 + 10 = 412 cycles

_SP1_DRAW_XOR1LB:

   cp SP1V_ROTTBL/256
   jp z, _SP1_DRAW_XOR1NR

   add hl,bc
   ld d,a

   ;  d = shift table
   ; hl = sprite def (graph only)

_SP1Xor1LBRotate:

   ; 0

   ld bc,(SP1V_PIXELBUFFER+0)
   ld e,(hl)
   inc hl
   ld a,(de)
   xor c
   ld (SP1V_PIXELBUFFER+0),a
   ld e,(hl)
   inc hl
   ld a,(de)
   xor b
   ld (SP1V_PIXELBUFFER+1),a

   ; 1

   ld bc,(SP1V_PIXELBUFFER+2)
   ld e,(hl)
   inc hl
   ld a,(de)
   xor c
   ld (SP1V_PIXELBUFFER+2),a
   ld e,(hl)
   inc hl
   ld a,(de)
   xor b
   ld (SP1V_PIXELBUFFER+3),a


   ; 2

   ld bc,(SP1V_PIXELBUFFER+4)
   ld e,(hl)
   inc hl
   ld a,(de)
   xor c
   ld (SP1V_PIXELBUFFER+4),a
   ld e,(hl)
   inc hl
   ld a,(de)
   xor b
   ld (SP1V_PIXELBUFFER+5),a


   ; 3

   ld bc,(SP1V_PIXELBUFFER+6)
   ld e,(hl)
   inc hl
   ld a,(de)
   xor c
   ld (SP1V_PIXELBUFFER+6),a
   ld e,(hl)
   ld a,(de)
   xor b
   ld (SP1V_PIXELBUFFER+7),a

   jp SP1RETSPRDRAW
