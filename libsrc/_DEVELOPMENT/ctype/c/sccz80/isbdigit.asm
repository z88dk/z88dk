
; int isbdigit(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC isbdigit
PUBLIC isbdigit_fastcall

EXTERN asm_isbdigit, error_znc


isbdigit:
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

isbdigit_fastcall:

   inc h
   dec h
   jp nz, error_znc

   ld a,l
   call asm_isbdigit
   
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
PUBLIC _isbdigit
defc _isbdigit = isbdigit
PUBLIC _isbdigit_fastcall
defc _isbdigit_fastcall = isbdigit_fastcall
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___isbdigit
defc ___isbdigit = isbdigit
ENDIF

