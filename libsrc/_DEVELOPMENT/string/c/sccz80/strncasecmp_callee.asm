
; int strncasecmp(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strncasecmp_callee

EXTERN asm_strncasecmp

strncasecmp_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   ex de,hl

   jp asm_strncasecmp

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strncasecmp_callee
defc _strncasecmp_callee = strncasecmp_callee
ENDIF

