
; ===============================================================
; Dec 2013 / Dec 2021 feilipu
; ===============================================================
; 
; void *memchr(const void *s, int c, size_t n)
;
; Return ptr to first occurrence of c among the first n chars of s.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_memchr
PUBLIC asm0_memchr

EXTERN error_zc

asm_memchr:

   ; enter :  a = char c
   ;         hl = char *s
   ;         bc = size_t n
   ;
   ; exit  : a = char c
   ;
   ;         char found
   ;
   ;            carry reset
   ;            hl = ptr to c
   ;
   ;         char not found
   ;
   ;            carry set
   ;            z flag set if n == 0
   ;            bc = 0
   ;            hl = 0
   ;
   ; uses  : f, bc, hl

   inc c
   dec c
   jr Z,test0

asm0_memchr:

IF __CPU_INTEL__ || __CPU_GBZ80__

   dec bc
   inc b
   inc c

loop:
   cp (hl)
   ret Z                       ; char found

   inc hl

   dec c
   jr NZ,loop
   dec b
   jr NZ,loop

ELSE
   cpir
   dec hl
   ret Z                       ; char found

ENDIF

notfound:
   jp error_zc

test0:
   inc b
   dec b
   jr NZ,asm0_memchr

   jr notfound
