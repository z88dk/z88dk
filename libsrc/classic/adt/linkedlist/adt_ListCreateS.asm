; void __FASTCALL__ adt_ListCreateS(struct adt_List *)
; 11.2006 aralbrec

SECTION code_clib
PUBLIC adt_ListCreateS
PUBLIC _adt_ListCreateS
EXTERN l_setmem

; initialize a struct adt_List

.adt_ListCreateS
._adt_ListCreateS

   xor a
   jp l_setmem-17
