
; DRAW OR SPRITE 2 BYTE DEFINITION ROTATED
; 01.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC SP1_DRAW_OR2
EXTERN SP1_DRAW_OR2NR
EXTERN SP1RETSPRDRAW, SP1V_ROTTBL, SP1V_PIXELBUFFER

; following data segment copied into struct sp1_cs

   ld hl,0
   ld ix,0
   call SP1_DRAW_OR2

; following draw code called by way of SP1UpdateNow
;
;  a = hor rot table
; bc = graphic disp
; hl = graphic def ptr (mask,graph) pairs
; ix = left graphic def ptr
;
; 51 + 178*4 - 6 + 10 = 767 cycles

.SP1_DRAW_OR2

   cp SP1V_ROTTBL/256
   jp z, SP1_DRAW_OR2NR

   add hl,bc
   add ix,bc
   ex de,hl
   ld h,a

   ;  h = shift table
   ; de = sprite def (mask,graph) pairs
   ; ix = left sprite def

.SP1Or2Rotate

   ; 0

   ld bc,(SP1V_PIXELBUFFER+0)
   inc de
   ld a,(de)
   inc de
   ld l,a
   ld a,(hl)
   inc h
   ld l,(ix+1)
   or (hl)
   or c
   ld (SP1V_PIXELBUFFER+0),a
   ld l,(ix+3)
   ld c,(hl)
   dec h
   inc de
   ld a,(de)
   inc de
   ld l,a
   ld a,c
   or b
   or (hl)
   ld (SP1V_PIXELBUFFER+1),a

   ; 1

   ld bc,(SP1V_PIXELBUFFER+2)
   inc de
   ld a,(de)
   inc de
   ld l,a
   ld a,(hl)
   inc h
   ld l,(ix+5)
   or (hl)
   or c
   ld (SP1V_PIXELBUFFER+2),a
   ld l,(ix+7)
   ld c,(hl)
   dec h
   inc de
   ld a,(de)
   inc de
   ld l,a
   ld a,c
   or b
   or (hl)
   ld (SP1V_PIXELBUFFER+3),a

   ; 2

   ld bc,(SP1V_PIXELBUFFER+4)
   inc de
   ld a,(de)
   inc de
   ld l,a
   ld a,(hl)
   inc h
   ld l,(ix+9)
   or (hl)
   or c
   ld (SP1V_PIXELBUFFER+4),a
   ld l,(ix+11)
   ld c,(hl)
   dec h
   inc de
   ld a,(de)
   inc de
   ld l,a
   ld a,c
   or b
   or (hl)
   ld (SP1V_PIXELBUFFER+5),a

   ; 3

   ld bc,(SP1V_PIXELBUFFER+6)
   inc de
   ld a,(de)
   inc de
   ld l,a
   ld a,(hl)
   inc h
   ld l,(ix+13)
   or (hl)
   or c
   ld (SP1V_PIXELBUFFER+6),a
   ld l,(ix+15)
   ld c,(hl)
   dec h
   inc de
   ld a,(de)
   ld l,a
   ld a,c
   or b
   or (hl)
   ld (SP1V_PIXELBUFFER+7),a

   jp SP1RETSPRDRAW
