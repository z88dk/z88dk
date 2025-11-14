
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_file_deallocate

EXTERN __stdio_closed_file_list, asm_p_forward_list_alt_push_front

__stdio_file_deallocate:

   ; push FILE onto front of closed list
   ;
   ; This function undoes __stdio_file_allocate where a
   ; previously retrieved FILE* must be returned due
   ; to failed open.  The returned FILE* is placed back
   ; onto the front of the closed list to maintain an
   ; LRU ordering.
   ;
   ; When a FILE is closed, the returned FILE* should
   ; be appended to the back of the closed list.  This
   ; is done by fclose which is the only place where
   ; FILEs are closed.
   ;
   ; enter : de = FILE *
   ;
   ; uses  : bc, de
   
   push af
   push hl
   
   dec de
   dec de                      ; de = & FILE.link
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   EXTERN __stdio_lock_file_list
   
   push de
   call __stdio_lock_file_list
   pop de

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld bc,__stdio_closed_file_list
   call asm_p_forward_list_alt_push_front

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04
   
   EXTERN __stdio_unlock_file_list
   
   call __stdio_unlock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   pop hl
   pop af
   
   ret
