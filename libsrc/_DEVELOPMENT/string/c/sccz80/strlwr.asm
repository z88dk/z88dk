
; char *strlwr(char *s)

SECTION code_clib
SECTION code_string

PUBLIC strlwr

EXTERN asm_strlwr


strlwr:
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
   call asm_strlwr
   ld   d,h
   ld   e,l
   ret
ELSE
    jp asm_strlwr
ENDIF


; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _strlwr
defc _strlwr = strlwr
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strlwr
defc ___strlwr = strlwr
ENDIF

