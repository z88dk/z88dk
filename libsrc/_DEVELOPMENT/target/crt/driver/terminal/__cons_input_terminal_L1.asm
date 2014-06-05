
; May 2014 aralbrec

; CONSOLE INPUT TERMINAL LEVEL 1
;
; This partial driver is supplied by the library to
; ease the writing of console drivers.
;
; The features of the level 1 console include:
;
; * Terminal driver flags implemented
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
;   - cursor on/off
;
;     To disable the cursor in line mode.
;
; A level 1 input console must be paired with a level 1
; output console so that exchanged messages are understood.

; FILE *input_terminal
;
; offset  size   desription
;
;  13,14   2     driver flags
;  15,16   2     terminal state *

; terminal state
;
; offset  size   description
;
;   0,1    2     FILE *output_terminal_L1 (0 if untied)
;   2,3    2     edit buffer address
;   4,5    2     edit buffer ptr (read from)
;    6     1     edit buffer len

; messages to input terminal
;
; STDIO_MSG_ITERM_GETCHAR
; can modify af, hl
;
;   return a = hl = char read from device, carry reset

; messages to output terminal
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

PUBLIC __cons_input_terminal_L1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN STDIO_MSG_GETC, STDIO_MSG_EATC
   EXTERN STDIO_MSG_READ, STDIO_MSG_SEEK
   EXTERN STDIO_MSG_FLSH, STDIO_MSG_CLOS
   EXTERN STDIO_MSG_ICTL
   
   EXTERN error_enotsup_zc, error_znc

__cons_input_terminal_L1:

   ; implement level 1 input console
   
   cp STDIO_MSG_GETC
   jr z, __getc
   
   cp STDIO_MSG_EATC
   jp z, __eatc
   
   cp STDIO_MSG_READ
   jr z, __read
   
   cp STDIO_MSG_SEEK
   jr z, __seek
   
   cp STDIO_MSG_FLSH
   jr z, __flsh
   
   cp STDIO_MSG_CLOS
   jp z, error_znc             ; do nothing, report no error
   
   cp STDIO_MSG_ICTL
   jr z, __ictl

__enotsup_zc:

   jp error_enotsup_zc         ; hl = 0 puts stream in error state except for ICTL
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN IOCTL_ITERM_TIE
   EXTERN l_ltu_bc_de, error_enotsup_zc

__ictl:

   ; DE = command
   ; BC = first parameter
   ; HL = arg
   ;
   ; exit carry set if ioctl not understood

;;   ld hl,IOCTL_ITERM_TIE
;;   sbc hl,de
;;   jr nz, __ictl_flags         ; if not IOCTL_ITERM_TIE

__ict_flags:

   ; if line mode is being disabled we need to reset the edit buffer

   bit 7,d
   jr z, __enotsup_zc          ; if command does not affect terminal flags

   ld a,e
   and $07
   dec a
   jr nz, __enotsup_zc         ; if command is not specific to ITERMs
   
   ld a,e
   and $20
   jr z, __enotsup_zc          ; if line mode flag unaffected
   
   and c
   and $20
   jr nz, __enotsup_zc         ; if line mode is not being disabled
   
   ; fall through

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__flsh:

   ; exit with carry reset to indicate no error

   ; clear the edit buffer
   
   ld l,(ix+15)
   ld h,(ix+16)                ; hl = terminal state *
   
   inc hl
   inc hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = address of edit buffer
   inc hl
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; edit buffer ptr = start of edit buffer

   ld a,d
   or e
   ret z                       ; if there is no edit buffer

   xor a
   ld (de),a

   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN STDIO_SEEK_CUR
   EXTERN error_lznc

__seek:

   ; stdio uses seek forward to ignore input chars for %*[n]c
 
   ;    C = STDIO_SEEK_SET (0), STDIO_SEEK_CUR (1), STDIO_SEEK_END (2)
   ; DEHL'= file offset
   ;    C'= STDIO_SEEK_SET (0), STDIO_SEEK_CUR (1), STDIO_SEEK_END (2)
   ;
   ; return DEHL = current position, carry on error

   exx
   
   ld a,c
   
   CP STDIO_SEEK_CUR
   jp nz, error_lznc           ; if not seeking forward, do nothing

   bit 7,d
   jp nz, error_lznc           ; if negative offset, do nothing
   
   ; dehl = number of chars to seek past
   ; if de != 0 the universe will be over before we are done so ignore it

   ex de,hl                    ; de = number of chars to consume

__seek_loop:

   ld a,d
   or e
   jp z, error_lznc            ; if num chars == 0

   dec de
   call __cons_input_getc
   
   bit 5,(ix+13)
   jr nz, __seek_loop          ; if in line mode echo is done elsewhere
   
   push de
   call __cons_input_echo
   pop de
   
   jr __seek_loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__getc:

   ; return HL = char
   ; carry set on error with HL=0 for stream error, -1 for eof

   call __cons_input_getc
   
   bit 5,(ix+13)
   ret nz                      ; if in line mode echo is done elsewhere
   
   push hl
   call __cons_input_echo
   pop hl
   
   or a
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__read:

   ; DE'= void *buffer = byte destination
   ; BC'= max_length > 0
   ; HL = max_length > 0
   ;
   ; return BC = number of bytes successfully read
   ;        DE'= void *buffer_ptr = address of byte following last written
   ;        carry set on error with HL=0 for stream error, -1 for eof
   
   exx
   
