
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
   
   jp asm_strsep

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strsep_callee
defc _strsep_callee = strsep_callee
ENDIF

