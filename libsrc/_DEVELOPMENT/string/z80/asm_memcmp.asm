
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int memcmp(const void *s1, const void *s2, size_t n)
;
; Compare maximum of n bytes of s1 to s2.  Return when first
; differing char is found with *s1 - *s2.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_memcmp
PUBLIC asm0_memcmp

asm_memcmp:

   ; enter : bc = uint n
   ;         hl = void *s2
   ;         de = void *s1
   ;
   ; exit  :  a = h = *s1-*s2 of last char compared
   ;         de = ptr in s1 to first differing char
   ;
   ;         if s1==s2 : hl=0, bc=0,  nc+z flags set
   ;         if s1<<s2 : hl<0, c+nz flags set
   ;         if s1>>s2 : hl>0, nc+nz flags set
   ;
   ; uses  : af, bc, de, hl

   ld a,b
   or c
   jp Z, equal

asm0_memcmp:

IF __CPU_8085__
   dec bc
ENDIF

loop:

   ld a,(de)                   ; a = *s1
IF __CPU_INTEL__ || __CPU_GBZ80__
   cp (hl)
   inc hl
   jp NZ, different
   inc de
   dec bc
ELSE
   cpi                         ; *s1 - *s2
   jr NZ, different
   inc de
ENDIF

IF __CPU_8085__
   jp NK,loop
   inc bc
   xor a
ELSE

IF  __CPU_8080__ || __CPU_GBZ80__
   ld a,b
   or c
   jp NZ,loop
ELSE
   jp PE, loop
ENDIF

ENDIF

equal:

   ld l,c
   ld h,b
   ret

different:
IF __CPU_8085__
   inc bc
ENDIF
   dec hl
   sub (hl)
   ld h,a
   ret
