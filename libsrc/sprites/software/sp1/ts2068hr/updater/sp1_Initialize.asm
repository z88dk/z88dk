; CALLER linkage for function pointers

XLIB sp1_Initialize

LIB sp1_Initialize_callee
XREF ASMDISP_SP1_INITIALIZE_CALLEE

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
