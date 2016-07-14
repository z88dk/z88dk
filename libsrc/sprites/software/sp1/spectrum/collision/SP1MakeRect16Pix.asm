
; SP1MakeRect16Pix
; 05.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC SP1MakeRect16Pix

; Conversion from struct_sp1_ss to struct_r_Rect16
; with members multiplied by 8 (change from character
; coordinates to pixel coordinates).
;
; enter : hl = struct sp1_ss *
;         bc = destination struct r_Rect16 *
; uses  : af, af', bc, de, hl

.SP1MakeRect16Pix

   ld a,(hl)
   ex af,af
   inc hl
   ld e,(hl)
   ld d,0
   inc hl
   push de
   inc bc
   inc bc
   ld e,(hl)
   inc hl
   ex de,hl
   add hl,hl
   add hl,hl
   add hl,hl
   ld a,l
   ld (bc),a
   inc bc
   ld a,h
   ld (bc),a
   inc bc
   ex de,hl
   inc bc
   inc bc
   ld e,(hl)
   inc hl
   ld d,0
   ex de,hl
   add hl,hl
   add hl,hl
   add hl,hl
   ld a,l
   ld (bc),a
   inc bc
   ld a,h
   ld (bc),a
   dec bc
   dec bc
   ex de,hl
   ex af,af
   ld e,a
   ld a,(hl)
   inc hl
   and $07
   ld d,0
   ex de,hl
   add hl,hl
   add hl,hl
   add hl,hl
   add a,l
   ld l,a
   jp nc, noinc0
   inc h
.noinc0
   ld a,h
   ld (bc),a
   dec bc
   ld a,l
   ld (bc),a
   dec bc
   dec bc
   dec bc
   ld a,(de)
   pop hl
   ld d,h
   ld e,a
   add hl,hl
   add hl,hl
   add hl,hl
   add hl,de
   ld a,h
   ld (bc),a
   dec bc
   ld a,l
   ld (bc),a
   ret
