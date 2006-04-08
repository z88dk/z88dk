
; SP1GetSprClr
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1GetSprClr

; Copy sprite colours into an array of struct_sp1_ap
; colour pairs.
;
; enter :  b = number of colour pairs to copy (size of sprite in tiles)
;         de = struct sp1_ap[] dest array of colour pairs
;         hl = array of sprite colour addresses (all point at struct sp1_cs.attr_mask)
; uses  : f, bc, de, hl

.SP1GetSprClr

   ld c,0

.loop

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
