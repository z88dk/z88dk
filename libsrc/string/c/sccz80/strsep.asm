
; char *strsep(char ** restrict stringp, const char * restrict delim)

SECTION code_clib
SECTION code_string

PUBLIC strsep

EXTERN asm_strsep

strsep:

   pop hl
   pop de
   pop bc

   push bc
   push de
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
PUBLIC _strsep
defc _strsep = strsep
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strsep
defc ___strsep = strsep
ENDIF

