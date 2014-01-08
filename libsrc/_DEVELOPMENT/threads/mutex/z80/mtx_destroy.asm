
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int mtx_destroy(mtx_t *m)
;
; Check if mutex can be destroyed.  C11 only requires committed
; resources to be released but this implementation does not
; acquire any resources so mutexes can be disappeared at any time.
;
; ===============================================================

INCLUDE "../mutex.inc"

XLIB mtx_destory

mtx_destroy:

   ; enter : hl = mtx_t *m
   ;
   ; exit  : success
   ;
   ;            hl = thrd_success
   ;            z flag set
   ;
   ;         fail (mutex in use)
   ;
   ;            hl = thrd_error
   ;            nz flag set
   ;
   ; uses  : af, hl
   
   ld a,(hl)                   ; a = thread owner

   inc hl
   inc hl
   inc hl
   inc hl
   
   or (hl)
   inc hl
   or (hl)                     ; OR forward_list *
   
   ld l,a
   ld h,a
   
   ret z                       ; if ok to destroy
   
   ld hl,thrd_error
   ret
