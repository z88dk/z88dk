
; sp1_DrawUpdateStructAlways(struct sp1_update *u)
; 12.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

; FASTCALL

PUBLIC sp1_DrawUpdateStructAlways
EXTERN SP1DrawUpdateStruct

; Draws the update struct no matter what, including
; structs removed from the engine.  Validates char
; if it hasn't been removed.
;
; enter : hl = & struct sp1_update
; uses  : af, bc, de, hl, ix, b' for MaskLB and MaskRB sprites

.sp1_DrawUpdateStructAlways

   bit 6,(hl)
   jr nz, skipval
   res 7,(hl)

.skipval

   ld a,(hl)
   and $3f
   ld b,a
   jp SP1DrawUpdateStruct
