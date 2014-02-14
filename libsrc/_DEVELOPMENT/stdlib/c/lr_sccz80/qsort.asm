
; void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

XLIB qsort

LIB asm_qsort

qsort:

   pop af
   pop ix
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push ix
   push af
   
   jp asm_qsort
