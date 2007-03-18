; void __FASTCALL__ *adt_QueueCreateS(struct adt_Queue *q)
; 11.2006 aralbrec

XLIB adt_QueueCreateS
LIB l_setmem

; initialize an adt_Queue
;
; hl = struct adt_Queue*

.adt_QueueCreateS

   xor a
   jp l_setmem-11
