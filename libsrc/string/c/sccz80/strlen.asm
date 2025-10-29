
; size_t strlen(const char *s)

SECTION code_clib
SECTION code_string

PUBLIC strlen

EXTERN asm_strlen

strlen:
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
   call asm_strlen
   ld   d,h
   ld   e,l
   ret
ELSE
    jp asm_strlen
ENDIF

; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _strlen
defc _strlen = strlen
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strlen
defc ___strlen = strlen
ENDIF

