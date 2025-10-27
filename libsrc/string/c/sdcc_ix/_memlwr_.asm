
; char *_memlwr_(void *p, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC __memlwr_

EXTERN asm__memlwr

__memlwr_:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
      
   jp asm__memlwr
