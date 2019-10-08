
; int tolower(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC tolower

EXTERN asm_tolower

IF __CLASSIC && __CPU_GBZ80__
PUBLIC _tolower
_tolower:
  ld  hl,sp+2
  ld  a,(hl+)
  ld  h,(hl)
  ld  l,a
ENDIF

tolower:

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
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _tolower
defc _tolower = tolower
ENDIF

