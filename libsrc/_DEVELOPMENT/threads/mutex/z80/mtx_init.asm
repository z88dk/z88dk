
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int mtx_init(mtx_t *m)
;
; Initialize a mutex.
;
; ===============================================================

INCLUDE "../mutex.inc"

XLIB mtx_init

LIB l_setmem_hl

mtx_init:

   ; enter : hl = mtx_t *m
   ;          c = mutex_type
   ;
   ; exit  :  c = mutex_type
   ;
   ;         success
   ;
   ;            hl = thrd_success
   ;            z flag set
   ;
   ;         fail (type not supported)
   ;
   ;            hl = thrd_error
   ;            nz flag set
   ;
   ; uses  : af, hl
      
   ld a,c
   and $fc
   jr nz, unknown_type

   xor a
   call l_setmem_hl - 12       ; zero structure

   dec hl
   dec hl
   dec hl
   ld (hl),$fe                 ; unlock(m->_mutex)
   dec hl
   dec hl
   ld (hl),c                   ; m->mutex_type = c

   ld l,a
   ld h,a                      ; hl = thrd_success
   
   ret

unknown_type:

   ld hl,thrd_error
   ret
