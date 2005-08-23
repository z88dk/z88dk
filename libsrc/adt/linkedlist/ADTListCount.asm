; uint adt_ListCount(struct adt_List *list)
; 02.2003, 06.2005 aralbrec

XLIB ADTListCount

; Return # elements in list
;
; enter : HL = struct adt_List *
; exit  : HL = struct adt_list * + 1byte
;         DE = # items in list
; uses  : DE,HL

.ADTListCount
   ld e,(hl)
   inc hl
   ld d,(hl)
   ret
