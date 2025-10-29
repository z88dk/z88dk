
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_1grow(struct obstack *ob, char c)
;
; Append char c to the growing object.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC asm_obstack_1grow

EXTERN asm_obstack_room, error_zc

asm_obstack_1grow:

   ; enter : hl = struct obstack *ob
   ;          c = char c
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
   
   call asm_obstack_room       ; de = ob->fence
   jp z, error_zc - 1
   
   ld a,c
   ld (de),a                   ; append char to object
   inc de
   
   pop hl                      ; hl = ob
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; ob->fence++
   dec hl
   
   ret
