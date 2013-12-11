
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

XLIB obstack_align_distance_callee
XDEF asm_obstack_align_distance

LIB l_power_2_bc, error_einval_mc, error_znc, l_andc_hlbc

obstack_align_distance_callee:

   pop hl
   pop bc
   ex (sp),hl

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
   ;            carry set, einval
   ;            hl = -1
   ;
   ; uses  : af, bc, de, hl
   
   call l_power_2_bc           ; bc = power of 2
   jp c, error_einval_mc

   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = ob->fence

   dec c
   jp z, error_znc             ; distance is zero for alignment == 1
   inc c
   
   ld l,e
   ld h,d                      ; hl = ob->fence
   
   dec bc
   add hl,bc                   ; hl = fence + (alignment-1)
   jp c, error_einval_mc
   
   call l_andc_hlbc            ; hl = next aligned address
   
   sbc hl,de                   ; distance in bytes
   ret
