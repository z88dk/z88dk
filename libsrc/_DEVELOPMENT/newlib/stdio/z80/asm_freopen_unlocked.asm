
; ===============================================================
; Oct 2014
; ===============================================================
; 
; FILE *freopen_unlocked(char *filename, char *mode, FILE *stream)
;
; Reassigns the stream to a different file.
;
; ===============================================================

INCLUDE "config_private.inc"

PUBLIC asm_freopen_unlocked, asm0_freopen_unlocked

EXTERN __stdio_verify_valid, asm1_fclose_unlocked, __stdio_parse_mode
EXTERN error_zc, error_enotsup_zc, error_einval_zc, l_inc_sp
EXTERN asm0_vopen, __stdio_file_init, l_jpix
EXTERN __stdio_open_file_list, asm_p_forward_list_remove
EXTERN __stdio_closed_file_list, asm_p_forward_list_alt_push_back

asm_freopen_unlocked:

   ; enter : ix = FILE *
   ;         de = char *mode
   ;         hl = char *filename
   ; 
   ; exit  : ix = FILE * (closed & invalid on fail)
   ;
   ;         success
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

   call __stdio_verify_valid
   jp c, error_zc              ; if FILE is invalid

asm0_freopen_unlocked:

   ; check if filename == NULL

   ld a,(ix+3)
   inc a
   and $07                     ; z flag set if memstream
   
   push af                     ; save memstream?

   ld a,h
   or l
   jr z, mode_change           ; if filename == NULL, mode change only
   
   ; close FILE
   
   push de                     ; save char *mode
   push hl                     ; save char *filename
   
   call asm1_fclose_unlocked
   
   pop hl                      ; hl = filename
   pop de                      ; de = mode
   pop af                      ; z flag set if memstream
   
   jp z, error_enotsup_zc      ; freopen on memstream not permitted

   ; parse mode string
   
   push hl                     ; save filename
   
   call __stdio_parse_mode
   
   pop de                      ; de = filename
   jr c, invalid_mode_string   ; if mode string is invalid
   
   ; open file
   
   ; ix = FILE *
   ; de = filename
   ;  c = mode byte
   
   push bc                     ; save mode byte
   push ix                     ; save FILE *
   push ix                     ; save FILE *
   
   ld hl,0                     ; void *arg = 0
   ld b,h                      ; mode byte made 16-bit
   set 7,c                     ; indicate ref_count = 2
   
   call asm0_vopen             ; target must open file
   
   ld a,c                      ; a = FILE type
   
   pop ix                      ; ix = FILE *
   pop hl                      ; hl = FILE *
   pop bc                      ; c = mode byte
   
   ld b,a                      ; b = FILE type
   jr c, invalid_open          ; if open failed
   
   ; initialize FILE structure
   
   ; de = FDSTRUCT *, returned by target open
   ; hl = ix = FILE *
   ;  c = mode byte
   ;  b = FILE type

   call __stdio_file_init
   
   ; hl = ix = FILE *
   
   or a
   ret

invalid_mode_string:

   ; ix = FILE *
   
   call error_einval_zc        ; errno = EINVAL

invalid_open:

   ; FILE has been closed
   ; error on open so place closed FILE on closed list

   ; ix = FILE *

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   EXTERN __stdio_lock_file_list
   call __stdio_lock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; remove FILE from open list
   
   push ix
   pop bc                      ; bc = FILE *
   
   dec bc
   dec bc                      ; bc = & FILE.link
   
   ld hl,__stdio_open_file_list
   call asm_p_forward_list_remove

   ; append FILE to closed list

   ld e,c
   ld d,b                      ; de = & FILE.link
   
   ld bc,__stdio_closed_file_list
   call asm_p_forward_list_alt_push_back

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   EXTERN __stdio_unlock_file_list
   call __stdio_unlock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   jp error_zc                 ; indicate failure

mode_change:

   ; attempting mode change only

   ; ix = FILE *
   ; de = char *mode
   ; stack = memstream?

   call perform_mode_change
   jp nc, l_inc_sp - 2         ; if mode change successful

mode_change_failed:

   ; ix = FILE *
   ; stack = memstream?
   
   ; close FILE
   
   call asm1_fclose_unlocked
   
   pop af                      ; z flag set if memstream
   jp z, error_zc              ; if memstream indicate failure
   
   jr invalid_open             ; place closed FILE on closed list

perform_mode_change:

   ; ix = FILE *
   ; de = char *mode
   
   call __stdio_parse_mode
   jp c, error_einval_zc       ; if mode string invalid
   
   ; ix = FILE *
   ;  c = mode byte
   ; stack = memstream?
   
   ld e,(ix+1)
   ld d,(ix+2)                 ; de = FDSTRUCT *
   
   ld hl,8
   add hl,de                   ; hl = & FDSTRUCT.mode
   
   ld a,c
   and $07                     ; only interested in RWA bits
   ld c,a
   
   and (hl)                    ; compare to fd mode bits
   cp c
   
   jp nz, error_enotsup_zc     ; if desired mode not supported
   
   ; flush FILE
   
   push bc                     ; save mode byte
   
   ld a,STDIO_MSG_FLSH
   call l_jpix
   
   pop bc                      ; c = mode byte
   
   ; alter FILE's mode bits
   
   ld a,(ix+3)
   and $27
   ld b,a                      ; b = FILE type
   
   ld a,c
   rrca
   rrca
   and $c0
   or b
   ld (ix+3),a                 ; FILE.state_flags_0   

   ld a,c
   rla
   and $02
   ld (ix+4),a                 ; FILE.state_flags_1
   
   push ix
   pop hl                      ; hl = FILE *
   
   ret
