
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_free(struct obstack *ob, void *object)
;
; If object is part of the obstack, deallocate the object and
; all objects allocated after it.
;
; If object == NULL, completely empty the obstack.  The obstack
; is in a valid state and can continue to be used.
;
; On successful free, any growing object is closed and freed.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC asm_obstack_free

EXTERN error_zc

asm_obstack_free:

   ; enter : hl = struct obstack *ob
   ;         bc = void *object
   ;
   ; exit  : success
   ;
   ;            carry reset
   ;            hl = ob->fence (address of next allocation)
   ;
   ;         fail on object not part of obstack
   ;
   ;            carry set
   ;            hl = 0
   ;
   ; uses  : af, de, hl
   
   ld a,b
   or c
   jr z, free_all

   ; if object does not lie within obstack area report error
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl                    ; hl = ob->fence, de = & ob->fence + 1
   
   scf
   sbc hl,bc                   ; fence > object otherwise invalid
   jp c, error_zc
   
   ld hl,4
   add hl,de                   ; hl = & ob->mem - 1
   sbc hl,bc                   ; object >= ob->mem otherwise invalid
   jp nc, error_zc
      
   ex de,hl
   dec hl                      ; hl = & ob->fence
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; ob->fence = object
   inc hl
   ld (hl),c
   inc hl
   ld (hl),b                   ; ob->object = object, closes growing object
   
   ld l,c
   ld h,b                      ; hl = object
   
   or a
   ret

free_all:

   ; hl = struct obstack *ob
   
   ex de,hl
   ld hl,6
   add hl,de
   ex de,hl                    ; de = & ob->mem
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; ob->fence = & ob->mem
   inc hl
   ld (hl),e
   inc hl
   ld (hl),d                   ; ob->object = & ob->mem
   
   ex de,hl                    ; hl = first allocatable byte
   ret
