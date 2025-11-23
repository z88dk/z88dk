; void __FASTCALL__ *adt_ListPopFront(struct adt_List *list)
; 11.2006 aralbrec

SECTION code_clib
PUBLIC adt_ListPopFront
PUBLIC _adt_ListPopFront

EXTERN l_setmem
EXTERN _u_free

.adt_ListPopFront
._adt_ListPopFront

; enter: hl = struct adt_List *
; exit : no carry indicates list empty, hl = 0 else:
;        hl = item removed from list
;        last item removed from list and current points to new last item
; uses : af, bc, de, hl

   ld e,(hl)
   inc hl
   ld d,(hl)          ; de = count
   dec hl             ; hl = list
   ld a,d
   or e
   jr z, fail         ; fail if list empty
   dec de             ; count = count - 1
   ld a,d
   or e
   jp nz, morethanone

   ; getting rid of only item in list

   push hl            ; save list
   ld de,5
   add hl,de          ; hl = head
   ld d,(hl)
   inc hl
   ld e,(hl)          ; de = NODE
   ex de,hl           ; hl = NODE
   ld e,(hl)
   inc hl
   ld d,(hl)          ; de = item
   push de            ; save item
   dec hl
   push hl
   call _u_free       ; free NODE
   pop hl
   pop hl
   ex (sp),hl          ; hl = list, stack = item
   xor a
   call l_setmem-17
   pop hl             ; hl = item
   scf
   ret

   ; more than one item in list

.morethanone          ; hl = list, de = new count

   ld (hl),e
   inc hl
   ld (hl),d          ; count--
   inc hl
   ld (hl),1          ; state = INLIST
   inc hl
   inc hl
   inc hl             ; hl = head
   ld d,(hl)
   inc hl             ; hl = head+1
   ld e,(hl)          ; de = head NODE
   ex de,hl           ; hl = head NODE, de = head+1
   ld c,(hl)
   inc hl
   ld b,(hl)          ; bc = item
   push bc            ; save item
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)          ; bc = next NODE
   ex de,hl           ; hl = head+1, de = head NODE.next+1
   ld (hl),c
   dec hl
   ld (hl),b          ; new head ptr = next NODE
   dec hl
   ld (hl),c
   dec hl
   ld (hl),b          ; new curr ptr = next NODE
   ld hl,4
   add hl,bc          ; hl = next NODE.prev
   ld (hl),0
   inc hl
   ld (hl),0          ; next NODE.prev = 0
   ld hl,-3
   add hl,de          ; hl = NODE to delete
   push hl
   call _u_free       ; free the NODE
   pop hl
   pop hl             ; hl = front item
   scf
   ret

.fail

   ex de,hl
   ret
