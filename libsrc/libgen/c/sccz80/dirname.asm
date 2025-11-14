
; char *dirname(char *s)

SECTION code_clib
SECTION code_string

PUBLIC dirname

EXTERN asm_dirname


dirname:
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
   call asm_dirname
   ld   d,h
   ld   e,l
   ret
ELSE
    jp asm_dirname
ENDIF


; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _dirname
defc _dirname = dirname
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___dirname
defc ___dirname = dirname
ENDIF

