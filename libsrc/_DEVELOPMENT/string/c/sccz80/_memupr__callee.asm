
; char *_memupr_(void *p, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _memupr__callee

EXTERN asm__memupr

_memupr__callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm__memupr
