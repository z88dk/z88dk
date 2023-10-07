
; int isalnum(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC isalnum
PUBLIC isalnum_fastcall

EXTERN asm_isalnum, error_zc

PUBLIC isalnum
isalnum:
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

isalnum_fastcall:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isalnum
   
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
PUBLIC _isalnum
defc _isalnum = isalnum
PUBLIC _isalnum_fastcall
defc _isalnum_fastcall = isalnum_fastcall
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___isalnum
defc ___isalnum = isalnum
ENDIF

