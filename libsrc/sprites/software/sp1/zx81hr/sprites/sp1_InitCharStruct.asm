; void sp1_InitCharStruct(struct sp1_cs *cs, void *drawf, uchar type, void *graphic, uchar plane)
; CALLER linkage for function pointers

PUBLIC sp1_InitCharStruct

EXTERN sp1_InitCharStruct_callee
EXTERN ASMDISP_SP1_INITCHARSTRUCT_CALLEE

.sp1_InitCharStruct

   ld hl,2
   add hl,sp
   ld a,(hl)
   ld ixl,a
   inc hl
   inc hl
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld a,(hl)
   ld ixh,a
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ld a,ixh

   jp sp1_InitCharStruct_callee + ASMDISP_SP1_INITCHARSTRUCT_CALLEE
