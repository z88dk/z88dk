; void adt_ListFree(struct adt_List *list, void *free)
; /* void (*free)(void *item) */
; 02.2003, 06.2005 aralbrec

XLIB ADTListFree
LIB l_jpix
XREF _u_free

; enter: HL = struct adt_List *
;        IX = free
; exit : The entire list is deleted.
;        (free) is called once for each item in the list with
;          HL = item.
; uses : AF,BC,DE,HL

.ADTListFree
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
