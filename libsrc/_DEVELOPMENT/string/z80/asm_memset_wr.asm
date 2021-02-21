
; ===============================================================
; Feb 2021
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
   ld e,l
   ld d,h

   ret z

   push hl
   ld   e,a
loop:
   ld (hl),e
   inc hl
   dec bc
   ld  a,b
   or  c
   jr  nz,loop
   ex  de,hl
   pop hl
   ret


