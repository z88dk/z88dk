; CALLER linkage for function pointers

XLIB sp1_Initialize

LIB sp1_Initialize_callee
XREF ASMDISP_SP1_INITIALIZE_CALLEE

.sp1_Initialize

   ld hl,10
   add hl,sp
   ld a,(hl)
   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ld b,(hl)
   dec hl
   ld c,(hl)
   dec hl
   dec hl
   ex af,af
   ld a,(hl)
   dec hl
   dec hl
   ld l,(hl)
   ld h,a
   ex af,af

   jp sp1_Initialize_callee + ASMDISP_SP1_INITIALIZE_CALLEE

