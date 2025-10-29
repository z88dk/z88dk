
; char *strstrip(char *s)

SECTION code_clib
SECTION code_string

PUBLIC strstrip

EXTERN asm_strstrip


strstrip:
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
   call asm_strstrip
   ld   d,h
   ld   e,l
   ret
ELSE
    jp asm_strstrip
ENDIF


; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _strstrip
defc _strstrip = strstrip
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strstrip
defc ___strstrip = strstrip
ENDIF

