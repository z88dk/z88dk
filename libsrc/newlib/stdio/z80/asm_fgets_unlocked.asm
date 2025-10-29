
; ===============================================================
; Jan 2014
; ===============================================================
; 
; char *fgets(char *s, int n, FILE *stream)
;
; Read up to n-1 chars into array s from the stream.  Terminate
; the string with a '\0'.  Stop reading from the stream if '\n'
; or EOF is encountered.  '\n' is written to s.
;
; If no chars could be read from the stream or a stream error
; occurs, 0 is returned.  Otherwise s is returned.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm_fgets_unlocked
PUBLIC asm0_fgets_unlocked, asm1_fgets_unlocked

EXTERN error_zc, __stdio_recv_input_raw_getc
EXTERN __stdio_verify_input, __stdio_input_sm_fgets, __stdio_recv_input_raw_eatc

asm_fgets_unlocked:

   ; enter : ix = FILE *
   ;         bc = size_t n
   ;         de = char *s
   ;
   ; exit  : ix = FILE *
   ;
   ;         if success
   ;
   ;            hl = char *s
   ;            de = address of terminating '\0'
   ;            s terminated
   ;            carry reset
   ;
   ;         if s == 0 or n == 0
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid

   call __stdio_verify_valid
   jp c, error_zc

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm1_fgets_unlocked:

   ld hl,__stdio_input_sm_fgets  ; use the fgets state machine to qualify stream chars

asm0_fgets_unlocked:             ; entry for gets()

   push hl
   
   call __stdio_verify_input   ; check that input from stream is ok
   jp c, error_zc - 1
   
   ld a,d
   or e
   jp z, error_zc - 1          ; if s == 0
   
   ld a,b
   or c
   jp z, error_zc - 1          ; if n == 0
   
   dec bc                      ; make room for '\0'
   pop hl                      ; hl = state machine
   
   push de                     ; save char *s

   exx

   ld hl,$ffff                 ; consume as many chars as we can (state machine controls how many)   
   call __stdio_recv_input_raw_eatc
   
   exx
   jr c, stream_error
   
   dec l                       ; if l == 1, state machine says remove \n from stream
   jr nz, success
   
   ; \n was left on the stream
   
   push de
   
   call __stdio_recv_input_raw_getc  ; throw away \n
   
   pop de
   
success:

   xor a
   ld (de),a                   ; terminate s
   
   pop hl
   ret

stream_error:

   exx
   ld a,b
   or c
   exx

   jr nz, success              ; if at least one char was written to s
   jp error_zc - 1
