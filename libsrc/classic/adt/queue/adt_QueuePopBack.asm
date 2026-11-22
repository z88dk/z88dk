; void __FASTCALL__ *adt_QueuePopBack(struct adt_Queue *q)
; 11.2006 aralbrec

SECTION code_clib
PUBLIC adt_QueuePopBack
PUBLIC _adt_QueuePopBack
EXTERN _u_free

; enter: HL = struct adt_Queue *
; exit : HL = top item, item removed from queue
;           = 0 and carry reset if queue empty

.adt_QueuePopBack
._adt_QueuePopBack

   ld a,(hl)                 ; reduce count
   dec (hl)
   inc hl
   or a
   jp nz, nomoredec
   or (hl)
   jr z, fail
   dec (hl)

.nomoredec

   inc hl                    ; hl = &adt_Queue.front   
   ld e,l                    ; de = & lagger's next pointer
   ld d,h                    ;    = &adt_Queue.front to start with
   ld a,(hl)
   inc hl
   push hl                   ; stack = &adt_Queue.front + 1b
   ld h,(hl)
   ld l,a                    ; hl = & current adt_QueueNode to investigate
   
.loop                        ; find the second last item in the queue

   ; de = & lagger's next pointer
   ; hl = & current adt_QueueNode
   
   inc hl
   inc hl
   push hl                   ; save & current adt_QueueNode.next
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                    ; hl = & next adt_QueueNode to investigate

   or h                      ; if next is 0, we found the end of the list
   jr z, exitloop
   
   pop de                    ; otherwise lagger follows
   jp loop

.exitloop

   ; stack = &adt_Queue.front + 1b, & last adt_QueueNode.next
   ; de = & lagger adt_QueueNode.next
   
   pop hl
   ex (sp),hl                ; hl = &adt_Queue.front + 1b
   inc hl
   ld (hl),e                 ; store ptr to new last node into adt_Queue.back
   inc hl
   ld (hl),d
   
   xor a                     ; store 0 into the second last node's next pointer
   ld (de),a
   inc de
   ld (de),a

   pop hl                    ; hl = & last adt_QueueNode.next
   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)
   
   push de                   ; stack = last item
   push hl
   call _u_free              ; free last QueueNode container
   pop hl
   pop hl                    ; hl = item
   scf
   ret

.fail

   dec hl
   ld (hl),a
   ld l,a
   ld h,a
   ret
