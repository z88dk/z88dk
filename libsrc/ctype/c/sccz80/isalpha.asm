
; int isalpha(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC isalpha
PUBLIC isalpha_fastcall

EXTERN asm_isalpha, error_zc

isalpha:
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

isalpha_fastcall:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isalpha
   
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
PUBLIC _isalpha
defc _isalpha = isalpha
PUBLIC _isalpha_fastcall
defc _isalpha_fastcall = isalpha_fastcall
ENDIF
