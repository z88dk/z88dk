
; DRAW MASK SPRITE 2 BYTE DEFINITION ROTATED
; 01.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC SP1_DRAW_MASK2
EXTERN SP1_DRAW_MASK2NR
EXTERN SP1RETSPRDRAW, SP1V_ROTTBL, SP1V_PIXELBUFFER

; following data segment copied into struct sp1_cs

   ld hl,0
   ld ix,0
   call SP1_DRAW_MASK2

; following draw code called by way of SP1UpdateNow
;
;  a = hor rot table
; bc = graphic disp
; hl = graphic def ptr
; ix = left graphic def ptr
;
; 51 + 146*8 - 6 + 10 = 1223 cycles

.SP1_DRAW_MASK2

   cp SP1V_ROTTBL/256
   jp z, SP1_DRAW_MASK2NR

   add hl,bc
   add ix,bc
   ex de,hl
   ld h,a

   ;  h = shift table
   ; de = sprite def (mask,graph) pairs
   ; ix = left sprite def

.SP1Mask2Rotate

   ; 0

   ld a,(de)
   inc de
   ld l,a
   ld a,(hl)               ; a = spr mask rotated right
   inc h
   ld l,(ix+0)
   or (hl)                 ; or in mask rotated from left
   ld b,a                  ; b = total mask
   ld l,(ix+1)
   ld c,(hl)               ; c = spr graph rotated from left
   dec h
   ld a,(de)
   inc de
   ld l,a
   ld a,(SP1V_PIXELBUFFER+0) ; get background graphic
   and b                   ; mask it
   or c                    ; or graph rotated from left
   or (hl)                 ; or spr graph rotated right
   ld (SP1V_PIXELBUFFER+0),a ; store to current background

   ; 1

   ld a,(de)
   inc de
   ld l,a
   ld a,(hl)
   inc h
   ld l,(ix+2)
   or (hl)
   ld b,a
   ld l,(ix+3)
   ld c,(hl)
   dec h
   ld a,(de)
   inc de
   ld l,a
   ld a,(SP1V_PIXELBUFFER+1)
   and b
   or c
   or (hl)
   ld (SP1V_PIXELBUFFER+1),a

   ; 2

   ld a,(de)
   inc de
   ld l,a
   ld a,(hl)
   inc h
   ld l,(ix+4)
   or (hl)
   ld b,a
   ld l,(ix+5)
   ld c,(hl)
   dec h
   ld a,(de)
   inc de
   ld l,a
   ld a,(SP1V_PIXELBUFFER+2)
   and b
   or c
   or (hl)
   ld (SP1V_PIXELBUFFER+2),a

   ; 3

   ld a,(de)
   inc de
   ld l,a
   ld a,(hl)
   inc h
   ld l,(ix+6)
   or (hl)
   ld b,a
   ld l,(ix+7)
   ld c,(hl)
   dec h
   ld a,(de)
   inc de
   ld l,a
   ld a,(SP1V_PIXELBUFFER+3)
   and b
   or c
   or (hl)
   ld (SP1V_PIXELBUFFER+3),a

   ; 4

   ld a,(de)
   inc de
   ld l,a
   ld a,(hl)
   inc h
   ld l,(ix+8)
   or (hl)
   ld b,a
   ld l,(ix+9)
   ld c,(hl)
   dec h
   ld a,(de)
   inc de
   ld l,a
   ld a,(SP1V_PIXELBUFFER+4)
   and b
   or c
   or (hl)
   ld (SP1V_PIXELBUFFER+4),a

   ; 5

   ld a,(de)
   inc de
   ld l,a
   ld a,(hl)
   inc h
   ld l,(ix+10)
   or (hl)
   ld b,a
   ld l,(ix+11)
   ld c,(hl)
   dec h
   ld a,(de)
   inc de
   ld l,a
   ld a,(SP1V_PIXELBUFFER+5)
   and b
   or c
   or (hl)
   ld (SP1V_PIXELBUFFER+5),a

   ; 6

   ld a,(de)
   inc de
   ld l,a
   ld a,(hl)
   inc h
   ld l,(ix+12)
   or (hl)
   ld b,a
   ld l,(ix+13)
   ld c,(hl)
   dec h
   ld a,(de)
   inc de
   ld l,a
   ld a,(SP1V_PIXELBUFFER+6)
   and b
   or c
   or (hl)
   ld (SP1V_PIXELBUFFER+6),a

   ; 7

   ld a,(de)
   inc de
   ld l,a
   ld a,(hl)
   inc h
   ld l,(ix+14)
   or (hl)
   ld b,a
   ld l,(ix+15)
   ld c,(hl)
   dec h
   ld a,(de)
   ld l,a
   ld a,(SP1V_PIXELBUFFER+7)
   and b
   or c
   or (hl)
   ld (SP1V_PIXELBUFFER+7),a

   jp SP1RETSPRDRAW
