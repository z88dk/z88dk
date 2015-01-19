; CALLER linkage for function pointers

PUBLIC sp1_Initialize

EXTERN sp1_Initialize_callee
EXTERN ASMDISP_SP1_INITIALIZE_CALLEE

.sp1_Initialize

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   ex de,hl

   jp sp1_Initialize_callee + ASMDISP_SP1_INITIALIZE_CALLEE
