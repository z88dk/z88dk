; void sp1_SetPrintPos(struct sp1_pss *ps, uchar row, uchar col)
; CALLER linkage for function pointers

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_SetPrintPos

EXTERN asm_sp1_SetPrintPos

sp1_SetPrintPos:

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   inc hl
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   jp asm_sp1_SetPrintPos
