; CALLER linkage for function pointers

PUBLIC sp1_Initialize

EXTERN sp1_Initialize_callee
EXTERN ASMDISP_SP1_INITIALIZE_CALLEE

.sp1_Initialize

   ld hl,6
   add hl,sp
   ld a,(hl)
   dec hl
   dec hl
   ld d,(hl)
   dec hl
   dec hl
   ld e,(hl)
   ex de,hl

   jp sp1_Initialize_callee + ASMDISP_SP1_INITIALIZE_CALLEE

