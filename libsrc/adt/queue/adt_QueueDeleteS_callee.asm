; void __CALLEE__ adt_QueueDeleteS_callee(struct adt_Queue *q, void *delete)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC adt_QueueDeleteS_callee
PUBLIC _adt_QueueDeleteS_callee
PUBLIC ASMDISP_ADT_QUEUEDELETES_CALLEE

EXTERN l_jpix
EXTERN _u_free

.adt_QueueDeleteS_callee
._adt_QueueDeleteS_callee

   pop hl
   pop de
   ex (sp),hl

.asmentry
   push  ix		;save callers ix

; free all items in queue but not adt_Queue struct itself
;
; enter: HL = struct adt_Queue *
;        DE = delete function (HL = user item)

   ld a,d
   or e
   jr nz, notzero
   ld de, justret

.notzero

   ld ixl,e
   ld ixh,d                     ; ix = delete function
   
   inc hl
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
.loop                           ; hl = QueueNode to delete

   ld a,h
   or l
   jr  z,exit

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

.exit
   pop ix
.justret

   ret

DEFC ASMDISP_ADT_QUEUEDELETES_CALLEE = # asmentry - adt_QueueDeleteS_callee
