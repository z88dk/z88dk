
; int isdigit(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC isdigit
PUBLIC isdigit_fastcall

EXTERN asm_isdigit, error_zc


isdigit:
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

isdigit_fastcall:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isdigit
   
   ld l,h
IF __CPU_GBZ80__
   ld d,h
   ld e,l
ENDIF
   ret c
   
   inc l
IF __CPU_GBZ80__
   inc e
ENDIF
   ret




; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _isdigit
defc _isdigit = isdigit
PUBLIC _isdigit_fastcall
defc _isdigit_fastcall = isdigit_fastcall
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___isdigit
defc ___isdigit = isdigit
ENDIF

