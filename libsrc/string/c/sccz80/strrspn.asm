
; size_t strrspn(const char *str, const char *cset)

SECTION code_clib
SECTION code_string

PUBLIC strrspn

EXTERN asm_strrspn

strrspn:

   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
IF __CLASSIC && __CPU_GBZ80__   
   call asm_strrspn
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strrspn
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strrspn
defc _strrspn = strrspn
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strrspn
defc ___strrspn = strrspn
ENDIF

