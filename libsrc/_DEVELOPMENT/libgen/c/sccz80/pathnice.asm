
; char *pathnice(char *s)

SECTION code_clib
SECTION code_string

PUBLIC pathnice

EXTERN asm_pathnice


pathnice:
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
   call asm_pathnice
   ld   d,h
   ld   e,l
   ret
ELSE
    jp asm_pathnice
ENDIF


; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _pathnice
defc _pathnice = pathnice
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___pathnice
defc ___pathnice = pathnice
ENDIF

