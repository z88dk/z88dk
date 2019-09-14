
; char *strnchr(const char *s, size_t n, int c)

SECTION code_clib
SECTION code_string

PUBLIC strnchr_callee

EXTERN asm_strnchr

strnchr_callee:

IF __CPU_GBZ80__
   pop af
   pop bc
   pop de
   pop hl
   push af
ELSE
   pop hl
   pop de
   pop bc
   ex (sp),hl
ENDIF
   
   jp asm_strnchr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strnchr_callee
defc _strnchr_callee = strnchr_callee
ENDIF

