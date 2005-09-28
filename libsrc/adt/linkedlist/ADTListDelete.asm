; void adt_ListDelete(struct adt_List *list, void *delete)
; /* void __FASTCALL__ (*delete)(void *item) */
; 02.2003, 06.2005 aralbrec

XLIB ADTListDelete
LIB l_jpix
XREF _u_free

; enter: HL = struct adt_List *
;        IX = delete with HL = item
; exit : The entire list is deleted.
;        (delete) is called once for each item in the list with
;          HL = item.
; uses : AF,BC,DE,HL

.ADTListDelete
   push hl               ; save list
   ld de,5
   add hl,de             ; hl = head

.while
   ld a,(hl)
   or a
   jr z, done
   inc hl
   ld l,(hl)
   ld h,a                ; hl = next NODE
   ld e,(hl)
   push hl               ; save NODE
   inc hl                ; hl = NODE.item+1
   ld d,(hl)             ; de = item
   ex de,hl
   call l_jpix           ; call itemfree with HL = item
   pop hl                ; hl = NODE
   push hl               ; save NODE
   call _u_free          ; free NODE container
   pop hl
   inc hl
   inc hl                ; hl = NODE.next
   jp while

.done
   pop hl                ; hl = list
   call _u_free          ; free list container
   ret
