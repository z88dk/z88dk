
; void insertion_sort_callee(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC __insertion_sort__callee, l0__insertion_sort__callee

EXTERN asm_insertion_sort

__insertion_sort__callee:

   pop af
   pop bc
   pop hl
   pop de
   exx
   pop bc
   push af

l0__insertion_sort__callee:

   push bc
   exx
      
   ex (sp),ix   
   
   call asm_insertion_sort
   
   pop ix
   ret
