; void __CALLEE__ *ba_AddMem_callee(uchar q, uchar numblocks, uint size, void *addr)
; 05.2005 aralbrec

XLIB ba_AddMem_callee
LIB BAAddMem

.ba_AddMem_callee

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
