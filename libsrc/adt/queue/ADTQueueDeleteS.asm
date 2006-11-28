; void adt_QueueDeleteS(struct adt_Queue *q, void *delete)
; 09.2005 aralbrec

XLIB ADTQueueDeleteS
LIB l_jpix
XREF _u_free

; free all items in queue but not adt_Queue struct itself
;
; enter: HL = struct adt_Queue *
;        IX = delete function (HL = user item)

.ADTQueueDeleteS

   inc hl
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
.loop                           ; hl = QueueNode to delete
   ld a,h
   or l
   ret z

   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   push hl                      ; stack = QueueNode.next
   ex de,hl                     ; hl = user item
   push hl
   call l_jpix                  ; delete(user item)
   pop hl
   pop hl
   ld e,(hl)
   inc hl
   ld d,(hl)                    ; de = next QueueNode
   dec hl
   dec hl
   dec hl
   push de
   push hl
   call _u_free                 ; free QueueNode container
   pop hl
   pop hl                       ; hl = next QueueNode
   jp loop

