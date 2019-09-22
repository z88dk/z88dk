
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
   
   jp asm_strsep

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strsep
defc _strsep = strsep
ENDIF

