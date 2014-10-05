
; char *_memlwr_(void *p, size_t n)

SECTION seg_code_string

PUBLIC _memlwr_

EXTERN asm__memlwr

_memlwr_:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm__memlwr
