; void sp1_GetSprClr(uchar **sprsrc, struct sp1_ap *dest, uchar n)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_GetSprClr

asm_sp1_GetSprClr:

; Copy sprite colours into an array of struct_sp1_ap
; colour pairs.
;
; enter :  b = number of colour pairs to copy (size of sprite in tiles)
;         de = struct sp1_ap[] dest array of colour pairs
;         hl = array of sprite colour addresses (all point at struct sp1_cs.attr_mask)
; uses  : f, bc, de, hl

   ld c,$ff

loop:

   push de
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = & struct sp1_cs.attr_mask
   inc hl
   ex (sp),hl
   ex de,hl                    ; hl = & struct sp1_cs.attr_mask, de = destination array of colour pairs
   ldi
   ldi
   pop hl
   djnz loop

   ret
