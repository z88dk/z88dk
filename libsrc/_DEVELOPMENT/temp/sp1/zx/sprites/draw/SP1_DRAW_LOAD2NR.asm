
; DRAW LOAD SPRITE 2 BYTE DEFINITION NO ROTATION
; 01.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _SP1_DRAW_LOAD2NR

EXTERN SP1RETSPRDRAW

; following data segment copied into struct sp1_cs

   ld hl,0
   nop
   ld de,0
   call _SP1_DRAW_LOAD2NR

; following draw code called by way of SP1UpdateNow
;
;  a = hor rot table
; bc = graphic disp
; hl = graphic def ptr (mask,graph) pairs
; de = left graphic def ptr
;
; 11 + 7*22 + 10 + 14 + 10 = 199 cycles

_SP1_DRAW_LOAD2NR:

   add hl,bc

   ; hl = sprite def (mask,graph) pairs

   ld de,SP1V_PIXELBUFFER
   inc hl
   ldi
   inc hl
   ldi
   inc hl
   ldi
   inc hl
   ldi
   inc hl
   ldi
   inc hl
   ldi
   inc hl
   ldi
   inc hl
   ld a,(hl)
   ld (de),a

   jp SP1RETSPRDRAW
