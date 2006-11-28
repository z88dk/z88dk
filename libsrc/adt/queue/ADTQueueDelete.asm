; void adt_QueueDelete(struct adt_Queue *q, void *delete)
; 09.2005 aralbrec

XLIB ADTQueueDelete
LIB ADTQueueDeleteS
XREF _u_free

; enter: HL = struct adt_Queue *
;        IX = delete function (HL = user item)

.ADTQueueDelete
   push hl
   call ADTQueueDeleteS
   pop hl
   push hl
   call _u_free                 ; free struct adt_Queue container
   pop hl
   pop hl
   ret
