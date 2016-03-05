; CALLER linkage for function pointers

PUBLIC strnicmp
PUBLIC _strnicmp
EXTERN strnicmp_callee
EXTERN ASMDISP_STRNICMP_CALLEE

.strnicmp
._strnicmp

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp strnicmp_callee + ASMDISP_STRNICMP_CALLEE

