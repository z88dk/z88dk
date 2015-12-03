
; char *_memlwr_(void *p, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _memlwr__callee

EXTERN asm__memlwr

_memlwr__callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm__memlwr
