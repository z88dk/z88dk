; int __CALLEE__ adt_ListInsert_callee(struct adt_List *list, void *item)
; 08.2005 aralbrec

SECTION code_clib
PUBLIC adt_ListInsert_callee
PUBLIC asm_adt_ListInsert

EXTERN asm_adt_ListPrepend2
EXTERN asm_adt_ListAppend2


EXTERN ADTemptylistadd
EXTERN _u_malloc

.adt_ListInsert_callee
._adt_ListInsert_callee

   pop hl
   pop bc
   pop de
   push hl

.asm_adt_ListInsert

; enter: de = struct adt_List *
;        bc = item *
; exit : carry reset if fail and hl = 0 (no memory) else:
;        new item inserted before current, current points at new item, carry set, hl!=0
; uses : af, bc, de, hl

   push de
   push bc
   ld hl,6                ; sizeof(struct adt_ListNode)
   push hl
   call _u_malloc
   pop bc
   pop bc
   pop de
   ret nc                 ; alloc memory failed

   ld (hl),c
   inc hl
   ld (hl),b              ; store item into new NODE
   inc hl
   ex de,hl               ; de = new NODE.next, hl = list

   ld a,(hl)
   inc (hl)               ; increase item count
   inc hl
   jp nz, noinchi
   inc (hl)
   jp cont
   
.noinchi

   or (hl)                ; hl = list.count+1, de = new NODE.next, list count & item done
   jp z, ADTemptylistadd  ; if there are no items in list, use empty list helper

.cont

   inc hl                 ; hl = list.state, de = new NODE.next, list count & item done
   ld a,(hl)
   or a
   jp z, asm_adt_ListPrepend2  ; if current points before start of list
   dec a
   jp nz, asm_adt_ListAppend2  ; if current points past end of list
   inc hl                 ; hl = list.current

   ; inserting into non-empty list -- insert before current item
   ; hl = list.current, de = new NODE.next

   push hl                ; stack = list.current, de = new NODE.next
   ld a,(hl)
   inc hl
   ld l,(hl)
   ld h,a                 ; hl = current NODE
   ex de,hl               ; de = current NODE, hl = new NODE.next
   ld (hl),d
   inc hl
   ld (hl),e              ; new NODE.next = current NODE
   inc hl                 ; hl = new NODE.prev
   ex de,hl               ; de = new NODE.prev, hl = current NODE
   ld bc,4
   add hl,bc              ; hl = current.prev
   ld a,(hl)              ; a == 0 if no prev
   ldi
   ldi                    ; new NODE.prev = current.prev
   dec hl                 ; hl = current.prev+1
   ld c,(hl)              ; ac = prev NODE
   dec de
   dec de
   dec de
   dec de
   dec de
   dec de                 ; de = new NODE
   ld (hl),e
   dec hl
   ld (hl),d              ; current.prev = new NODE
   or a                   ; de = new NODE, ac = prev NODE, stack = list.current
   jr z, newhead

   ld l,c
   ld h,a
   inc hl
   inc hl                 ; hl = prev NODE.next
   ld (hl),d
   inc hl
   ld (hl),e              ; prev NODE.next = new NODE
   pop hl                 ; hl = list.current
   ld (hl),d
   inc hl
   ld (hl),e              ; list.current = new NODE
   scf
   ret

.newhead
   pop hl                 ; hl = list.current
   ld (hl),d
   inc hl
   ld (hl),e              ; list.current = new NODE
   inc hl
   ld (hl),d
   inc hl
   ld (hl),e              ; list.head = new NODE
   scf
   ret
