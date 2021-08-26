
; int strncasecmp(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _strncasecmp

_strncasecmp:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af

IF __CPU_Z180__ || __CPU_R2KA__ || __CPU_R3K__

   EXTERN asm_strncasecmp
   jp     asm_strncasecmp

ELSE

   EXTERN l0_strncasecmp_callee
   jp     l0_strncasecmp_callee

ENDIF
