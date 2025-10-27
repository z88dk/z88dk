

; long strtol( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC strtol_callee

EXTERN asm_strtol

strtol_callee:
   pop hl
   pop bc
   pop de
   ex (sp),hl
IF !__CPU_INTEL__ && !__CPU_GBZ80__
   push ix 
   call asm_strtol
   pop ix
   ret
ELSE
    jp asm_strtol
ENDIF


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtol_callee
defc _strtol_callee = strtol_callee
ENDIF

