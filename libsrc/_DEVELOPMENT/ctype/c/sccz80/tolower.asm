
; int tolower(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC tolower
PUBLIC tolower_fastcall

EXTERN asm_tolower

tolower:
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
tolower_fastcall:

   inc h
   dec h
IF __CPU_GBZ80__
   ld d,h
   ld e,l
ENDIF
   ret nz

   ld a,l
   call asm_tolower
   
   ld l,a
IF __CPU_GBZ80__
   ld d,h
   ld e,l
ENDIF
   ret



; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tolower
defc _tolower = tolower
PUBLIC _tolower_fastcall
defc _tolower_fastcall = tolower_fastcall
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___tolower
defc ___tolower = tolower
ENDIF

