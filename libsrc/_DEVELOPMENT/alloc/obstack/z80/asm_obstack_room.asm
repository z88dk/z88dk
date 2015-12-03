
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t obstack_room(struct obstack *ob)
;
; Number of free bytes available in the obstack.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC asm_obstack_room

asm_obstack_room:

   ; enter : hl = struct obstack *ob
   ;
   ; exit  : hl = number of bytes available in obstack
   ;         de = ob->fence
   ;         carry reset
   ;
   ; uses  : af, de, hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = ob->fence
   inc hl
   inc hl
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = ob->end
   
   or a
   sbc hl,de
   ret
