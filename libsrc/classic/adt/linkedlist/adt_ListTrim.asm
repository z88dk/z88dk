; void __FASTCALL__ *adt_ListTrim(struct adt_List *list)
; 02.2003, 08.2005 aralbrec

SECTION code_clib
PUBLIC adt_ListTrim
PUBLIC _adt_ListTrim

EXTERN l_setmem
EXTERN _u_free

.adt_ListTrim
._adt_ListTrim

; enter: hl = struct adt_List *
; exit : no carry = list empty, hl = 0 else:
;        HL = item removed from list
;        last item removed from list and current points to new last item
; uses : af, bc, de, hl

   ld e,(hl)
   inc hl
   ld d,(hl)
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
   ex (sp),hl         ; hl = list, stack = item
   
   xor a
   call l_setmem-17   ; clear 9 bytes
   
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
   ld de,5
   add hl,de          ; hl = tail
   ld d,(hl)
   inc hl             ; hl = tail+1
   ld e,(hl)          ; de = tail NODE
   ex de,hl           ; hl = tail NODE, de = tail+1
   ld c,(hl)
   inc hl
   ld b,(hl)          ; bc = item
   push bc            ; save item
   ld bc,4
   add hl,bc          ; hl = tail NODE.prev+1
   ld c,(hl)
   dec hl
   ld b,(hl)          ; bc = prev NODE
   dec hl             ; hl = tail NODE.next+1
   ex de,hl           ; de = tail NODE.next+1, hl = tail+1
   ld (hl),c
   dec hl             ; hl = tail
   ld (hl),b          ; tail = prev NODE
   dec hl
   dec hl
   dec hl             ; hl = current+1
   ld (hl),c
   dec hl             ; hl = current
   ld (hl),b          ; current = prev NODE
   ld l,c
   ld h,b
   inc hl
   inc hl             ; hl = prev NODE.next
   ld (hl),0
   inc hl
   ld (hl),0          ; prev NODE.next = NULL
   dec de
   dec de
   dec de             ; de = tail NODE
   ex de,hl
   push hl
   call _u_free       ; free tail NODE
   pop hl
   pop hl             ; hl = item
   scf
   ret

.fail

   ex de,hl
   ret
