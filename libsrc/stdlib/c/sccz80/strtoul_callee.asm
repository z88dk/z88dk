
; unsigned long strtoul( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC strtoul_callee

EXTERN asm_strtoul

strtoul_callee:
   pop hl
   pop bc
   pop de
   ex (sp),hl
IF !__CPU_INTEL__ && !__CPU_GBZ80__
   push ix 
   call asm_strtoul
   pop ix
   ret
ELSE
    jp asm_strtoul
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtoul_callee
defc _strtoul_callee = strtoul_callee
ENDIF

