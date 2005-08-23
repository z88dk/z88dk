; void *adt_ListFirst(struct adt_List *list)
; 02.2003, 06.2005 aralbrec

XLIB ADTListFirst

; enter: HL = struct adt_list *
; exit : DE = item at start of list
;        current pointer changed to point at first item in list
;        IF FAIL: carry reset
; uses : AF,BC,DE,HL

.ADTListFirst
   ld a,(hl)
   inc hl
   or (hl)
   ret z
   inc hl
   ld (hl),1                 ; list ptr is inlist
   inc hl
   ld e,l
   ld d,h                    ; de = list.current
   inc hl
   inc hl                    ; hl = list.head
   ldi
   ldi                       ; list.current = list.head
   ex de,hl                  ; hl = list.head
   ld d,(hl)
   inc hl
   ld e,(hl)
   ex de,hl                  ; hl = headnode
   ld e,(hl)
   inc hl
   ld d,(hl)                 ; de = item
   scf
   ret
