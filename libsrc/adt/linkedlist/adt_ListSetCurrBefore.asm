; void __FASTCALL__ adt_ListSetCurrBefore(struct adt_List *list)
; 11.2006 aralbrec

PUBLIC adt_ListSetCurrBefore
EXTERN l_setmem

; enter: HL = struct adt_List*

.adt_ListSetCurrBefore

   inc hl
   inc hl
   xor a
   jp l_setmem-5           ; state = AFTER, current ptr = 0
