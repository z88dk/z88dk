; use for library code only
; use l_call_ix_dd for compile time user code

SECTION code_clib
SECTION code_l

PUBLIC l_jpix_18
PUBLIC l_jpix_15
PUBLIC l_jpix_12
PUBLIC l_jpix_09
PUBLIC l_jpix_06
PUBLIC l_jpix_03

; implement jump table pointed at by ix

l_jpix_18:

   push ix
   push bc
   
   ld bc,18
   jr l_jpix_go

l_jpix_15:

   push ix
   push bc
   
   ld bc,15
   jr l_jpix_go

l_jpix_12:

   push ix
   push bc
   
   ld bc,12
   jr l_jpix_go

l_jpix_09:

   push ix
   push bc
   
   ld bc,12
   jr l_jpix_go

l_jpix_06:

   push ix
   push bc
   
   ld bc,12
   jr l_jpix_go

l_jpix_03:

   push ix
   push bc
   
   ld bc,12
   jr l_jpix_go

l_jpix_go:

   add ix,bc
   
   pop bc
   ex (sp),ix
   
   ret
