
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t obstack_align_distance(struct obstack *ob, size_t alignment)
;
; Return distance in bytes from the obstack fence to the next
; address aligned to alignment.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC asm_obstack_align_distance

EXTERN l_power_2_bc, error_mc, error_znc, l_andc_hlbc

asm_obstack_align_distance:

   ; enter : hl = struct obstack *ob
   ;         bc = size_t alignment
   ;
   ; exit  : success
   ;
   ;            carry reset
   ;            hl = distance to next aligned address
   ;            de = ob->fence
   ;
   ;         fail invalid alignment
   ;
   ;            carry set
   ;            hl = -1
   ;
   ; uses  : af, bc, de, hl
   
   call l_power_2_bc           ; bc = power of 2
   jp c, error_mc
   
   dec bc                      ; bc = alignment - 1
   ld a,b
   or c
   jp z, error_znc             ; distance is 0 for alignment == 1

   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = ob->fence
   
   ld l,e
   ld h,d                      ; hl = ob->fence
   
   add hl,bc                   ; hl = fence + (alignment-1)
   jp c, error_mc
   
   call l_andc_hlbc            ; hl = next aligned address
   
   sbc hl,de                   ; distance in bytes
   ret
