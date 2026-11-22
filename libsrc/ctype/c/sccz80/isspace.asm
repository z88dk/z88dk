
; int isspace(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC isspace
PUBLIC isspace_fastcall

EXTERN asm_isspace, error_zc

isspace:
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

isspace_fastcall:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isspace
   
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
PUBLIC _isspace
defc _isspace = isspace
PUBLIC _isspace_fastcall
defc _isspace_fastcall = isspace_fastcall
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___isspace
defc ___isspace = isspace
ENDIF

