; void __FASTCALL__ *adt_ListCurr(struct adt_List *list)
; 02.2003, 06.2005 aralbrec

SECTION code_clib
PUBLIC adt_ListCurr
PUBLIC _adt_ListCurr

.adt_ListCurr
._adt_ListCurr

; enter: hl = struct adt_List *
; exit : no carry = list empty or current points outside list, else:
;        hl = current item in list and carry set
; uses : af, hl

   ld a,(hl)
   inc hl
   or (hl)
   jr z, nothing             ; zero items in list
   
   inc hl
   ld a,(hl)
   dec a
   jr nz, nothing            ; current ptr not INLIST
   
   inc hl
   ld a,(hl)
   inc hl
   ld l,(hl)
   ld h,a                    ; hl = current adt_ListNode
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                    ; hl = item
   
   scf
   ret

.nothing

   ld hl,0
   ret
