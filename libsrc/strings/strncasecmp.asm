; CALLER linkage for function pointers

SECTION code_clib
PUBLIC strncasecmp
PUBLIC _strncasecmp
EXTERN strnicmp_callee
EXTERN ASMDISP_STRNICMP_CALLEE

.strncasecmp
._strncasecmp

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp strnicmp_callee + ASMDISP_STRNICMP_CALLEE