__read_loop:

   ld a,b
   or c
   jr z, __read_exit           ; if no more chars to read
   
   dec bc                      ; num chars to read -= 1
   call __cons_input_getc
   
   ld (de),a                   ; write char to buffer
   inc de

   bit 5,(ix+13)
   jr nz, __read_loop          ; if in line mode echo is done elsewhere

   push bc
   push de
   
   call __cons_input_echo
   
   pop de
   pop bc
   
   jr __read_loop

__read_exit:

   exx
   
   ld c,l
   ld b,h                      ; bc = max_length (read full amount)
   
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN l_jphl

__eatc:

   ; read chars from the stream until one is disqualified
   ;
   ; HL'= int (*qualify)(char c)
   ; BC'= optional
   ; DE'= optional
   ; HL = max_length = max number of stream chars to consume
   ; 
   ; return: BC = number of bytes consumed from stream
   ;         HL = next unconsumed (unmatching) char or EOF
   ;         BC'= unchanged by driver
   ;         DE'= unchanged by driver
   ;         HL'= unchanged by driver

   ld c,l
   ld b,h                      ; bc = max num chars to consume
   
   ld de,-1                    ; de = num chars consumed - 1
   
__eatc_loop:

   inc de                      ; de = num chars consumed
   call __cons_input_getc      ; a = hl = char
   
   ld a,b
   or c
   jr z, __eatc_exit           ; if max num reached
   
   ld a,l                      ; a = char
   exx
   call l_jphl                 ; qualify(a)
   exx
   
   jr c, __eatc_exit           ; if char is disqualified
   dec bc                      ; num chars remaining to consume -= 1
   
   bit 5,(ix+13)
   jr nz, __eatc_loop          ; if in line mode echo is done elsewhere
   
   push bc
   push de
   
   ld a,l
   call __cons_input_echo
   
   pop de
   pop bc

   jr __eatc_loop

__eatc_exit:

   ; de = num chars consumed from stream
   ; hl = next unconsumed char

   ld c,e
   ld b,d                      ; bc = num chars consumed

   or a
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__cons_input_getc:

   ; exit : a = hl = char
   ;        carry reset always succeeds
   ;
   ; uses : af, hl

   bit 5,(ix+13)
   jr nz, __cons_input_getc_line  ; if in line mode

__cons_input_getc_loop:

   call __cons_input_getc_raw
   ret nc

   jr __cons_input_getc_loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN STDIO_MSG_ITERM_GETCHAR
   EXTERN l_jpix
   
__cons_input_getc_raw:

   ; read a char from the device

   ; exit : a = hl = char
   ;        carry set if char consumed locally
   ;        always succeeds
   ;
   ; uses : af, hl

   ld a,STDIO_MSG_ITERM_GETCHAR
   call l_jpix                 ; get char from driver

   bit 4,(ix+13)
   jp nz, __cons_input_cook    ; process char

   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__cons_input_getc_line:

   ; implements an edit buffer for input terminals
   ; allows backspace for editing
   ;
   ; exit : a = hl = char
   ;        carry reset alway succeeds
   ;
   ; uses : af, hl

   push bc
   push de
   push ix
   
   ld e,(ix+15)
   ld d,(ix+16)
   
   ld ixl,e
   ld ixh,d                    ; ix = terminal state *

   ld a,(ix+6)                 ; a = buffer length
   cp 3
   jr c, __no_edit_buffer      ; if edit buffer is zero size
   
__check_edit_buffer:

   ld e,(ix+4)
   ld d,(ix+5)                 ; de = edit_buf ptr
   
   ld a,d
   or e
   jr z, __no_edit_buffer
   
   ld a,(de)
   or a
   jr z, __read_line           ; if the edit buffer is empty

__read_line_done:

   ; use char from edit buffer
   
   inc de
   
   ld (ix+4),e
   ld (ix+5),d                 ; increase edit_buf ptr
   
   ld l,a
   ld h,0
   
   pop ix
   pop de
   pop bc
   
   ret

__no_edit_buffer:

   pop ix
   
   call __cons_input_getc_loop
   
   push af
   push hl
   
   call __cons_input_echo
   
   pop hl
   pop af
   
   pop de
   pop bc
   
   ret

__read_line:

   ; edit buffer is empty
   
   ; ix = terminal state *
   
   ld e,(ix+2)
   ld d,(ix+3)                 ; de = address of edit buffer
   
   ex (sp),ix
   push de
   
   ld b,4                      ; inform output terminal a read line is starting
   call __cons_output_tie

   pop de
   ex (sp),ix

   ld b,0                      ; how many chars are in the buffer
   
   ld c,(ix+6)
   dec c
   dec c                       ; c = how much space remaining in buffer

   ex (sp),ix

