
; int isgraph(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC isgraph

EXTERN asm_isgraph, error_zc

IF __CLASSIC && __CPU_GBZ80__
PUBLIC _isgraph
_isgraph:
  ld  hl,sp+2
  ld  a,(hl+)
  ld  h,(hl)
  ld  l,a
ENDIF

isgraph:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isgraph
   
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
PUBLIC _isgraph
defc _isgraph = isgraph
ENDIF

