; CALLER LINKAGE FOR FUNCTION POINTERS

XLIB vz_line
LIB vz_line_callee
XREF ASMDISP_VZ_LINE_CALLEE

.vz_line

   pop af
   pop bc
   pop de
   pop hl
   ld d,e
   ld e,l
   pop hl
   ex af,af
   ld a,h
   pop hl
   ld h,a
   push hl
   push hl
   push hl
   push de
   push bc
   ex af,af
   push af
   
   jp vz_line_callee + ASMDISP_VZ_LINE_CALLEE
