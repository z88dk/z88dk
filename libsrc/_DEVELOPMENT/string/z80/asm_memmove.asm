
; ===============================================================
; Dec 2013 / Dec 2021 feilipu
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
   jp Z,asm1_memcpy
   
   ; Because of the possibility of overlap between
   ; dst and src, we have two scenarios:
   ;
   ; 1 - (dst<src) in which case must ldir
   ; 2 - (dst>src) in which case must lddr from end

   ; 8-bit compares faster most of the time

   ld a,d
   cp h
   jp C,asm0_memcpy
   jr NZ,use_lddr

   ld a,e
   cp l
   jp C,asm0_memcpy

   jp Z,asm1_memcpy           ; if dst == src, do nothing

use_lddr:
   push de
   dec bc

   add hl,bc
   ex de,hl
   add hl,bc
   ex de,hl

   push de

IF __CPU_INTEL__ || __CPU_GBZ80__

   inc b
   inc c

loop:
   ld a,(hl-)
   ld (de-),a

   dec c
   jr NZ,loop
   dec b
   jr NZ,loop

ELSE

   inc bc
   lddr

ENDIF

   pop de
   inc de

   pop hl
   ret

