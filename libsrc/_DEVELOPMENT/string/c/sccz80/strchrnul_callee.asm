
; char *strchrnul(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC strchrnul_callee

EXTERN asm_strchrnul

strchrnul_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_strchrnul

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strchrnul_callee
defc _strchrnul_callee = strchrnul_callee
ENDIF

