; uint __FASTCALL__ adt_ListCount(struct adt_List *list)
; 02.2003, 06.2005 aralbrec

PUBLIC adt_ListCount

; Return # elements in list
;
; enter : HL = struct adt_List *
; exit  : HL = # items in list
; uses  : DE,HL

.adt_ListCount

   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl
   ret
