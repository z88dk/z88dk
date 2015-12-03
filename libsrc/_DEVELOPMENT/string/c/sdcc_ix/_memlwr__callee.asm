
; char *_memlwr__callee(void *p, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC __memlwr__callee

EXTERN asm__memlwr

__memlwr_:

   pop af
   pop hl
   pop bc
   push af
      
   jp asm__memlwr
