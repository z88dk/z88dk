
; ===============================================================
; Apr 2014
; ===============================================================
; 
; FILE *fopen_unlocked(const char *filename, const char *mode);
;
; Open a file.
;
; ===============================================================

INCLUDE "clib_cfg.asm"

PUBLIC asm_fopen_unlocked
PUBLIC asm0_fopen_unlocked

EXTERN error_einval_zc, error_emfile_zc, error_zc
EXTERN asm_p_forward_list_alt_pop_front, asm_p_forward_list_push_front
EXTERN asm_p_forward_list_alt_push_front
EXTERN __stdio_parse_permission, asm_open, asm_mtx_init

EXTERN mtx_recursive
EXTERN __stdio_file_list_open, __stdio_file_list_avail

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

EXTERN __stdio_lock_file_list, __stdio_unlock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm_fopen_unlocked:

   ; enter : de = char *mode
   ;         hl = char *filename
   ;
   ; exit  : success
   ;
   ;            hl = FILE *
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = 0
   ;            carry set, errno set
   ;
   ; uses  : all

   ld a,h
   or l
   jp z, error_einval_zc       ; if filename == NULL
   
   ; mode string valid ?
   
   push hl                     ; save filename
   
   call __stdio_parse_permission
   jp c, error_einval_zc - 1   ; if mode string is invalid
   
   push bc                     ; save mode byte
   
   ; allocate a FILE structure

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   call __stdio_lock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld hl,__stdio_file_list_avail
   call asm_p_forward_list_alt_pop_front

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   push af                     ; save error status
   push hl                     ; save & FILE.link
   
   call __stdio_unlock_file_list
   
   pop hl                      ; hl = & FILE.link
   pop af                      ; carry = error

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   pop bc                      ; c = mode byte
   pop de                      ; de = filename
   
   jp c, error_emfile_zc       ; if no available FILE struct
   
   ; target must open file on appropriate device
   
   push bc                     ; save mode byte
   push hl                     ; save & FILE.link

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO_FILE_EXTRA > 0

   inc hl
   inc hl
   
   push hl
   pop ix
   
   ld (ix+13),0                ; clear driver flags
   
   ; ix = FILE *

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ;  c = mode byte
   ; de = filename
   ; stack = mode byte, FILE.link
   
   ld b,0
   call asm_open               ; pass details to target open()
   jr c, open_failed           ; if target cannot open file

   ; de = driver function, returned by target open()

   pop hl                      ; hl = & FILE.link
   pop bc                      ; c = mode byte
   
   ; initialize the FILE structure
   
   push hl                     ; save & FILE.link
   
   inc hl
   inc hl
   
   call initialize_file_struct
   
   ; place FILE on open list

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   call __stdio_lock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   pop de                      ; de = & FILE.link
   
   ld hl,__stdio_file_list_open
   call asm_p_forward_list_push_front

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   push hl                     ; save & FILE.link
   
   call __stdio_unlock_file_list
   
   pop hl                      ; hl = & FILE.link

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; return FILE *
   
   inc hl
   inc hl                      ; hl = FILE *
   
   ret

open_failed:

   ; stack = mode byte, FILE.link

   ; return allocated FILE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   call __stdio_lock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   pop de                      ; de = & FILE.link
   
   ld bc,__stdio_file_list_avail
   call asm_p_forward_list_alt_push_front

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   call __stdio_unlock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   jp error_zc - 1

asm0_fopen_unlocked:
initialize_file_struct:

   ;  c = mode byte
   ; de = driver function
   ; hl = uninitialized FILE *
   
   push hl                     ; save FILE*
   
   ld (hl),195                 ; JP
   inc hl
   
   ld (hl),e                   ; stdio_next
   inc hl
   ld (hl),d
   inc hl
   
   ld a,c
   rrca
   rrca
   and $c0
   ld (hl),a                   ; state_flags_0
   inc hl
   
   ld a,c
   rla
   and $02
   ld (hl),a                   ; state_flags_1
   inc hl
   
   inc hl
   inc hl
   
   ld c,mtx_recursive
   call asm_mtx_init

   pop hl                      ; hl = FILE*
   ret
