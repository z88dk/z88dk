
; int isdigit(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC isdigit

EXTERN asm_isdigit, error_zc

IF __CLASSIC && __CPU_GBZ80__
PUBLIC _isdigit
_isdigit:
  ld  hl,sp+2
  ld  a,(hl+)
  ld  h,(hl)
  ld  l,a
ENDIF

isdigit:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isdigit
   
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
PUBLIC _isdigit
defc _isdigit = isdigit
ENDIF

