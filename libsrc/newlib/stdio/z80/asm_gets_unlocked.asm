
; ===============================================================
; Jan 2014
; ===============================================================
; 
; char *gets_unlocked(char *s)
;
; Read chars from stdin and write to string s until '\n' or
; a stream error occurs.  Remove the '\n' from the stream
; but discard it.  Terminate s with '\0'.
;
; This function is deprecated because it is unsafe.
; See fgets() instead.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm_gets_unlocked
PUBLIC asm0_gets_unlocked

EXTERN _stdin
EXTERN asm0_fgets_unlocked, __stdio_input_sm_gets

asm_gets_unlocked:

   ; enter : hl = char *s
   ;
   ; exit  : ix = FILE *stdin
   ;
   ;         if success
   ;
   ;            hl = char *s
   ;            de = address of terminating '\0'
   ;            s terminated
   ;            carry reset
   ;
   ;         if s == 0
   ;
   ;            hl = 0
   ;            s not terminated
   ;            carry set
   ;
   ;         if stream at EOF or stream in error state
   ;
   ;            hl = 0
   ;            s not terminated
   ;            carry set
   ;
   ;         if stream error or EOF occurs and no chars were read
   ;
   ;            hl = 0
   ;            s not terminated
   ;            carry set, errno set
   ;
   ; uses  : all except ix

   ld ix,(_stdin)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid, error_zc

   call __stdio_verify_valid
   jp c, error_zc

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm0_gets_unlocked:

   ex de,hl                    ; de = char *s

   ld bc,$ffff                 ; read as many chars as we can

   ld hl,__stdio_input_sm_gets ; qualify function for gets
   jp asm0_fgets_unlocked
