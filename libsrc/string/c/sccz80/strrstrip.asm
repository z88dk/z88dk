
; char *strrstrip(char *s)

SECTION code_clib
SECTION code_string

PUBLIC strrstrip

EXTERN asm_strrstrip


strrstrip:
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
   call asm_strrstrip
   ld   d,h
   ld   e,l
   ret
ELSE
    jp asm_strrstrip
ENDIF


; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _strrstrip
defc _strrstrip = strrstrip
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strrstrip
defc ___strrstrip = strrstrip
ENDIF

