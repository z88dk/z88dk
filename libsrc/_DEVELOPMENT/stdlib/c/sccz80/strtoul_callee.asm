
; unsigned long strtoul( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC strtoul_callee

EXTERN asm_strtoul

strtoul_callee:
IF __CPU_GBZ80__
   pop af	;ret
   pop bc	;base
   pop de	;endptr
   pop hl	;nptr
   push af
ELSE
   pop hl
   pop bc
   pop de
   ex (sp),hl
ENDIF
   
   jp asm_strtoul

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtoul_callee
defc _strtoul_callee = strtoul_callee
ENDIF

