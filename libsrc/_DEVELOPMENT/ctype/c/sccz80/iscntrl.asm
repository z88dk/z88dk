
; int iscntrl(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC iscntrl

EXTERN asm_iscntrl, error_znc

IF __CLASSIC && __CPU_GBZ80__
PUBLIC _iscntrl
_iscntrl:
  ld  hl,sp+2
  ld  a,(hl+)
  ld  h,(hl)
  ld  l,a
ENDIF
iscntrl:

   inc h
   dec h
   jp nz, error_znc

   ld a,l
   call asm_iscntrl
   
   ld l,h
IF __CPU_GBZ80__
   ld d,h
   ld e,l
ENDIF
   ret nc
   
   inc l
IF __CPU_GBZ80__
   inc e
ENDIF
   ret

; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _iscntrl
defc _iscntrl = iscntrl
ENDIF

