
XLIB __stdio_unlock_file_list

XREF __stdio_file_list_lock

LIB asm_mtx_unlock

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
