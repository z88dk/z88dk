; int __CALLEE__ adt_ListPrepend_callee(struct adt_List *list, void *item)
; 02.2003, 06.2005 aralbrec

SECTION code_clib
PUBLIC adt_ListPrepend_callee
PUBLIC _adt_ListPrepend_callee
PUBLIC ASMDISP_ADT_LISTPREPEND_CALLEE
PUBLIC ASMDISP_ADT_LISTPREPEND2

EXTERN ADTemptylistadd
EXTERN _u_malloc

.adt_ListPrepend_callee
._adt_ListPrepend_callee

   pop hl
   pop bc
   pop de
   push hl

.asmentry

; enter: de = struct adt_List *
;        bc = item *
; exit : carry reset if fail (no memory) and hl = 0 else:
;        new item prepended to start of list, current points at new item, hl != 0
; uses : af, bc, de, hl

   push bc
   push de
   ld hl,6                ; sizeof(struct adt_ListNode)
   push hl
   call _u_malloc
   pop bc
   pop de
   pop bc
   ret nc                 ; alloc memory failed

   ld (hl),c
   inc hl
   ld (hl),b              ; store user item into new NODE
   inc hl                 ; hl = new NODE.next
   ex de,hl               ; hl = LIST*, de = new NODE.next

   ld a,(hl)
   inc (hl)               ; increase item count
   inc hl
   jp nz, noinchi
   inc (hl)
   jp cont
   
.noinchi

   or (hl)                ; hl = LIST.count+1, de = new NODE.next, list count & item done
   jp z, ADTemptylistadd  ; if there are no items in list jump to emptylistadd helper
   
.cont

   inc hl                 ; hl = LIST.state, de = new NODE.next, list count & item done

.ADTListPrepend2

   ld (hl),1              ; current INLIST
   inc hl
   dec de
   dec de                 ; de = new NODE
   push de                ; stack = new NODE
   ld (hl),d
   inc hl
   ld (hl),e              ; current = new NODE
   inc hl                 ; hl = head
   inc de
   inc de                 ; de = new NODE.next
   ldi
   ldi                    ; new NODE.next = head, hl = tail
   xor a
   ld (de),a
   inc de
   ld (de),a              ; new NODE.prev = NULL
   dec hl
   ld e,(hl)
   dec hl                 ; hl = head
   ld d,(hl)              ; de = old head NODE
   pop bc                 ; bc = new NODE
   ld (hl),b
   inc hl
   ld (hl),c              ; head = new NODE
   ex de,hl               ; hl = old head NODE
   inc hl
   inc hl
   inc hl
   inc hl                 ; hl = old head NODE.prev
   ld (hl),b
   inc hl
   ld (hl),c              ; old head NODE.prev = new NODE
   scf
   ret

DEFC ASMDISP_ADT_LISTPREPEND_CALLEE = # asmentry - adt_ListPrepend_callee
DEFC ASMDISP_ADT_LISTPREPEND2 = # ADTListPrepend2 - adt_ListPrepend_callee
