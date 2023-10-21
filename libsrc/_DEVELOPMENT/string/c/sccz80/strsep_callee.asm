
; char *strsep(char ** restrict stringp, const char * restrict delim)

SECTION code_clib
SECTION code_string

PUBLIC strsep_callee

EXTERN asm_strsep

strsep_callee:

   pop hl
   pop de
   pop bc
   push hl
IF __CLASSIC && __CPU_GBZ80__
   call asm_strsep
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strsep
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strsep_callee
defc _strsep_callee = strsep_callee
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strsep_callee
defc ___strsep_callee = strsep_callee
ENDIF

