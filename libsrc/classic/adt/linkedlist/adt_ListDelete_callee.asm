; void __CALLEE__ adt_ListDelete_callee(struct adt_List *list, void *delete)
; /* void __FASTCALL__ (*delete)(void *item) */
; 02.2003, 06.2005 aralbrec

SECTION code_clib
PUBLIC adt_ListDelete_callee
PUBLIC _adt_ListDelete_callee
PUBLIC asm_adt_ListDelete

EXTERN asm_adt_ListDeleteS

EXTERN _u_free

.adt_ListDelete_callee
._adt_ListDelete_callee

   pop bc
   pop de
   pop hl
   push bc
   
.asm_adt_ListDelete

; enter: hl = struct adt_List *
;        de = delete with HL = item
; exit : All items in list deleted but not adt_List struct itself
;        (delete) is called once for each item in the list with
;          HL = item and stack=item
; note : not multi-thread safe
; uses : af, bc, de, hl, ix

   push hl
   call asm_adt_ListDeleteS
   pop hl
   
   push hl
   call _u_free
   pop hl
   ret
      
