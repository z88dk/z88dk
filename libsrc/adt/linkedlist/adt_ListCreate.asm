; struct adt_List *adt_ListCreate(void)
; 02.2003, 06.2005 aralbrec

XLIB adt_ListCreate
XREF _u_malloc

; Create List
;
; exit : HL = addr of struct adt_List
;           = 0 and carry reset if fail (no mem)
; used : AF,BC,DE,HL

.adt_ListCreate
   ld hl,9            ; sizeof(struct adt_List)
   push hl
   call _u_malloc     ; alloc memory, hl=0 & carry reset if fail
   pop bc
   ret nc

   push hl
   ld e,l
   ld d,h
   inc de
   ld (hl),0
   ld bc,8
   ldir
   pop hl
   scf
   ret
