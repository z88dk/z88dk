
SECTION code_clib
SECTION code_fcntl

PUBLIC __fcntl_inc_refcount

EXTERN __fcntl_fdchain_descend

__fcntl_inc_refcount:

   ; increase the reference count of an FDSTRUCT chain
   ;
   ; enter : ix = FDSTRUCT *
   ;          c = reference count increment
   ;
   ; exit  : carry reset
   ;
   ; uses  : af, de
   
   push ix                     ; save FDSTRUCT *

loop:

   ld a,(ix+7)
   add a,c
   ld (ix+7),a                 ; ref_count += c
   
   call __fcntl_fdchain_descend
   jr nz, loop                 ; if the chain continues
   
   pop ix                      ; restore FDSTRUCT *
   
   or a
   ret
