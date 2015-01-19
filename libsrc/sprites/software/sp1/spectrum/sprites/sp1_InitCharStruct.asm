; void sp1_InitCharStruct(struct sp1_cs *cs, void *drawf, uchar type, void *graphic, uchar plane)
; CALLER linkage for function pointers

PUBLIC sp1_InitCharStruct

EXTERN sp1_InitCharStruct_callee
EXTERN ASMDISP_SP1_INITCHARSTRUCT_CALLEE

.sp1_InitCharStruct

   pop ix
   pop bc
   ld a,c
   ex af,af
   pop bc
   pop de
   ld a,e
   pop de
   pop hl
   push hl
   push de
   push de
   push bc
   push bc
   push ix
   jp sp1_InitCharStruct_callee + ASMDISP_SP1_INITCHARSTRUCT_CALLEE
