
; char *strrev(char *s)

SECTION code_clib
SECTION code_string

PUBLIC strrev

EXTERN asm_strrev


strrev:
IF __CPU_GBZ80__
   ld  hl,sp+2
   ld  a,(hl+)
   ld  h,(hl)
   ld  l,a
ELIF __CPU_RABBIT__ | __CPU_KC160__
   ld hl,(sp+2)
ELSE
   pop de
   pop hl
   push hl
   push de
ENDIF
IF __CPU_GBZ80__
   call asm_strrev
   ld   d,h
   ld   e,l
   ret
ELSE
    jp asm_strrev
ENDIF


; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _strrev
defc _strrev = strrev
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strrev
defc ___strrev = strrev
ENDIF

