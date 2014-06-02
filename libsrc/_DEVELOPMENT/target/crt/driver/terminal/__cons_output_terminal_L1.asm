
; May 2014 aralbrec

; CONSOLE OUTPUT TERMINAL LEVEL 1
;
; This partial driver is supplied by the library to
; ease the writing of console drivers.
;
; The features of the level 1 console include:
;
; * Terminal driver byte flags implemented
;
;   - echo on/off
;
;     With echo disabled character input is not echoed
;     to the output terminal.
;
;   - password on/off
;
;     In password mode, echoed chars are replaced by
;     an asterisk.
;
;   - line mode on/off
;
;     In line mode, a statically allocated edit buffer
;     is used to collect user input until '\n' is
;     received.  This gives the user an opportunity to
;     edit input before it is delivered to stdio.  The
;     level 1 input console supports backspace only to
;     edit input.  On some implementations a cursor
;     will also be displayed, typically '_' and '-'
;     with the latter indicating caps lock is active.
;
;     When line mode is disabled, the console is in
;     character mode where character input is collected
;     one char at a time without any edit opportunities.
;
;   - cook on/off
;
;     Cook mode allows the console to interpret the byte
;     stream.  In a level 1 console, this means backspace
;     and caps lock will be intercepted.  It also allows
;     lower case to upper case conversion when caps lock
;     is active.
;
;   - caps lock on/off
;
; A level 1 output console must be paired with a level 1
; input console so that exchanged messages are understood.

; FILE *output_terminal
;
; offset  size   desription
;
;  13,14   2     driver flags
;  15,16   2     terminal state * (0 if untied)

; terminal state
;
; offset   description
;
;   0,1    input terminal state * (structure in input console)

; messages to the output terminal
;
; STDIO_MSG_OTERM_L1
; can modify af, bc, de, hl, ix
;
;   b = 1 __cons_output_putc
;         c = char to output
;         carry set if error (ignored by input console)
;         do not modify ix
;
;   b = 2 __cons_output_backspace
;         c = char to erase
;        de = address of char to erase in edit buffer
;
;   b = 3 __cons_output_backspace_pwd
;         c = password char
;        de = address of char to erase in edit buffer
;
;   b = 4 input console is starting read line
;        de = address of edit buffer
;
; STDIO_MSG_OTERM_PUTCHAR
; c = char to output
; return carry set on error
; can modify af, bc, de, hl


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC __cons_output_terminal_L1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN error_enotsup_zc, error_lznc, error_znc

   EXTERN STDIO_MSG_PUTC, STDIO_MSG_WRIT, STDIO_MSG_SEEK
   EXTERN STDIO_MSG_FLSH, STDIO_MSG_CLOS, STDIO_MSG_OTERM_PUTCHAR

__cons_output_terminal_L1:

   cp STDIO_MSG_OTERM_PUTCHAR
   jr z, __putchar

   cp STDIO_MSG_PUTC
   jr z, __putc
   
   cp STDIO_MSG_WRIT
   jr z, __writ
   
   cp STDIO_MSG_SEEK
   jp z, error_lznc            ; do nothing, report no error
   
   cp STDIO_MSG_FLSH
   jp z, error_znc             ; do nothing, report no error
   
   cp STDIO_MSG_CLOS
   jp z, error_znc             ; do nothing, report no error
   
   jp error_enotsup_zc         ; hl = 0 puts stream in error state except for IOCTL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN STDIO_MSG_OTERM_L1

__putchar:

   ld b,1
   
   ld a,STDIO_MSG_OTERM_L1
   jp (ix)
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN l_jpix
   EXTERN STDIO_MSG_OTERM_PUTCHAR

__putc:

   ; E' = char
   ; BC' = number > 0
   ; HL  = number > 0
   ;
   ; return HL = number of bytes successfully output
   ; carry reset
    
   exx
   ld hl,0

__putc_loop:

   ld a,e
   exx
   
   ld c,a                      ; c = char to output
   
   ld a,STDIO_MSG_OTERM_PUTCHAR
   call l_jpix
   
   exx
   ret c                       ; if putc error

   inc hl
   dec bc
   
   ld a,b
   or c
   jr nz, __putc_loop

   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN STDIO_MSG_OTERM_PUTCHAR
   EXTERN l_jpix

__writ:

   ; BC' = length > 0
   ; HL' = void *buffer = byte source
   ; HL  = length > 0
   ; 
   ; return HL = number of bytes successfully output
   ; carry set on error

   exx
   ld de,0

__writ_loop:

   ld a,(hl)
   exx
   
   ld c,a
   
   ld a,STDIO_MSG_OTERM_PUTCHAR
   call l_jpix

   exx
   jr c, __writ_end

   inc de
   inc hl
   dec bc
   
   ld a,b
   or c
   jr nz, __writ_loop

__writ_end:

   push de
   exx
   pop hl                      ; hl = number of chars successfully output
   
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
