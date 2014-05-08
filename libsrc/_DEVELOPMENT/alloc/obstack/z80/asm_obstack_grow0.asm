
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int obstack_grow0(struct obstack *ob, void *data, size_t size)
;
; Grow the current object by appending size bytes read from
; address data followed by a NUL char.
;
; ===============================================================

PUBLIC asm_obstack_grow0

EXTERN asm0_obstack_blank, asm_memcpy, error_enomem_zc

asm_obstack_grow0:

   ; enter : hl = struct obstack *ob
   ;         bc = size_t size
   ;         de = void *data
   ;
   ; exit  : success
   ;
   ;            carry reset
   ;            hl = non-zero
   ;            de = address of terminating NUL
   ;
   ;
   ;         fail on insufficient memory
   ;
   ;            carry set, enomem
   ;            hl = 0
   ;
   ; uses  : af, bc, de, hl

   inc bc                      ; make space for NUL
   ld a,b
   or c
   jp z, error_enomem_zc       ; we really have to check for this case :(
   
   push de                     ; save data
   call asm0_obstack_blank     ; de = & allocated bytes
   pop hl                      ; hl = data
   ret c

   call asm_memcpy
   
   dec de
   xor a
   ld (de),a                   ; terminate with NUL

   ret
