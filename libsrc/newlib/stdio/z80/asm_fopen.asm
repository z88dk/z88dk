
; ===============================================================
; Apr 2014
; ===============================================================
; 
; FILE *fopen(const char *filename, const char *mode)
;
; Open a file.
;
; ===============================================================

SECTION code_clib
SECTION code_stdio

PUBLIC asm_fopen

EXTERN __stdio_parse_mode, __stdio_file_allocate, __stdio_file_deallocate
EXTERN __stdio_file_init, __stdio_file_add_list, asm0_vopen
EXTERN error_einval_zc, error_zc

asm_fopen:

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
   ; uses  : all except iy

   ld a,h
   or l
   jp z, error_einval_zc       ; if filename == NULL
   
   ; mode string valid ?
   
   push hl                     ; save filename
   
   call __stdio_parse_mode
   jp c, error_einval_zc - 1   ; if mode string is invalid
   
   push bc                     ; save mode byte
   
   ; allocate a FILE structure

   call __stdio_file_allocate
   
   pop bc                      ; c = mode byte
   pop de                      ; de = filename
   
   jp c, error_zc              ; if no available FILE struct

   ; target must open file on appropriate device
   
   push bc                     ; save mode byte
   push hl                     ; save FILE *
   
   ;  c = mode byte
   ; de = filename
   ; stack = mode byte, FILE *
   
   ld hl,0                     ; void *arg = 0
   ld b,h                      ; mode byte made 16-bit
   set 7,c                     ; indicate ref_count = 2
   
   call asm0_vopen             ; target must open file
   jr c, open_failed           ; if target cannot open file

   ; de = FDSTRUCT *, returned by vopen()
   ;  c = FILE type, returned by vopen()
   ; stack = mode byte, FILE *

   ld a,c

   pop hl                      ; hl = FILE *
   pop bc                      ; c = mode byte

   ld b,a                      ; b = FILE type

   ; initialize FILE structure
   
   call __stdio_file_init
   
   ; place FILE on open list
   
   push hl                     ; save FILE *
   
   ex de,hl
   call __stdio_file_add_list
   
   pop hl                      ; hl = FILE *
   
   or a
   ret

open_failed:

   ; stack = mode byte, FILE *
   
   pop de                      ; de = FILE *
   
   call __stdio_file_deallocate
   jp error_zc - 1