__read_line_loop:

   ;  b = number of chars in buffer
   ;  c = remaining space in buffer
   ; de = current position in buffer
   ; ix = FILE *
   ; stack = terminate state *

   bit 1,(ix+14)
   jr nz, __read_line_cursor   ; if cursor is enabled

   call __cons_input_getc_loop
   jr __read_line_char

__read_line_cursor:

   ; cursor & getchar
   
   push bc
   push de

   ld a,(ix+13)
   and $18
   cp $18                      ; check if caps lock and cook enabled
   
   ld a,'_'
   jr nz, __cursor_set         ; if caps lock disabled
   ld a,'-'

__cursor_set:
   
   ld (de),a
   
   call __cons_input_echo_cursor
   call __cons_input_getc_raw ; read char
   
   pop de
   push de
   push af
   
   or a
   ld a,(de)

   call __cons_input_backspace_cursor
   
   pop af   
   pop de
   pop bc

   jr c, __read_line_cursor    ; if char was consumed by console

__read_line_char:

   ; check for backspace

   cp 12
   jr z, __backspace
   
   cp 8
   jr z, __backspace
   
   ; consume the char
   
   ld (de),a
   
   cp 13
   jr z, __line_end
   
   inc c
   dec c
   jr z, __read_line_loop      ; if edit buffer is full
   
   inc b
   dec c
   inc de
   
   push bc
   push de
   
   call __cons_input_echo
   
   pop de
   pop bc
   
   jr __read_line_loop

__backspace:

   inc b
   dec b
   jr z, __read_line_loop      ; if already at beginning of buffer
   
   dec b
   inc c
   dec de
   
   push bc
   push de
   
   ld a,(de)
   call __cons_input_backspace
   
   pop de
   pop bc
   
   xor a
   ld (de),a
   
   jr __read_line_loop

__line_end:

   ld c,a
   
   xor a
   inc de
   ld (de),a
   
   ld a,c
   call __cons_input_echo
   
   ex (sp),ix                  ; ix = terminal state *
   
   ld e,(ix+2)
   ld d,(ix+3)                 ; de = start of edit_buf
   
   ld a,(de)
   jp __read_line_done

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN asm_toupper

__cons_input_cook:

   ; level 1 console intercepts caps lock

   ; enter : a = hl = char
   ;
   ; exit  : a = hl = char
   ;         carry if char consumed
   ;
   ; uses  : af, hl

   ; check for caps lock
   
   cp 6
   jr z, __caps_lock

   ; check if caps lock active
   
   or a
   
   bit 3,(ix+13)
   ret z                       ; if caps lock is inactive
   
   call asm_toupper
   
   ld l,a
   
   or a
   ret

__caps_lock:

   ld a,(ix+13)
   xor $08
   ld (ix+13),a
   
   scf
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__cons_input_echo:

   ; enter : a = char
   ;
   ; uses  : af, bc, de, hl

   call __echo_process_char

__cons_input_echo_cursor:

   bit 7,(ix+13)
   ret z                       ; if echo is off

   ld b,1                      ; select __cons_output_putc
   jr __cons_output_tie

__echo_process_char:

   cp 13
   ret z
   
   or a
   
   bit 6,(ix+13)
   ret z                       ; if not password mode
   
   ld a,'*'
   
   scf                         ; indicate password mode
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__cons_input_backspace:

   ; enter :  a = char to erase
   ;         de = address of char to erase in edit buf
   ;
   ; uses  : af, bc, de, hl

   call __echo_process_char

__cons_input_backspace_cursor:

   bit 7,(ix+13)
   ret z                       ; if echo is off
   
   ld b,2                      ; select __cons_output_backspace
   jr nc, __cons_output_tie
   
   inc b                       ; select __cons_output_backspace_pwd

   ; fall through

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN STDIO_MSG_OTERM_L1
   EXTERN l_jpix

__cons_output_tie:

   ; enter :  b = 1 for __cons_output_putc
   ;          b = 2 for __cons_output_backspace
   ;          b = 3 for __cons_output_backspace_pwd
   ;          b = 4 for input console starting read line
   ;         ix = FILE *
   ;         registers other than a,hl with parameters
   ;
   ; uses  : at most af, bc, de, hl

   push ix
   push de

   ld l,(ix+15)
   ld h,(ix+16)                ; hl = terminal state *

   ld e,(hl)
   inc hl
   ld d,(hl)
   
   ld c,a
   
   ld a,d
   or e
   
   ld ixl,e
   ld ixh,d                    ; ix = FILE *output
   
   pop de
   jr z, __output_invalid

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN __stdio_lock_acquire

   call __stdio_lock_acquire
   jr c, __output_invalid

   ; have a lock but the attached output file may
   ; have changed while waiting for it
   
   ld a,(hl)
   cp ixh
   jr nz, __output_fail
   
   dec hl
   ld a,(hl)
   cp ixl
   jr nz, __output_fail

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   ld a,STDIO_MSG_OTERM_L1
   call l_jpix

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN __stdio_lock_release

__output_fail:

   call __stdio_lock_release

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__output_invalid:

   pop ix
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
