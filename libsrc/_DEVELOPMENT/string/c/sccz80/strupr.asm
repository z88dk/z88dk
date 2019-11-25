
; char *strupr(char *s)

SECTION code_clib
SECTION code_string

PUBLIC strupr

EXTERN asm_strupr

defc strupr = asm_strupr

IF __CLASSIC && __CPU_GBZ80__
PUBLIC _strupr

_strupr:
   ld hl,sp+2
   ld a,(hl+)
   ld h,(hl)
   ld l,a
   call asm_strupr
   ld   d,h
   ld   e,l
   ret
ENDIF

; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _strupr
defc _strupr = strupr
ENDIF

