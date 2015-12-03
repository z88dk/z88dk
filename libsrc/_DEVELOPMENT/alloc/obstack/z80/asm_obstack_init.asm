
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_init(struct obstack *ob, size_t size)
;
; Create an obstack at address ob, size bytes long.
; Size must be at least seven bytes to hold obstack header.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC asm_obstack_init

EXTERN error_zc
   
asm_obstack_init:

   ; enter : de = struct obstack *ob
   ;         bc = size_t size
   ;
   ; exit  : success
   ;
   ;            carry reset
   ;            hl = struct obstack *ob
   ;
   ;         fail if obstack wraps 64k boundary
   ;
   ;            carry set
   ;            hl = 0
   ;
   ; uses  : af, de, hl

   push de                     ; save ob

   ld hl,6
   add hl,de                   ; hl = & first allocatable byte = new fence
   ex de,hl                    ; de = new fence, hl = ob
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; ob->fence = new fence
   inc hl
   ld (hl),e
   inc hl
   ld (hl),d                   ; ob->object = new fence
   inc hl
   
   ex de,hl                    ; de = & ob->end
   pop hl                      ; hl = ob

   add hl,bc                   ; hl = & byte following obstack
   jp c, error_zc              ; forbid wrapping 64k boundary
   
   ex de,hl
   ld (hl),e
   inc hl
   ld (hl),d                   ; ob->end = & byte following obstack
   
   ex de,hl
   sbc hl,bc                   ; hl = ob
   ret
