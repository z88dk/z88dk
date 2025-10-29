
; int isascii(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC isascii
PUBLIC isascii_fastcall

EXTERN error_znc


isascii:
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

isascii_fastcall:

   inc h
   dec h
   jp nz, error_znc

IF __CPU_INTEL__
   ld a,l
   rla
   ld l,h
   ret c
ELSE
   bit 7,l
 IF __CPU_GBZ80__
   ld d,h
   ld e,l
 ENDIF
   ld l,h
   ret nz
ENDIF

   inc l
IF __CPU_GBZ80__
   inc e
ENDIF
   ret


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _isascii
defc _isascii = isascii
PUBLIC _isascii_fastcall
defc _isascii_fastcall = isascii_fastcall
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___isascii
defc ___isascii = isascii
ENDIF

