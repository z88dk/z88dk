
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_int_grow(struct obstack *ob, int data)
;
; Append int to the growing object.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC asm_obstack_int_grow

EXTERN asm_obstack_room, error_zc

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
   ;            carry set
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
   jp c, error_zc - 1

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
