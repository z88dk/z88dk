; void __FASTCALL__ adt_StackCreateS(struct adt_Stack *s)
; 11.2006 aralbrec

SECTION code_clib
PUBLIC adt_StackCreateS
PUBLIC _adt_StackCreateS
EXTERN l_setmem

; initialize an adt_Stack*

.adt_StackCreateS
._adt_StackCreateS

   xor a
   jp l_setmem-7
