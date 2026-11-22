
; ===============================================================
; Feb 2021 / Dec 2021 feilipu
; ===============================================================
; 
; void *memset_wr(void *s, int c, size_t n)
;
; Write c into the first n bytes of s.
;
; Only writes to memory, doesn't read.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_string

PUBLIC asm_memset_wr

asm_memset_wr:

   ;
   ; enter : hl = void *s
   ;          e = char c
   ;         bc = uint n
   ;
   ; exit  : hl = void *s
   ;         de = ptr in s to byte after last one written
   ;         bc = 0
   ;         carry reset
   ;
   ; uses  : af, bc, de

   ld a,b
   or c

   ld a,e
   ld de,hl

   ret Z

   push hl

   dec bc
   inc b
   inc c

loop:
   ld (hl+),a

   dec c
   jr NZ,loop
   dec b
   jr NZ,loop

   ex  de,hl
   pop hl
   ret

