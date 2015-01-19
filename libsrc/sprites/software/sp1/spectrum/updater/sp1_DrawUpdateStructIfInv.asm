
; sp1_DrawUpdateStructIfInv(struct sp1_update *u)
; 12.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

; FASTCALL

PUBLIC sp1_DrawUpdateStructIfInv
EXTERN SP1DrawUpdateStruct

; Draw the char's graphics to screen but only
; if the update struct is currently invalidated
; (ie marked for draw).  Also validates the char.
;
; enter : hl = & struct sp1_update
; uses  : af, bc, de, hl, ix, b' for MaskLB and MaskRB sprites

.sp1_DrawUpdateStructIfInv

   bit 6,(hl)
   ret nz                    ; do not draw if removed
   
   ld a,(hl)
   xor $80
   ret m                     ; do not draw if validated
   ld (hl),a                 ; mark as validated

   ld b,a
   jp SP1DrawUpdateStruct
