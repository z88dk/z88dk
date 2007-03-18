; struct adt_Stack *adt_StackCreate(void)
; 09.2005, 11.2006 aralbrec

XLIB adt_StackCreate

LIB l_setmem
XREF _u_malloc

; create an empty stack
;
; exit : if fail HL = 0 and carry reset
;        if successful HL = new stack handle and carry set

.adt_StackCreate

   ld hl,4                     ; sizeof(struct adt_Stack)
   push hl
   call _u_malloc
   pop de
   ret nc                      ; mem alloc failed, hl = 0
   
   ld e,l
   ld d,h
   xor a
   call l_setmem-7
   ex de,hl
   scf
   ret
