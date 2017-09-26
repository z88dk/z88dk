
; For MODEL 4000 / 4004
defc VGL_KEY_STATUS = 0xdb00
defc VGL_KEY_CURRENT = 0xdb01

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; vgl_01_input_kbd ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; This subroutine inherits the library's console_01_input
; terminal code which implements line editing and various
; other niceties.  This means this input console must be
; tied to an output terminal that understands console_01_input
; terminal messages.
;
; ;;;;;;;;;;;;;;;;;;;;
; DRIVER CLASS DIAGRAM
; ;;;;;;;;;;;;;;;;;;;;
;
; CONSOLE_01_INPUT_TERMINAL (root, abstract)
; VGL_01_INPUT_KBD (concrete)
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES CONSUMED FROM STDIO
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; * STDIO_MSG_GETC
; * STDIO_MSG_EATC
; * STDIO_MSG_READ
; * STDIO_MSG_SEEK
; * STDIO_MSG_FLSH
; * STDIO_MSG_ICTL
; * STDIO_MSG_CLOS
;
; Others result in enotsup_zc.
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES CONSUMED FROM CONSOLE_01_INPUT_TERMINAL
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; * ITERM_MSG_GETC
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES GENERATED FOR CONSOLE_01_OUTPUT_TERMINAL
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; * ITERM_MSG_PUTC
; * ITERM_MSG_PRINT_CURSOR
; * ITERM_MSG_ERASE_CURSOR
; * ITERM_MSG_BS
; * ITERM_MSG_BS_PWD
; * ITERM_MSG_READLINE_BEGIN
; * ITERM_MSG_READLINE_END
; * ITERM_MSG_BELL
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; IOCTLs UNDERSTOOD BY THIS DRIVER
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; * IOCTL_ITERM_RESET
;
; * IOCTL_ITERM_TIE
;   Attach input device to a different output terminal (0 to disconnect)
;
; * IOCTL_ITERM_GET_EDITBUF
;   Copies edit buffer details to user program
;
; * IOCTL_ITERM_SET_EDITBUF
;   Writes edit buffer details into driver
;
; * IOCTL_ITERM_ECHO
;   enable / disable echo mode
;
; * IOCTL_ITERM_PASS
;   enable / disable password mode
;
; * IOCTL_ITERM_LINE
;   enable / disable line editing mode
;
; * IOCTL_ITERM_COOK
;   enable / disable cook mode
;
; * IOCTL_ITERM_CAPS
;   set / reset caps lock
;
; * IOCTL_ITERM_CRLF
;   enable / disable crlf processing
;
; * IOCTL_ITERM_CURS
;   enable / disable cursor in line mode
;
; * IOCTL_ITERM_GET_DELAY
;
; * IOCTL_ITERM_SET_DELAY
; 
; ;;;;;;;;;;;;;;;;;;;;;;;;;;
; BYTES RESERVED IN FDSTRUCT
; ;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; offset (wrt FDSTRUCT.JP)  description
;
;    8..13                  mutex
;   14..15                  FDSTRUCT *oterm (connected output terminal, 0 if none)
;   16                      pending_char
;   17..18                  read_index (index of next char to read from edit buffer)
;   19..24                  b_array (manages edit buffer)
;   25                      getk_state
;   26                      getk_lastk
;   X 27                      getk_debounce_ms
;   X 28..29                  getk_repeatbegin_ms
;   X 30..31                  getk_repeatperiod_ms

SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC vgl_01_input_kbd

EXTERN ITERM_MSG_GETC, STDIO_MSG_FLSH, STDIO_MSG_ICTL

EXTERN console_01_input_terminal
;EXTERN zx_01_input_inkey_iterm_msg_getc
;EXTERN zx_01_input_inkey_stdio_msg_flsh
EXTERN console_01_input_stdio_msg_flsh
;EXTERN zx_01_input_inkey_stdio_msg_ictl
EXTERN console_01_input_stdio_msg_ictl, console_01_input_stdio_msg_ictl_0
EXTERN error_einval_zc, console_01_input_proc_reset

vgl_01_input_kbd:
   
   cp ITERM_MSG_GETC
   jp z, vgl_01_input_kbd_iterm_msg_getc
   
   cp STDIO_MSG_FLSH
   jp z, vgl_01_input_stdio_msg_flsh
   
   cp STDIO_MSG_ICTL
   jp z, vgl_01_input_stdio_msg_ictl
   
   jp console_01_input_terminal    ; forward to library


vgl_01_input_kbd_iterm_msg_getc:
   ;    enter : ix = & FDSTRUCT.JP
   ;
   ;     exit : a = keyboard char after character set translation
   ;            carry set on error, hl = 0 (stream error) or -1 (eof)
   ;
   ;  can use : af, bc, de, hl
   
   ld a, 0xc0
   ld (VGL_KEY_STATUS), a	; Prepare next getkey
   
   ; Wait for key press
getc_loop:
   
   
   
   ;@FIXME Intentionally loop forever, so I can see if this function is being called AT ALL
   ld a, 0x40
   out (0x0b), a
   jr getc_loop
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   
   ld a, (VGL_KEY_STATUS)
   cp 0xd0
   jr nz, getc_loop
   
   ; Get current key
   ld a, (VGL_KEY_CURRENT)
   
   ; Map to standard keys, like: ld a,CHAR_LF / CHAR_CR / CHAR_CTRL_Z
   
   ld l,a
   ld h,0                      ; a = hl = ascii code
   
   or a
   ret



vgl_01_input_stdio_msg_flsh:
   jp console_01_input_stdio_msg_flsh
   ;or a
   ;ret


vgl_01_input_stdio_msg_ictl:
   ; ioctl messages understood:
   ;
   ; defc IOCTL_RESET            = $0000
   ; defc IOCTL_ITERM_GET_DELAY  = $1081
   ; defc IOCTL_ITERM_SET_DELAY  = $1001
   ;
   ; in addition to flags managed by stdio
   ; and messages understood by base class
   ;
   ; enter : ix = & FDSTRUCT.JP
   ;         bc = first parameter
   ;         de = request
   ;         hl = void *arg (0 if stdio flags)
   ;
   ; exit  : hl = return value
   ;         carry set if ioctl rejected
   ;
   ; uses  : af, bc, de, hl
   
   ; flags managed by stdio?
   
   ld a,h
   or l
   jp z, console_01_input_stdio_msg_ictl
   
   ld a,e
   or d
   jp z, console_01_input_proc_reset   ; if IOCTL_RESET
   
   ; check the message is specifically for an input terminal
   
   ld a,e
   and $07
   cp $01                      ; input terminals are type $01
   jp nz, error_einval_zc

   ; interpret ioctl messages
   
   ld a,d
      
   cp $10
   jp nz, console_01_input_stdio_msg_ictl_0
   
   
   res 0,(ix+6)
   ret