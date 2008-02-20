; void sp1_PrintString(struct sp1_pss *ps, uchar *s)
; CALLER linkage for function pointers

XLIB sp1_PrintString

LIB sp1_PrintString_callee
XREF ASMDISP_SP1_PRINTSTRING_CALLEE

.sp1_PrintString

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ld a,(hl)
   ld iyl,a
   inc hl
   ld a,(hl)
   ld iyh,a
   inc hl
   ld a,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   inc hl
   push hl
   ex de,hl
   ld e,a
   exx
   pop hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   ld ixl,a
   inc hl
   ld a,(hl)
   ld ixh,a
   exx
   jp sp1_PrintString_callee + ASMDISP_SP1_PRINTSTRING_CALLEE
