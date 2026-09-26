
; char *strcat(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC strcat

EXTERN asm_strcat

strcat:

   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
IF __CLASSIC && __CPU_GBZ80__
   call asm_strcat
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strcat
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strcat
defc _strcat = strcat
ENDIF


; Clang bridge for Classic (llvmz80 reversed-arg register ABI).
; __strcat(const char *s2, char *s1): HL=s2 (src), DE=s1 (dst); return dst in DE.
IF __CLASSIC
PUBLIC ___strcat
___strcat:
   call asm_strcat          ; enter HL=src, DE=dst; exit HL=dst
   ex de,hl                 ; DE = dst (C return value)
   ret
ENDIF

