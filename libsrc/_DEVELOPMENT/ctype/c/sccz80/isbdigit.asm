
; int isbdigit(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC isbdigit

EXTERN asm_isbdigit, error_znc

IF __CLASSIC && __CPU_GBZ80__
PUBLIC _isbdigit
_isbdigit:
  ld  hl,sp+2
  ld  a,(hl+)
  ld  h,(hl)
  ld  l,a
ENDIF

isbdigit:

   inc h
   dec h
   jp nz, error_znc

   ld a,l
   call asm_isbdigit
   
   ld l,h
IF __CPU_GBZ80__
   ld d,h
   ld e,l
ENDIF
   ret nz
   
   inc l
IF __CPU_GBZ80__
   inc e
ENDIF
   ret

; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _isbdigit
defc _isbdigit = isbdigit
ENDIF

