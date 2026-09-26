
; int strcmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strcmp

EXTERN asm_strcmp

strcmp:

   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
IF __CLASSIC && __CPU_GBZ80__
   call asm_strcmp
   ld d,h
   ld e,l
   ret
ELSE   
   jp asm_strcmp
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strcmp
defc _strcmp = strcmp
ENDIF


; Clang bridge for Classic (llvmz80 reversed-arg register ABI).
; __strcmp(const char *s2, const char *s1): HL=s2, DE=s1; int return in DE.
IF __CLASSIC
PUBLIC ___strcmp
___strcmp:
   call asm_strcmp          ; enter HL=s2, DE=s1; exit HL=signed result
   ex de,hl                 ; DE = result (C return value)
   ret
ENDIF

