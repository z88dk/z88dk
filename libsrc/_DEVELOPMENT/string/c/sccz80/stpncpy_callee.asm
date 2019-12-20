
; char *stpncpy(char * restrict s1, const char * restrict s2, size_t n)

IF !__CPU_GBZ80__
SECTION code_clib
SECTION code_string

PUBLIC stpncpy_callee

EXTERN asm_stpncpy

stpncpy_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   jp asm_stpncpy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _stpncpy_callee
defc _stpncpy_callee = stpncpy_callee
ENDIF

ENDIF
