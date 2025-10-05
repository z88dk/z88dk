; void __FASTCALL__ *adt_ListRemove(struct adt_List *list)
; 02.2003, 06.2005 aralbrec

SECTION code_clib
PUBLIC adt_ListRemove
PUBLIC _adt_ListRemove
EXTERN _u_free

.adt_ListRemove
._adt_ListRemove

; enter: hl = struct adt_list *
; exit : no carry = list empty or current is not INLIST and hl = 0 else:
;        hl = item removed
;        remove current item from list, current moves to next item
; uses : af, bc, de, hl

   ld a,(hl)           ; decrease list count
   dec (hl)
   inc hl
   or a
   jr nz, nomoredec
   
   or (hl)
   jr z, fail          ; list has zero items
   dec (hl)

.nomoredec

   inc hl
   inc hl              ; hl = current

   ld d,(hl)
   inc hl              ; hl = current + 1
   ld e,(hl)           ; de = current NODE
   push de             ; stack = current NODE
   ex de,hl            ; hl = current NODE, de = current+1
   ld c,(hl)
   inc hl
   ld b,(hl)           ; bc = item
   push bc             ; stack = current NODE, item
   inc hl              ; hl = current NODE.next
   ld b,(hl)
   inc hl
   ld c,(hl)           ; bc = next NODE after current NODE
   inc hl              ; hl = current NODE.prev
   ex de,hl            ; de = current NODE.prev, hl = current+1
   ld (hl),c
   dec hl              ; hl = current
   ld (hl),b           ; ** current = next NODE
   push hl             ; stack = current NODE, item, current
   ld a,b
   or a
   jr z, nonext        ; if there is no next NODE

   ; there is a next node
   ; hl = current, bc = next NODE, de = current NODE.prev

   ld hl,5
   add hl,bc           ; hl = next NODE.prev + 1
   ex de,hl            ; de = next NODE.prev + 1, hl = current NODE.prev
   ld b,(hl)
   inc hl              ; hl = current NODE.prev + 1
   ld c,(hl)           ; bc = prev NODE
   ex de,hl            ; de = current NODE.prev+1, hl = next NODE.prev+1
   ld (hl),c
   dec hl              ; hl = next NODE.prev
   ld (hl),b           ; ** next NODE.prev = prev NODE
   ld de,-4
   add hl,de           ; hl = next NODE, bc = prev NODE

.rejoin1

   ld a,b
   or a
   jr z, noprev

   ; there is a previous node
   ; hl = next NODE, bc = prev NODE

   inc bc
   inc bc              ; bc = prev NODE.next
   ld a,h
   ld (bc),a
   inc bc
   ld a,l
   ld (bc),a           ; ** prev NODE.next = next NODE

   pop hl              ; pop current
   
.rejoin2

   pop hl              ; pop item
   ex (sp),hl          ; stack = item, hl = freed NODE container
   push hl
   call _u_free        ; free(hl)
   pop hl
   pop hl              ; pop item
   scf
   ret

   ; removing first node in list

.noprev                ; hl = next NODE, bc = prev NODE

   pop de
   ex de,hl            ; de = next NODE, hl = current
   dec hl
   ld a,d
   or a                ; if next NODE == NULL, list is emptying, make BEFORE
   jr z, okaynext
   ld a,1              ; INLIST
   
.okaynext

   ld (hl),a           ; state = INLIST or BEFORE
   inc hl
   inc hl
   inc hl              ; hl = head
   ld (hl),d
   inc hl
   ld (hl),e           ; ** head = next NODE
   jp rejoin2

   ; removing last node in list

.nonext                ; hl = current, de = current NODE.prev

   dec hl
   ld (hl),2           ; current now points after end of list, state = AFTER
   ld bc,5
   add hl,bc           ; hl = tail
   ex de,hl            ; de = tail, hl = current NODE.prev
   ld b,(hl)
   inc hl
   ld c,(hl)           ; bc = prev NODE
   ex de,hl            ; hl = tail
   ld (hl),b
   inc hl
   ld (hl),c           ; ** tail = prev NODE
   ld hl,0             ; hl = next NODE = NULL, bc = prev NODE
   jp rejoin1

.fail

   dec hl
   ld (hl),a
   ld h,a
   ld l,a
   ret
