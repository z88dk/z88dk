
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *memmove(void *s1, const void *s2, size_t n)
;
; Copy n chars from s2 to s1, return s1.  Overlap safe.
; Does nothing if s1 == s2.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_memmove

EXTERN asm0_memcpy, asm1_memcpy

asm_memmove:

   ; enter : bc = uint n
   ;         hl = void *s2 = src
   ;         de = void *s1 = dst
   ; 
   ; exit  : hl = void *s1 = dst
   ;         de = ptr in s1 to one byte past last byte copied
   ;         bc = 0 (n if dst == src)
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl

   ld a,b
   or c
   jp Z, asm1_memcpy
   
   ; Because of the possibility of overlap between
   ; dst and src, we have two scenarios:
   ;
   ; 1 - (dst<src) in which case must ldir
   ; 2 - (dst>src) in which case must lddr from end

   ; 8-bit compares faster most of the time
   
   ld a,d
   cp h
   jp C, asm0_memcpy
   jp NZ, use_lddr
   
   ld a,e
   cp l
   jp C, asm0_memcpy
   
   jp Z, asm1_memcpy           ; if dst == src, do nothing

use_lddr:

   push de
   dec bc
   
   add hl,bc
   ex de,hl
   add hl,bc
   ex de,hl
   
   push de

IF !__CPU_8085__
   inc bc
ENDIF

IF __CPU_INTEL__ || __CPU_GBZ80__
loop:
 IF __CPU_GBZ80__
   ld a,(hl-)
 ELSE
   ld a,(hl)
   dec hl
 ENDIF
   ld (de),a
   dec de
   dec bc

IF __CPU_8085__
   jp NK,loop
   inc bc
ELSE
   ld a,b
   or c
   jp NZ,loop
ENDIF

ELSE
   lddr
ENDIF
   
   pop de
   inc de
   
   pop hl
   ret
