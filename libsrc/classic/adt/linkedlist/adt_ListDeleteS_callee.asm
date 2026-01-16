; void __CALLEE__ adt_ListDeleteS_callee(struct adt_List *list, void *delete)
; /* void __FASTCALL__ (*delete)(void *item) */
; 02.2003, 06.2005 aralbrec

SECTION code_clib
PUBLIC adt_ListDeleteS_callee
PUBLIC _adt_ListDeleteS_callee
PUBLIC asm_adt_ListDeleteS

EXTERN l_jpix
EXTERN _u_free

.adt_ListDeleteS_callee
._adt_ListDeleteS_callee

   pop bc
   pop de
   pop hl
   push bc

.asm_adt_ListDeleteS

; enter: hl = struct adt_List *
;        de = delete with HL = item
; exit : All items in list deleted but not adt_List struct itself
;        (delete) is called once for each item in the list with
;          HL = item and stack=item
; note : not multi-thread safe
; uses : af, bc, de, hl, ix

   push ix	;preserve callers ix
   ld a,d
   or e
   jr nz, deletenotnull
   ld de,justret

.deletenotnull
IF __CPU_RABBIT__ | __CPU_Z180__ | __CPU_KC160__
   push de
   pop  ix
ELSE
   ld ixl,e
   ld ixh,d
ENDIF

   ld de,5
   add hl,de             ; hl = head

.while

   ld a,(hl)
   or a
   jr z,exit
   
   inc hl
   ld l,(hl)
   ld h,a                ; hl = next NODE
   
   ld e,(hl)
   push hl               ; save NODE
   inc hl                ; hl = NODE.item+1
   ld d,(hl)             ; de = item
   ex de,hl
   push hl
   call l_jpix           ; call itemfree with HL = item
   pop hl
   pop hl                ; hl = NODE
   
   push hl               ; save NODE
   call _u_free          ; free NODE container
   pop hl
   inc hl
   inc hl                ; hl = NODE.next
   
   jp while

.exit
   pop ix

.justret

   ret

