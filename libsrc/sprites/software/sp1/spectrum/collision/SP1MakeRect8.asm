
; SP1MakeRect8
; 05.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC SP1MakeRect8

; A straight conversion from struct_sp1_Rect
; to struct_r_Rect8
;
; enter : hl = struct sp1_Rect *
;         de = destination struct r_Rect8 *
; uses  : a, b, de, hl

.SP1MakeRect8

   ld b,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld (de),a
   inc de
   ld a,(hl)
   inc hl
   ld (de),a
   inc de
   ld a,b
   ld (de),a
   inc de
   ld a,(hl)
   ld (de),a
   ret
