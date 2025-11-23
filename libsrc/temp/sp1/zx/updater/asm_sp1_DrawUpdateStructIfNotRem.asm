
; sp1_DrawUpdateStructIfNotRem(struct sp1_update *u)
; 12.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

; FASTCALL

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_DrawUpdateStructIfNotRem

EXTERN SP1DrawUpdateStruct

; Draw the char's graphics to screen if it hasn't
; been removed.  Validates char as well.
;
; enter : hl = & struct sp1_update
; uses  : af, bc, de, hl, ix, b' for MaskLB and MaskRB sprites

asm_sp1_DrawUpdateStructIfNotRem:

   bit 6,(hl)
   ret nz                    ; do not draw if removed
   
   ld a,(hl)
   and $7f
   ld (hl),a                 ; validate char
   
   ld b,a
   jp SP1DrawUpdateStruct
