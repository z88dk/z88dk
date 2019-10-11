
; int isascii(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC isascii

EXTERN error_znc

IF __CLASSIC && __CPU_GBZ80__
PUBLIC _isascii
_isascii:
  ld  hl,sp+2
  ld  a,(hl+)
  ld  h,(hl)
  ld  l,a
ENDIF

isascii:

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
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _isascii
defc _isascii = isascii
ENDIF

