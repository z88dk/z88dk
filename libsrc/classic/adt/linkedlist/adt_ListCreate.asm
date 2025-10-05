; struct adt_List *adt_ListCreate(void)
; 02.2003, 06.2005 aralbrec

SECTION code_clib
PUBLIC adt_ListCreate
PUBLIC _adt_ListCreate

EXTERN l_setmem
EXTERN _u_malloc

; Create List
;
; exit : HL = addr of struct adt_List
;           = 0 and carry reset if fail (no mem)
; used : AF,BC,DE,HL

.adt_ListCreate
._adt_ListCreate

   ld hl,9            ; sizeof(struct adt_List)
   push hl
   call _u_malloc     ; alloc memory, hl=0 & carry reset if fail
   pop bc
   ret nc

   ld e,l
   ld d,h
   ld a,0
   call l_setmem-17   ; clear 9 bytes
   ex de,hl
   ret
