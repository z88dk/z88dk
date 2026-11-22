
; Jan 2014

SECTION code_clib
SECTION code_stdlib

PUBLIC __sort_parameters

EXTERN l_mulu_16_16x16, l_inc_sp
EXTERN error_einval_zc, error_erange_zc, error_znc

__sort_parameters:

   ; enter : ix = int (*compar)(de=const void *, hl=const void *)
   ;         bc = void *base
   ;         hl = size_t nmemb
   ;         de = size_t size
   ;
   ; exit  : ix unchanged
   ;
   ;         success
   ;
   ;            de = void *base (address of first item)
   ;            hl = void *end (address of last item)
   ;            bc = size_t size
   ;            carry reset
   ;
   ;         fail
   ;
   ;            einval if size == 0
   ;            einval if array size > 64k
   ;            erange if array wraps 64k boundary
   ;            carry set
   ;
   ; uses   : af, bc, de, hl

   ld a,d
   or e
   jp z, error_einval_zc       ; if size == 0

   ld a,h
   or l
   jp z, error_znc             ; if no items
   dec hl
   
   push de                     ; save size
   push bc                     ; save base
   
   call l_mulu_16_16x16        ; hl = hl * de = (nmemb - 1) * size
   
   pop de                      ; de = lo (base)
   jp c, error_erange_zc - 1   ; if multiply overflowed
   
   add hl,de                   ; hl = hi (address of last item)
   pop bc                      ; bc = size
   
   ret nc
   jp error_erange_zc          ; if address out of range
