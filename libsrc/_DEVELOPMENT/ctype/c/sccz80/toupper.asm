
; int toupper(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC toupper

EXTERN asm_toupper

IF __CLASSIC && __CPU_GBZ80__
PUBLIC _toupper
_toupper:
  ld  hl,sp+2
  ld  a,(hl+)
  ld  h,(hl)
  ld  l,a
ENDIF

toupper:

   inc h
   dec h
IF __CPU_GBZ80__
   ld d,h
   ld e,l
ENDIF
   ret nz

   ld a,l
   call asm_toupper
   
   ld l,a
IF __CPU_GBZ80__
   ld d,h
   ld e,l
ENDIF
   ret

; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _toupper
defc _toupper = toupper
ENDIF

