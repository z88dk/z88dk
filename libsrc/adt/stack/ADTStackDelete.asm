; void adt_StackDelete(struct adt_Stack **s, void *delete)
; 09.2005 aralbrec

XLIB ADTStackDelete
LIB l_jpix
XREF _u_free

; enter: HL = struct adt_Stack **
;        IX = void (*delete)(void *item) with HL,stack=item

.ADTStackDelete
   ld e,(hl)
   ld (hl),0
   inc hl
   ld d,(hl)
   ld (hl),0
   ex de,hl

   ; hl = struct adt_Stack *

.loop
   ld a,h
   or l
   ret z

   push hl
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   push de
   ld l,c
   ld h,b
   push hl
   call l_jpix
   pop hl
   pop hl
   ex (sp),hl
   push hl
   call _u_free
   pop hl
   pop hl
   jp loop
