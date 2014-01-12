
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

XLIB asm_obstack_init

LIB error_einval_zc
   
asm_obstack_init:

   ; enter : de = struct obstack *ob
   ;         bc = size_t size
   ;
   ; exit  : success
   ;
   ;            carry reset
   ;            hl = struct obstack *ob
   ;
   ;         fail if size too small
   ;
   ;            carry set, einval
   ;            hl = 0
   ;
   ;         fail if obstack wraps 64k boundary
   ;
   ;            carry set, einval
   ;            hl = 0
   ;
   ; uses  : af, de, hl

   ; size must be at least six for obstack header

   ld a,b
   or a
   jp nz, big_enough

   ld a,c
   cp __ob_mem + 1             ; header plus one byte
   jp c, error_einval_zc

big_enough:

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
   jp c, error_einval_zc       ; forbid wrapping 64k boundary
   
   ex de,hl
   ld (hl),e
   inc hl
   ld (hl),d                   ; ob->end = & byte following obstack
   
   ex de,hl
   sbc hl,bc                   ; hl = ob
   ret
