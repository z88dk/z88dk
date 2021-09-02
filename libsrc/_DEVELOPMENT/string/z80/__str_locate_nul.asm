
SECTION code_clib
SECTION code_string

PUBLIC __str_locate_nul

__str_locate_nul:

   ; enter : hl = char *s
   ;
   ; exit  : hl = ptr in s to terminating 0
   ;         bc = -(strlen + 1)
   ;          a = 0
   ;         carry reset
   ;
   ; uses  : af, bc, hl
   
   xor a
   ld c,a
   ld b,a
IF __CPU_INTEL__ || __CPU_GBZ80__
   dec bc
loop:
   ld a,(hl)
   and a
   ret Z
   inc hl
   dec bc

IF __CPU_8085__
   jp NK,loop
ELSE
   ld a,b
   or c
   jp NZ,loop
ENDIF

   and a
ELSE
   cpir
ENDIF
   dec hl
   ret
