
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; zx_01_input_kbd_inkey ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; The keyboard is read via the library's in_inkey() function.
;
;   * No ROM dependency
;   * Implements key debounce and key repeat
;   * Contains busy wait loops
;   * Very responsive
;   * Reads keyboard directly
;   * Does not return until keypress is registered
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
; ZX_01_INPUT_KBD_INKEY (concrete)
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
;   27                      getk_debounce_ms
;   28..29                  getk_repeatbegin_ms
;   30..31                  getk_repeatperiod_ms

SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC zx_01_input_kbd_inkey

EXTERN ITERM_MSG_GETC, STDIO_MSG_FLSH, STDIO_MSG_ICTL

EXTERN console_01_input_terminal
EXTERN zx_01_input_inkey_iterm_msg_getc
EXTERN zx_01_input_inkey_stdio_msg_flsh
EXTERN zx_01_input_inkey_stdio_msg_ictl

zx_01_input_kbd_inkey:

   cp ITERM_MSG_GETC
   jp z, zx_01_input_inkey_iterm_msg_getc
   
   cp STDIO_MSG_FLSH
   jp z, zx_01_input_inkey_stdio_msg_flsh
   
   cp STDIO_MSG_ICTL
   jp z, zx_01_input_inkey_stdio_msg_ictl
   
   jp console_01_input_terminal    ; forward to library
