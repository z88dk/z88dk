
; DRAW LOAD SPRITE 2 BYTE DEFINITION ROTATED
; 01.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC SP1_DRAW_LOAD2
EXTERN SP1_DRAW_LOAD2NR
EXTERN SP1RETSPRDRAW, SP1V_ROTTBL, SP1V_PIXELBUFFER

; following data segment copied into struct sp1_cs

   ld hl,0
   ld ix,0
   call SP1_DRAW_LOAD2

; following draw code called by way of SP1UpdateNow
;
;  a = hor rot table
; bc = graphic disp
; hl = graphic def ptr (mask,graph) pairs
; ix = left graphic def ptr
;
; 51 + 150*4 - 6 + 10 = 655 cycles

.SP1_DRAW_LOAD2

   cp SP1V_ROTTBL/256
   jp z, SP1_DRAW_LOAD2NR

   add hl,bc
   add ix,bc
   ex de,hl
   ld h,a

   ;  h = shift table
   ; de = sprite def (mask,graph) pairs
   ; ix = left sprite def

.SP1Load2Rotate

   ; 0

   inc de
   ld a,(de)
   inc de
   ld l,a
   ld a,(hl)
   inc h
   ld l,(ix+1)
   or (hl)
   ld (SP1V_PIXELBUFFER+0),a
   ld l,(ix+3)
   ld b,(hl)
   dec h
   inc de
   ld a,(de)
   inc de
   ld l,a
   ld a,b
   or (hl)
   ld (SP1V_PIXELBUFFER+1),a

   ; 1

   inc de
   ld a,(de)
   inc de
   ld l,a
   ld a,(hl)
   inc h
   ld l,(ix+5)
   or (hl)
   ld (SP1V_PIXELBUFFER+2),a
   ld l,(ix+7)
   ld b,(hl)
   dec h
   inc de
   ld a,(de)
   inc de
   ld l,a
   ld a,b
   or (hl)
   ld (SP1V_PIXELBUFFER+3),a

   ; 2

   inc de
   ld a,(de)
   inc de
   ld l,a
   ld a,(hl)
   inc h
   ld l,(ix+9)
   or (hl)
   ld (SP1V_PIXELBUFFER+4),a
   ld l,(ix+11)
   ld b,(hl)
   dec h
   inc de
   ld a,(de)
   inc de
   ld l,a
   ld a,b
   or (hl)
   ld (SP1V_PIXELBUFFER+5),a

   ; 3

   inc de
   ld a,(de)
   inc de
   ld l,a
   ld a,(hl)
   inc h
   ld l,(ix+13)
   or (hl)
   ld (SP1V_PIXELBUFFER+6),a
   ld l,(ix+15)
   ld b,(hl)
   dec h
   inc de
   ld a,(de)
   ld l,a
   ld a,b
   or (hl)
   ld (SP1V_PIXELBUFFER+7),a

   jp SP1RETSPRDRAW
