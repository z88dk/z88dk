
; BSD
; void *rawmemchr(const void *mem, int c)

SECTION code_clib
SECTION code_string

PUBLIC asm_rawmemchr

asm_rawmemchr:

   ; enter : hl = void *mem
   ;          a = int c
   ;
   ; exit  : hl = pointer to char c
   ;
   ; uses  : af, bc, hl + de (gbz80/8080)

   ld bc,0
   
IF !__CPU_8085__

IF __CPU_8080__ || __CPU_GBZ80__
   push de
   ld e,a
loop:
   ld a,e
   cp (hl)
   jr z,matched
   inc hl
   dec bc
   ld a,b
   or c
   jr nz,loop
matched:
   pop de
ELSE
   ;
   ; uses  : af, bc, hl
   cpir
   dec hl
ENDIF
   ret

ELSE ; __CPU_8085__
   ;
   ; uses  : af, bc, hl
loop:
   cp (hl)
   ret Z
   inc hl
   inc bc
   jp NK,loop
ENDIF
