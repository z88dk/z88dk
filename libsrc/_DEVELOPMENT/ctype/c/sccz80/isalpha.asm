
; int isalpha(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC isalpha

EXTERN asm_isalpha, error_zc

IF __CLASSIC && __CPU_GBZ80__
PUBLIC _isalpha
_isalpha:
  ld  hl,sp+2
  ld  a,(hl+)
  ld  h,(hl)
  ld  l,a
ENDIF
isalpha:

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
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _isalpha
defc _isalpha = isalpha
ENDIF

