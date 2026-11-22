
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

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm_puts_unlocked
PUBLIC asm0_puts_unlocked

EXTERN _stdout
EXTERN asm0_fputs_unlocked, asm0_fputc_unlocked, l_utod_hl, error_mc

asm_puts_unlocked:

   ; enter : hl = char *s
   ;
   ; exit  : ix unchanged
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
   ; uses  : all except ix

   push ix
   ld ix,(_stdout)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid

   call __stdio_verify_valid
   jr c, puts_unlocked_exit

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   call asm0_puts_unlocked

puts_unlocked_exit:

   pop ix
   ret

asm0_puts_unlocked:

   call asm0_fputs_unlocked    ; output string
   ret c                       ; if error
   
   push hl                     ; save strlen(s)
   
   ld e,CHAR_LF
   call asm0_fputc_unlocked    ; output '\n'
   
   pop hl                      ; hl = strlen(s)
   jp c, error_mc              ; if error
   
   inc hl
   jp l_utod_hl                ; saturate hl
