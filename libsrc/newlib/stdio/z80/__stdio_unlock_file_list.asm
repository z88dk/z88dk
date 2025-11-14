
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_unlock_file_list

EXTERN __stdio_file_list_lock
EXTERN asm_mtx_unlock

__stdio_unlock_file_list:

   ; unlock stdio's FILE lists
   ;
   ; enter : none
   ;
   ; exit  : none
   ;
   ; uses  : af, bc, de, hl
   
   ld hl,__stdio_file_list_lock
   jp asm_mtx_unlock
