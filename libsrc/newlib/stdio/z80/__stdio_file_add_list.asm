
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_file_add_list

EXTERN __stdio_open_file_list, asm_p_forward_list_push_front

__stdio_file_add_list:

   ; add file to the open list
   ;
   ; enter : de = FILE *
   ;
   ; uses  : af, bc, de, hl
   
   dec de
   dec de                      ; de = & FILE.link
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   push de
   
   EXTERN __stdio_lock_file_list
   call __stdio_lock_file_list
   
   pop de

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld hl,__stdio_open_file_list

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   call asm_p_forward_list_push_front
   
   EXTERN __stdio_unlock_file_list
   jp __stdio_unlock_file_list

ELSE

   jp asm_p_forward_list_push_front
   
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
