
; int toascii(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC toascii

IF __CLASSIC && __CPU_GBZ80__
PUBLIC _toascii
_toascii:
  ld  hl,sp+2
  ld  a,(hl+)
  ld  h,(hl)
  ld  l,a
ENDIF

toascii:

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
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _toascii
defc _toascii = toascii
ENDIF

