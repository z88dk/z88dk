
; BSD
; void bzero(void *mem, int bytes)

SECTION code_clib
SECTION code_string

PUBLIC asm_bzero

EXTERN asm_memset

asm_bzero:

   ; enter : hl = void *mem
   ;         bc = int bytes
   ;
   ; exit  : hl = void *s
   ;         de = ptr in s to byte after last one written
   ;         bc = 0
   ;         carry reset
   ;
   ; uses  : af, bc, de

   ld e,0
   jp asm_memset
