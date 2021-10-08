
; double strtod(const char *nptr, char **endptr) __smallc

PUBLIC strtod

EXTERN mlib2d, asm_strtod

strtod:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   call asm_strtod

   jp mlib2d                   ; to sccz80_float

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtod
defc _strtod = strtod
ENDIF

