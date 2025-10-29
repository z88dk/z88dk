
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_copy0(struct obstack *ob, void *address, size_t size)
;
; Attempt to allocate size+1 bytes from the obstack and initialize
; it by copying data from address, terminating the copy with a
; NUL char.  Implicitly closes any growing object.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC asm_obstack_copy0

EXTERN asm_obstack_copy, error_zc

asm_obstack_copy0:

   ; enter : hl = struct obstack *ob
   ;         bc = size_t size
   ;         de = void *address
   ;
   ; exit  : success
   ;
   ;            carry reset
   ;            hl = address of allocated memory
   ;
   ;         fail on insufficient memory
   ;
   ;            carry set
   ;            hl = 0
   ;
   ; uses  : af, bc, de, hl

   inc bc                      ; make room for terminating NUL
   ld a,b
   or c
   jp z, error_zc              ; we really have to check this case :(

   call asm_obstack_copy
   ret c
   
   dec de
   xor a
   ld (de),a                   ; terminate copied block
   
   ret
