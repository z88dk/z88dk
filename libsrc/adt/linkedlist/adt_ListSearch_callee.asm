; void __CALLEE__ *adt_ListSearch_callee(struct adt_List *list, void *match, void *item1)
; 02.2003, 08.2005 aralbrec

SECTION code_clib
PUBLIC adt_ListSearch_callee
PUBLIC _adt_ListSearch_callee
PUBLIC ASMDISP_ADT_LISTSEARCH_CALLEE

EXTERN ADTListSearch, l_jpiy

.adt_ListSearch_callee
._adt_ListSearch_callee

   pop hl
   pop de
   pop iy
   ex (sp),hl

.asmentry

; enter: hl = struct adt_List *
;        de = item1 *
;        iy = void (*match)(DE = void *item1, BC = void *item2)  -- MUST PRESERVE BC,DE,IX,HL
;             sets carry if equal
; exit : no carry = item not found, current points past end of list, hl = 0
;        else  hl = item found, current points at found item
; uses : af, bc, de, hl
   push ix    ;save callers ix
   ld ix,compare
   call ADTListSearch
   pop  ix
   ld l,c
   ld h,b
   ret c
   ld hl,0
   ret

.compare

   push hl
   push de
   push bc
   call l_jpiy
   ld a,l
   pop bc
   pop de
   pop hl
   or a
   ret nz
   scf
   ret

DEFC ASMDISP_ADT_LISTSEARCH_CALLEE = # asmentry - adt_ListSearch_callee
