
; int strncasecmp_callee(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _strncasecmp_callee

EXTERN asm_strncasecmp

_strncasecmp_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af

IF __CPU_Z180__ || __CPU_R2KA__ || __CPU_R3K__

   jp asm_strncasecmp

ELSE

PUBLIC l0_strncasecmp_callee

l0_strncasecmp_callee:

   push ix
   
   call asm_strncasecmp
   
   pop ix
   ret

ENDIF
