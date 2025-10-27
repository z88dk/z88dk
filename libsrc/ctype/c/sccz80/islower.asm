
; int islower(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC islower
PUBLIC islower_fastcall

EXTERN asm_islower, error_zc

islower:
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

islower_fastcall:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_islower
   
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
PUBLIC _islower
defc _islower = islower
PUBLIC _islower_fastcall
defc _islower_fastcall = islower_fastcall
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___islower
defc ___islower = islower
ENDIF

