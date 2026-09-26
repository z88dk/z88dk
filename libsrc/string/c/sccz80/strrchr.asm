
; char *strrchr(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC strrchr

EXTERN asm_strrchr

strrchr:

   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
IF __CLASSIC && __CPU_GBZ80__   
   call asm_strrchr
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strrchr
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strrchr
defc _strrchr = strrchr
ENDIF


; Clang bridge for Classic (llvmz80 register ABI).
; __ZPROTO2(strrchr, s, c) -> ___strrchr(c, s): HL=c (int), DE=s.
; asm_strrchr enter: C=c, HL=s.
IF __CLASSIC
PUBLIC ___strrchr
___strrchr:
   ld c,l                   ; C = c (char, low byte)
   ex de,hl                 ; HL = s
   call asm_strrchr         ; enter C=c, HL=s; exit HL=ptr or 0
   ex de,hl                 ; DE = result (C return value)
   ret
ENDIF

