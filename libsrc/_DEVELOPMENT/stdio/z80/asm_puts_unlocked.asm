
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int puts_unlocked(const char *s)
;
; Write string to stdout followed by a '\n'.
; Return number of bytes written.
;
; ===============================================================

XLIB asm_puts_unlocked
XDEF asm0_puts_unlocked

XREF __stdio_file_stdout

LIB asm0_fputs_unlocked, asm0_fputc_unlocked, l_utod_hl, error_mc

asm_puts_unlocked:

   ; enter : hl = char *s
   ;
   ; exit  : ix = FILE *stdout
   ;
   ;         success
   ;
   ;            hl = strlen(s) + 1
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : all

   ld ix,(__stdio_file_stdout)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   LIB __stdio_verify_valid

   call __stdio_verify_valid
   ret c

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm0_puts_unlocked:

   call asm0_fputs_unlocked    ; output string
   ret c                       ; if error
   
   push hl                     ; save strlen(s)
   
   ld e,13                     ; '\n'
   call asm0_fputc_unlocked    ; output '\n'
   
   pop hl                      ; hl = strlen(s)
   jp c, error_mc              ; if error
   
   inc hl
   jp l_utod_hl                ; saturate hl
