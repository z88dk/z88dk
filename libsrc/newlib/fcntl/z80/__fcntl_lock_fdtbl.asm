
SECTION code_clib
SECTION code_fcntl

PUBLIC __fcntl_lock_fdtbl

EXTERN __fcntl_fdtbl_lock, asm_mtx_lock

__fcntl_lock_fdtbl:

   ; acquire lock on fd table
   ;
   ; enter : none
   ;
   ; exit  : lock acquired
   ;         carry reset
   ;
   ; uses  : af
   
   push bc
   push de
   push hl

loop:

   ld hl,__fcntl_fdtbl_lock
   call asm_mtx_lock
   
   jr c, loop                  ; do not accept lock error on fdtable lock

   pop hl
   pop de
   pop bc
   
   ret
