
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
; Driver class diagram:
;
; CONSOLE_01_INPUT_TERMINAL (root, abstract)
; ZX_01_INPUT_KBD_LASTK (concrete)
;
; Consumes the following messages from console_01_input_terminal:
;
;   * ITERM_MSG_GETC
;
;     exit : a = keyboard char after character set translation
;            carry set on error, hl = 0 (stream error) or -1 (eof)
;     uses : af, bc, de, hl
;
; Consumes the following messages from stdio:
;
;   * STDIO_MSG_FLSH
;     forwards to base class
;
;   * STDIO_MSG_ICTL
;     forwards to base class
;
; IOCTLs understood by this driver (in addition to those of base):
;
;   * IOCTL_ITERM_LASTK
;     change the lastk address
;
; This driver reserves extra bytes in the FDSTRUCT:
;
; offset (wrt FDSTRUCT.JP)  description
;
;   25..26                  LASTK address
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION seg_code_fcntl

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
