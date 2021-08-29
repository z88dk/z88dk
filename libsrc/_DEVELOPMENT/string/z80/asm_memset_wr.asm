
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
   ld de,hl

   ret Z

   push hl
   ld   e,a

IF __CPU_8085__
   dec bc
ENDIF

loop:
   ld (hl),e
   inc hl
   dec bc

IF __CPU_8085__
   jp NK,loop
   inc bc
ELSE
   ld a,b
   or c
   jp NZ,loop
ENDIF

   ex  de,hl
   pop hl
   ret

