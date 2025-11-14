
SECTION code_clib
PUBLIC ADThcompare
EXTERN l_jpiy

.ADThcompare

   push bc
   push de
   push hl
   call l_jpiy
   rl l
   pop hl
   pop de
   pop bc
   ret
