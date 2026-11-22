; use for compile time user code
; the library entries l_jpix / l_jpiy can have IX/IY swapped

SECTION code_clib
SECTION code_l

PUBLIC l_call_ix_18
PUBLIC l_call_ix_15
PUBLIC l_call_ix_12
PUBLIC l_call_ix_09
PUBLIC l_call_ix_06
PUBLIC l_call_ix_03

; implement jump table pointed at by ix

IF __SDCC_IY

l_call_ix_18:

   push iy
   push bc
   
   ld bc,18
   jr l_call_ix_go

l_call_ix_15:

   push iy
   push bc
   
   ld bc,15
   jr l_call_ix_go

l_call_ix_12:

   push iy
   push bc
   
   ld bc,12
   jr l_call_ix_go

l_call_ix_09:

   push iy
   push bc
   
   ld bc,12
   jr l_call_ix_go

l_call_ix_06:

   push iy
   push bc
   
   ld bc,12
   jr l_call_ix_go

l_call_ix_03:

   push iy
   push bc
   
   ld bc,12
   jr l_call_ix_go

l_call_ix_go:

   add iy,bc
   
   pop bc
   ex (sp),iy
   
   ret

ELSE

l_call_ix_18:

   push ix
   push bc
   
   ld bc,18
   jr l_call_ix_go

l_call_ix_15:

   push ix
   push bc
   
   ld bc,15
   jr l_call_ix_go

l_call_ix_12:

   push ix
   push bc
   
   ld bc,12
   jr l_call_ix_go

l_call_ix_09:

   push ix
   push bc
   
   ld bc,12
   jr l_call_ix_go

l_call_ix_06:

   push ix
   push bc
   
   ld bc,12
   jr l_call_ix_go

l_call_ix_03:

   push ix
   push bc
   
   ld bc,12
   jr l_call_ix_go

l_call_ix_go:

   add ix,bc
   
   pop bc
   ex (sp),ix
   
   ret

ENDIF
