; void __CALLEE__ *ba_AddMem_callee(uchar q, uchar numblocks, uint size, void *addr)
; 05.2005 aralbrec

SECTION code_clib
PUBLIC ba_AddMem_callee
PUBLIC _ba_AddMem_callee
EXTERN BAAddMem

.ba_AddMem_callee
._ba_AddMem_callee

   pop af
   pop hl
   pop de
   pop bc
   ex (sp),hl
   ld b,c
   ld c,l
   pop hl
   push af
   
   jp BAAddMem
