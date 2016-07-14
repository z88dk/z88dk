
; SP1MakeRect8Pix
; 05.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC SP1MakeRect8Pix

; Conversion from struct_sp1_ss to struct_r_Rect8
; with members multiplied by 8 (change from character
; coordinates to pixel coordinates).
;
; enter : hl = struct sp1_ss *
;         de = destination struct r_Rect8 *
; uses  : af, b, de, hl

.SP1MakeRect8Pix

   ld b,(hl)
   inc hl
   ld a,(hl)
   inc hl
   add a,a
   add a,a
   add a,a
   ld (de),a
   inc de
   ld a,(hl)
   inc hl
   add a,a
   add a,a
   add a,a
   ld (de),a
   inc de
   ld a,b
   add a,a
   add a,a
   add a,a
   ld (de),a
   inc de
   ld a,(hl)
   inc hl
   add a,a
   add a,a
   add a,a
   ld (de),a
   dec de
   ld a,(de)
   ld b,a
   ld a,(hl)
   inc hl
   and $07
   add a,b
   ld (de),a
   dec de
   dec de
   ld a,(de)
   add a,(hl)
   ld (de),a
   ret
