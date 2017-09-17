
; BSD
; void *rawmemchr(const void *mem, int c)

SECTION code_clib
SECTION code_string

PUBLIC rawmemchr

EXTERN l0_rawmemchr_callee

rawmemchr:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af

   jp l0_rawmemchr_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _rawmemchr
defc _rawmemchr = rawmemchr
ENDIF

