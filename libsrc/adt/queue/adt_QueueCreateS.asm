; void __FASTCALL__ *adt_QueueCreateS(struct adt_Queue *q)
; 11.2006 aralbrec

XLIB adt_QueueCreateS

; initialize an adt_Queue
;
; hl = struct adt_Queue*

.adt_QueueCreateS

   ld (hl),0
   ld e,l
   ld d,h
   inc de
   ld bc,5
   ldir
   ret
