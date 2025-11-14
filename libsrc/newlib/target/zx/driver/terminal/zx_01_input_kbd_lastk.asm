
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; zx_01_input_kbd_lastk ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; The keyboard is read by monitoring a specific memory address
; for an ascii code.
;
; On the spectrum target, this can be address LASTK in the
; system variables area (hence the name of this driver) but
; it can be any memory address since the memory address used
; is stored in the FDSTRUCT.
;
; Keys are expected to be supplied as follows.  An independent
; scan of the keyboard is performed in a thread separate from
; the program.  This can be done in an interrupt routine, eg.
; A successful keyscan should write the ascii code into
; memory address LASTK.  This driver will monitor that address
; for an ascii code, read it, then write 0 into LASTK to
; indicate the ascii code was consumed.  The external agent
; can implement key repeat and buffering features by
; appropriately updating address LASTK.
;
;   * No ROM dependency unless you expect the ROM to write LASTK
;   * Contains busy wait loops
;   * Responsiveness depends on how frequently LASTK is written
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
; ZX_01_INPUT_KBD_LASTK (concrete)
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
; * IOCTL_ITERM_LASTK
;   change lastk address
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
;   25..26                  LASTK address

SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC zx_01_input_kbd_lastk

EXTERN ITERM_MSG_GETC, STDIO_MSG_ICTL, STDIO_MSG_FLSH

EXTERN console_01_input_terminal
EXTERN zx_01_input_lastk_iterm_msg_getc
EXTERN zx_01_input_lastk_stdio_msg_flsh
EXTERN zx_01_input_lastk_stdio_msg_ictl

zx_01_input_kbd_lastk:

   cp ITERM_MSG_GETC
   jp z, zx_01_input_lastk_iterm_msg_getc
   
   cp STDIO_MSG_FLSH
   jp z, zx_01_input_lastk_stdio_msg_flsh
   
   cp STDIO_MSG_ICTL
   jp z, zx_01_input_lastk_stdio_msg_ictl
   
   jp console_01_input_terminal    ; forward to library
