
; int strncasecmp(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strncasecmp

EXTERN asm_strncasecmp

strncasecmp:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af

IF __CLASSIC
   push ix   
   call  asm_strncasecmp
   pop  ix
   ret
ELSE
   jp asm_strncasecmp
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strncasecmp
defc _strncasecmp = strncasecmp
ENDIF

