
; int isupper(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC isupper
PUBLIC isupper_fastcall

EXTERN asm_isupper, error_zc

isupper:
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

isupper_fastcall:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isupper
   
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
PUBLIC _isupper
defc _isupper = isupper
PUBLIC _isupper_fastcall
defc _isupper_fastcall = isupper_fastcall
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___isupper
defc ___isupper = isupper
ENDIF

