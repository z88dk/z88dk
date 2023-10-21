
; int toupper(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC toupper
PUBLIC toupper_fastcall

EXTERN asm_toupper

toupper:
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
toupper_fastcall:

   inc h
   dec h
IF __CPU_GBZ80__
   ld d,h
   ld e,l
ENDIF
   ret nz

   ld a,l
   call asm_toupper
   
   ld l,a
IF __CPU_GBZ80__
   ld d,h
   ld e,l
ENDIF
   ret



; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _toupper
defc _toupper = toupper
PUBLIC _toupper_fastcall
defc _toupper_fastcall = toupper_fastcall
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___toupper
defc ___toupper = toupper
ENDIF

