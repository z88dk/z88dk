
; size_t strnlen(const char *s, size_t maxlen)

SECTION code_clib
SECTION code_string

PUBLIC strnlen

EXTERN asm_strnlen

strnlen:

   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
IF __CLASSIC && __CPU_GBZ80__
   call asm_strnlen
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strnlen
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strnlen
defc _strnlen = strnlen
ENDIF

