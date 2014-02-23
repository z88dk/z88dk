
; ===============================================================
; Jan 2014
; ===============================================================
; 
; char *gets(char *s)
;
; Read chars from stdin and write to string s until '\n' or
; a stream error occurs.  Remove the '\n' from the stream
; but discard it.  Terminate s with '\0'.
;
; This function is deprecated because it is unsafe.
; See fgets() instead.
;
; ===============================================================

XLIB asm_gets

LIB asm0_gets_unlocked
LIB __stdio_lock_acquire, error_enolck_zc, __stdio_lock_release

asm_gets:

   ; enter : hl = char *s
   ;
   ; exit  : ix = FILE *stdin
   ;         bc'= number of chars read from stream (includes '\n')
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

   ld ix,(__stdio_file_stdin)
   
   call __stdio_lock_acquire
   jp c, error_enolck_zc
   
   call asm0_gets_unlocked
   jp __stdio_lock_release
