; void __CALLEE__ adt_ListConcat_callee(struct adt_List *list1, struct adt_List *list2)
; 02.2003, 06.2005 aralbrec

SECTION code_clib
PUBLIC adt_ListConcat_callee
PUBLIC _adt_ListConcat_callee
PUBLIC ASMDISP_ADT_LISTCONCAT_CALLEE

EXTERN _u_free

.adt_ListConcat_callee
._adt_ListConcat_callee

   pop bc
   pop hl
   pop de
   push bc

.asmentry

; enter: hl = list2, de = list1
; exit : list1 = list1 concat list2, list2 is deleted
; uses : af, bc, de, hl

   push hl               ; stack = list2
   ld a,(hl)
   inc hl
   or (hl)
   jp z, list2nonempty

   ; list2 is empty, do nothing

   pop hl
   push hl
   call _u_free          ; free(list2)
   pop hl
   ret

.list2nonempty           ; stack = list2

   ex de,hl              ; de = list2.count+1, hl = list1
   ld a,(hl)
   inc hl
   or (hl)
   jp nz, list1nonempty

   ; list1 empty, copy list2

   dec de
   dec hl
   ex de,hl              ; hl = list2, de = list1
   ld bc,9
   ldir                  ; copy list2 into list1
   dec de
   dec de
   dec de
   ex de,hl              ; hl = list1.head+1
   ld e,(hl)
   dec hl
   ld d,(hl)             ; de = list1 head
   dec hl
   ld (hl),e
   dec hl
   ld (hl),d             ; list1.current = list1 head
   dec hl
   ld (hl),1             ; INLIST
   pop hl
   push hl
   call _u_free          ; free(list2)
   pop hl
   ret

   ; both lists nonempty

.list1nonempty           ; de = list2.count+1, hl = list1.count+1, stack = list2

   dec de
   dec hl
   ld a,(de)
   add a,(hl)
   ld (hl),a
   inc de
   inc hl
   ld a,(de)
   adc a,(hl)
   ld (hl),a             ; ** list1 count += list2 count
   inc hl                ; hl = list1.state
   inc de
   inc de
   inc de
   inc de                ; de = list2.head
   ld a,(hl)
   cp 2                  ; ** list1.state = AFTER?
   jp nz, list1notafter

   ld (hl),1             ; ** list1.state = INLIST
   inc hl
   ld a,(de)
   ld (hl),a
   inc de                ; de = list2.head+1
   inc hl                ; hl = list1.current+1
   ld a,(de)
   ld (hl),a             ; ** list1 current = list2 head
   dec de                ; de = list2.head
   inc hl
   inc hl
   inc hl                ; hl = list1.tail
   jp rejoin1

.list1notafter           ; de = list2.head, hl = list1.state

   ld bc,5
   add hl,de             ; hl = list1.tail
   
.rejoin1

   ld b,(hl)
   inc hl                ; hl = list1.tail+1
   ld c,(hl)             ; bc = list1 tail NODE
   inc bc
   inc bc                ; bc = list1 tail NODE.next
   ld a,(de)
   ld (bc),a
   inc de                ; de = list2.head+1
   inc bc
   ld a,(de)
   ld (bc),a             ; ** list1 tail NODE.next = list2 head NODE

   ex de,hl              ; hl = list2.head+1, de = list1.tail+1
   ld c,(hl)
   dec hl                ; hl = list2.head
   ld b,(hl)             ; bc = list2 head NODE
   inc bc
   inc bc
   inc bc
   inc bc
   inc bc                ; bc = list2 head NODE.prev+1
   ld a,(de)
   ld (bc),a
   dec bc
   dec de                ; de = list1.tail
   ld a,(de)
   ld (bc),a             ; ** list2 head NODE.prev = list1 tail NODE

   inc hl
   inc hl                ; hl = list2.tail
   ldi
   ldi                   ; ** list1 tail = list2 tail

   pop hl
   push hl
   call _u_free          ; free(list2)
   pop hl
   ret

DEFC ASMDISP_ADT_LISTCONCAT_CALLEE = # asmentry - adt_ListConcat_callee

