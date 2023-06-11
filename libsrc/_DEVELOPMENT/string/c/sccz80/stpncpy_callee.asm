
; char *stpncpy(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC stpncpy_callee

EXTERN asm_stpncpy

stpncpy_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   ex de,hl

   jp asm_stpncpy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _stpncpy_callee
defc _stpncpy_callee = stpncpy_callee
ENDIF

