; int adt_ListAppend_callee(struct adt_List *list, void *item)
; 02.2003, 06.2005 aralbrec

SECTION code_clib
PUBLIC adt_ListAppend_callee
PUBLIC _adt_ListAppend_callee
PUBLIC ASMDISP_ADT_LISTAPPEND_CALLEE
PUBLIC ASMDISP_ADT_LISTAPPEND2

EXTERN ADTemptylistadd
EXTERN _u_malloc

.adt_ListAppend_callee
._adt_ListAppend_callee

   pop hl
   pop bc
   pop de
   push hl

.asmentry

   ; enter: DE = struct adt_List *
   ;        BC = item *
   ; exit : carry reset if fail (no memory) and hl=0 else:
   ;        new item appended to end of list, current points at new item and hl!=0
   ; uses : AF,BC,DE,HL

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

   or (hl)                 ; hl = LIST.count+1, de = new NODE.next, list count & item done
   jp z, ADTemptylistadd   ; if there are no items in list jump to emptylistadd helper
   
.cont

   inc hl                 ; hl = LIST.state, de = new NODE.next, list count & item done

.ADTListAppend2

   ld (hl),1              ; current INLIST
   inc hl
   dec de
   dec de                 ; de = new NODE
   push de                ; stack = new NODE
   ld (hl),d
   inc hl
   ld (hl),e              ; current = new NODE
   inc hl
   inc hl
   inc hl                 ; hl = tail
   inc de
   inc de                 ; de = new NODE.next
   xor a
   ld (de),a
   inc de
   ld (de),a              ; new NODE.next = NULL
   inc de                 ; de = new NODE.prev
   ldi
   ldi                    ; new NODE.prev = tail
   dec hl
   ld e,(hl)
   dec hl                 ; hl = tail
   ld d,(hl)              ; de = old tail NODE
   pop bc                 ; bc = new NODE
   ld (hl),b
   inc hl
   ld (hl),c              ; tail = new NODE
   ex de,hl               ; hl = old tail NODE
   inc hl
   inc hl                 ; hl = old tail NODE.next
   ld (hl),b
   inc hl
   ld (hl),c              ; old tail NODE.next = new NODE
   scf
   ret

DEFC ASMDISP_ADT_LISTAPPEND_CALLEE = # asmentry - adt_ListAppend_callee
DEFC ASMDISP_ADT_LISTAPPEND2 = # ADTListAppend2 - adt_ListAppend_callee

