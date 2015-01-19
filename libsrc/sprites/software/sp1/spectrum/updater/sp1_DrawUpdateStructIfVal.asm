
; sp1_DrawUpdateStructIfVal(struct sp1_update *u)
; 12.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

; FASTCALL

PUBLIC sp1_DrawUpdateStructIfVal
EXTERN SP1DrawUpdateStruct

; draw the char's graphics to screen but only
; if the update struct is currently validated
; (not already marked for draw)
;
; enter : hl = & struct sp1_update
; uses  : af, bc, de, hl, ix, b' for MaskLB and MaskRB sprites

.sp1_DrawUpdateStructIfVal

   ld a,(hl)
   ld b,a
   and $c0                   ; keep bits 7 (invalidated) and 6 (removed)
   ret nz                    ; do not draw if invalidated or removed
   jp SP1DrawUpdateStruct
