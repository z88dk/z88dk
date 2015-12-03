
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
   ; uses  : af, bc, hl
   
   ld bc,0
   cpir
   dec hl
   ret
