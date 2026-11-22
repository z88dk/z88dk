; void __FASTCALL__ *adt_QueueCreateS(struct adt_Queue *q)
; 11.2006 aralbrec

SECTION code_clib
PUBLIC adt_QueueCreateS
PUBLIC _adt_QueueCreateS
EXTERN l_setmem

; initialize an adt_Queue
;
; hl = struct adt_Queue*

.adt_QueueCreateS
._adt_QueueCreateS

   xor a
   jp l_setmem-11
