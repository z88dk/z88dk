
SECTION code_clib
SECTION code_fcntl

PUBLIC __fcntl_unlock_fdtbl

EXTERN __fcntl_fdtbl_lock, asm_mtx_unlock

__fcntl_unlock_fdtbl:

   ; unlock fdtbl
   ;
   ; enter : none
   ;
   ; exit  : none
   ;
   ; uses  : none
   
   push af
   push bc
   push de
   push hl
   
   ld hl,__fcntl_fdtbl_lock
   call asm_mtx_unlock

   pop hl
   pop de
   pop bc
   pop af
   
   ret
