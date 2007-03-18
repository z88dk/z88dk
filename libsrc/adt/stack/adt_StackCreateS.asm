; void __FASTCALL__ adt_StackCreateS(struct adt_Stack *s)
; 11.2006 aralbrec

XLIB adt_StackCreateS
LIB l_setmem

; initialize an adt_Stack*

.adt_StackCreateS

   xor a
   jp l_setmem-7
