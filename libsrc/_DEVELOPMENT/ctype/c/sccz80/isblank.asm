
; int isblank(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC isblank
PUBLIC isblank_fastcall

EXTERN asm_isblank, error_znc


isblank:
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

isblank_fastcall:

   inc h
   dec h
   jp nz, error_znc

   ld a,l
   call asm_isblank
   
   ld l,h
IF __CPU_GBZ80__
   ld d,h
   ld e,l
ENDIF
   ret nz
   
   inc l
IF __CPU_GBZ80__
   inc e
ENDIF
   ret



; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _isblank
defc _isblank = isblank
PUBLIC _isblank_fastcall
defc _isblank_fastcall = isblank_fastcall
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___isblank
defc ___isblank = isblank
ENDIF

