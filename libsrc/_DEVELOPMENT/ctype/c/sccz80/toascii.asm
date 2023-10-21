
; int toascii(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC toascii
PUBLIC toascii_fastcall

toascii:
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
toascii_fastcall:

   ld h,0
IF __CPU_INTEL__
   ld  a,l
   and 127
   ld  l,a
ELSE
   res 7,l
ENDIF
IF __CPU_GBZ80__
   ld d,h
   ld e,l
ENDIF
   ret


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _toascii
defc _toascii = toascii
PUBLIC _toascii_fastcall
defc _toascii_fastcall = toascii_fastcall
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___toascii
defc ___toascii = toascii
ENDIF

