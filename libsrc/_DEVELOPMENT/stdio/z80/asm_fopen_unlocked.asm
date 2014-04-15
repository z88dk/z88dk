
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

XLIB asm_fopen_unlocked
XDEF asm0_fopen_unlocked

XREF __stdio_file_list_avail, mtx_recursive

LIB error_einval_zc, error_emfile_zc, error_zc
LIB asm_open, __stdio_parse_permission, asm_mtx_init
LIB asm_p_forward_list_alt_pop_front, asm_p_forward_list_alt_push_front

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   LIB __stdio_lock_file_list, __stdio_unlock_file_list

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
   ; uses  : all except ix

   ld a,h
   or l
   jp z, error_einval_zc       ; if filename == NULL
   
   push hl                     ; save filename
   
   call __stdio_parse_permission   ; parse mode string
   jp c, error_einval_zc - 1       ; if mode string is invalid
   
   push bc                     ; save mode byte
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04
   
   call __stdio_lock_file_list   ; acquire stdio lock

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld hl,__stdio_file_list_avail
   call asm_p_forward_list_alt_pop_front

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   push hl                     ; save & FILE.link
   push af                     ; save error status
   
   call __stdio_unlock_file_list  ; release stdio lock

   pop af                      ; carry = error
   pop hl                      ; hl = & FILE.link

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   pop bc                      ; c = mode byte
   pop de                      ; de = filename
   
   jp c, error_emfile_zc       ; if FILE is unavailable

   push bc                     ; save mode byte
   push hl                     ; save & FILE.link
   
   ;  c = mode byte
   ; de = filename
   ; hl = & FILE.link
   ; stack = mode byte, FILE.link
   
   call asm_open               ; pass details to target open()
   jr c, open_failed
   
   pop hl                      ; hl = & FILE.link
   pop bc                      ; c = mode byte
   
   inc hl
   inc hl                      ; hl = FILE*

asm0_fopen_unlocked:

   ;  c = mode byte
   ; de = driver_function
   ; hl = uninitialized FILE
   
   push hl                     ; save FILE*
   
   ld (hl),195                 ; JP
   inc hl
   
   ld (hl),e                   ; stdio_next
   inc hl
   ld (hl),d
   inc hl
   
   ld a,c
   and $c0
   ld (hl),a                   ; state_flags_0
   inc hl
   
   rlca
   rlca
   and $02
   ld (hl),a                   ; state_flags_1
   inc hl
   
   inc hl
   inc hl
   
   ld c,mtx_recursive
   call asm_mtx_init

   pop hl                      ; hl = FILE*
   ret

open_failed:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04
  
   call __stdio_lock_file_list   ; acquire stdio lock
   
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   pop de                      ; de = & FILE.link
   
   ld bc, __stdio_file_list_avail
   call asm_p_forward_list_alt_push_front

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04
   
   call __stdio_unlock_file_list  ; release stdio lock

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   jp error_zc - 1
