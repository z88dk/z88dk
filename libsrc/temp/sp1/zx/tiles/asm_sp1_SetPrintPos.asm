; void sp1_SetPrintPos(struct sp1_pss *ps, uchar row, uchar col)
; 05.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_SetPrintPos

EXTERN asm_sp1_GetUpdateStruct

asm_sp1_SetPrintPos:

; e = col
; d = row
; hl = struct sp1_pss *ps

   ld c,(hl)
   inc hl
   ld b,(hl)                 ; bc = & bounds rectangle
   inc hl
   inc hl
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   inc hl
   inc hl
   push hl
   ld a,(bc)
   add a,d
   ld d,a
   inc bc
   ld a,(bc)
   add a,e
   ld e,a
   call asm_sp1_GetUpdateStruct
   pop de
   ex de,hl
   ld (hl),e
   inc hl
   ld (hl),d
   ret
