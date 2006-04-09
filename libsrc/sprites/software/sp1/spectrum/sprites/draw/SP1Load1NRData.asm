
; DRAW LOAD SPRITE 1 BYTE DEFINITION NO ROTATION
; 01.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1Load1NRData
XREF SP1RETSPRDRAW, SP1V_PIXELBUFFER

; following data segment copied into struct sp1_cs

.SP1Load1NRData

   ld hl,0
   nop
   ld de,0
   call SP1Load1NR

; following draw code called by way of SP1UpdateNow
;
;  a = hor rot table
; bc = graphic disp
; hl = graphic def ptr
; de = left graphic def ptr
;
; 11 + 7*16 + 10 + 14 + 10 = 157 cycles

.SP1Load1NR

   add hl,bc

   ; hl = sprite def (graph only)

   ld de,SP1V_PIXELBUFFER
   ldi
   ldi
   ldi
   ldi
   ldi
   ldi
   ldi
   ld a,(hl)
   ld (de),a

   jp SP1RETSPRDRAW
