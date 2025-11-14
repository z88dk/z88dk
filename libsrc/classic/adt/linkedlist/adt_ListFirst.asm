; void __FASTCALL__ *adt_ListFirst(struct adt_List *list)
; 02.2003, 06.2005 aralbrec

SECTION code_clib
PUBLIC adt_ListFirst
PUBLIC _adt_ListFirst

.adt_ListFirst
._adt_ListFirst

; enter: hl = struct adt_list *
; exit : hl = item at start of list
;        current pointer changed to point at first item in list, carry set
;        IF FAIL: carry reset, hl = 0
; uses : af, bc, de, hl

   ld a,(hl)
   inc hl
   or (hl)
   jr z, fail
   
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
   ld a,(hl)
   inc hl
   ld l,(hl)
   ld h,a                    ; hl = headnode
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                    ; hl = item
   
   scf
   ret

.fail

   ld l,a
   ld h,a
   ret
