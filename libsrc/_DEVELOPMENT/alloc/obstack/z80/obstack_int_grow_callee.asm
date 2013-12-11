
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_int_grow(struct obstack *ob, int data)
;
; Append int to the growing object.
;
; ===============================================================

XLIB obstack_int_grow_callee
XDEF asm_obstack_int_grow

LIB asm_obstack_room, error_enomem_zc

obstack_int_grow_callee:

   pop hl
   pop bc
   ex (sp),hl

asm_obstack_int_grow:

   ; enter : hl = struct obstack *ob
   ;         bc = int data
   ;
   ; exit  : success
   ;
   ;            carry reset
   ;            hl = struct obstack *ob
   ;
   ;         fail
   ;
   ;            carry set, enomem
   ;            hl = 0
   ;
   ; uses  : af, de, hl

   push hl                     ; save ob
   
   call asm_obstack_room       ; de = ob->fence, hl = available bytes
   
   ld a,h
   or a
   jr nz, enough_space

   ld a,l
   cp 2
   jp c, error_enomem_zc - 1

enough_space:
   
   ex de,hl                    ; hl = ob->fence
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; append int to object
   inc hl
   
   ex de,hl                    ; de = new fence
   pop hl                      ; hl = ob
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; ob->fence = new fence
   dec hl
   
   ret
