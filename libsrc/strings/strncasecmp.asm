; CALLER linkage for function pointers

PUBLIC strncasecmp
EXTERN strnicmp_callee
EXTERN ASMDISP_STRNICMP_CALLEE

.strncasecmp

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp strnicmp_callee + ASMDISP_STRNICMP_CALLEE
