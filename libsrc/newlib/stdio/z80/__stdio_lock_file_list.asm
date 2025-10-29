
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_lock_file_list

EXTERN __stdio_file_list_lock
EXTERN asm_mtx_lock

__stdio_lock_file_list:

   ; acquire stdio lock on FILE lists
   ;
   ; enter : none
   ;
   ; exit  : lock acquired
   ;
   ; uses  : af, bc, de, hl
   
   ld hl,__stdio_file_list_lock
   
   call asm_mtx_lock
   ret nc
   
   jr __stdio_lock_file_list   ; do not accept lock error on stdio lock
