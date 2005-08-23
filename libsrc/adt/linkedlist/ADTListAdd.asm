; int adt_ListAdd(struct adt_List *list, void *item)
; 02.2003, 06.2005 aralbrec

XLIB ADTListAdd
LIB ADTListPrepend, ADTListAppend, ADTemptylistadd
XREF ADTListPrepend2, ADTListAppend2, _u_malloc
defw ADTListPrepend, ADTListAppend

; enter: DE = struct adt_List *
;        BC = item *
; exit : carry reset if fail (no memory) else:
;        new item inserted after current, current points at new item
; uses : AF,BC,DE,HL

.ADTListAdd
   push de
   push bc
   ld hl,6                ; sizeof(struct adt_ListNode)
   call _u_malloc
   pop bc
   pop de
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
   ld a,(hl)
   or a
   jp z, ADTListPrepend2  ; if current points before start of list
   dec a
   jp nz, ADTListAppend2  ; if current points past end of list
   inc hl                 ; hl = LIST.current

   ; adding into non-empty list -- insert after current item
   ; hl = LIST.current, de = new NODE.next

   push hl                ; save LIST.current, de = new NODE.next
   ld a,(hl)
   inc hl
   ld l,(hl)
   ld h,a                 ; hl = current NODE
   inc hl
   inc hl                 ; hl = current NODE.next
   ldi
   ldi                    ; copy current NODE.next into new NODE.next
   dec hl                 ; hl = current NODE.next + 1
   push de                ; stack = LIST.current, new NODE.prev
   dec de
   dec de
   dec de
   dec de                 ; de = new NODE
   ld (hl),e
   dec hl                 ; hl = current NODE.next
   ld (hl),d              ; current NODE.next = new NODE
   dec hl
   dec hl                 ; hl = current NODE
   ex de,hl               ; de = current NODE, hl = new NODE
   ex (sp),hl             ; hl = new NODE.prev, stack = LIST.current, new NODE
   ld (hl),d
   inc hl                 ; hl = new NODE.prev + 1
   ld (hl),e              ; new NODE.prev = current NODE
   dec hl
   dec hl                 ; hl = new NODE.next + 1
   ld e,(hl)
   dec hl
   ld d,(hl)              ; de = next NODE, hl = new NODE.next
   ld a,d
   or a
   jr z, newtail          ; if there is no next node, this is the new tail of the list
   ld hl,4
   add hl,de              ; hl = next NODE.prev
   pop de                 ; de = new NODE
   ld (hl),d
   inc hl
   ld (hl),e              ; next NODE.prev = new NODE

   pop hl                 ; hl = LIST.current
   ld (hl),d
   inc hl
   ld (hl),e              ; current = new NODE
   scf
   ret

.newtail                  ; hl = new NODE.next, stack = LIST.current, new NODE
   pop de                 ; de = new NODE
   pop hl                 ; hl = LIST.current
   ld (hl),d
   inc hl
   ld (hl),e              ; current = new NODE
   inc hl
   inc hl
   inc hl
   ld (hl),d
   inc hl
   ld (hl),e              ; tail = new NODE
   scf
   ret
