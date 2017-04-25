
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SMS_01_OUTPUT_TERMINAL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Windowed output terminal for fixed width fonts.
;
; ;;;;;;;;;;;;;;;;;;;;
; DRIVER CLASS DIAGRAM
; ;;;;;;;;;;;;;;;;;;;;
;
; CONSOLE_01_OUTPUT_TERMINAL (root, abstract)
; SMS_01_OUTPUT_TERMINAL_BASE (abstract)
; SMS_01_OUTPUT_TERMINAL (concrete)
;
; Can be instantiated to implement a CONSOLE_01_OUTPUT_TERMINAL.
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES CONSUMED FROM STDIO
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; * STDIO_MSG_PUTC
;   Generates multiple OTERM_MSG_PUTC messages.
;
; * STDIO_MSG_WRIT
;   Generates multiple OTERM_MSG_PUTC messages.
;
; * STDIO_MSG_SEEK -> no error, do nothing
; * STDIO_MSG_FLSH -> no error, do nothing
; * STDIO_MSG_ICTL
; * STDIO_MSG_CLOS -> no error, do nothing
;
; Any other messages are reported as errors via
; error_enotsup_zc
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES CONSUMED FROM CONSOLE_01_OUTPUT_TERMINAL
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;   * OTERM_MSG_PUTC
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES CONSUMED FROM SMS_01_OUTPUT_TERMINAL_BASE
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; * OTERM_MSG_PRINTC
; * OTERM_MSG_BELL
; * OTERM_MSG_SCROLL
; * OTERM_MSG_CLS
; * OTERM_MSG_PAUSE
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES GENERATED FOR DERIVED DRIVERS
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; * OTERM_MSG_TTY (optional)
;
;     enter  :  c = char to output
;     exit   :  c = char to output (possibly modified)
;               carry reset if tty emulation absorbs char
;     can use:  af, bc, de, hl
;
;     The driver should call the tty emulation module.
;     If not implemented characters are output without processing.
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; IOCTLs UNDERSTOOD BY THIS DRIVER
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;   * IOCTL_OTERM_CRLF
;     enable / disable crlf processing
;
;   * IOCTL_OTERM_BELL
;     enable / disable terminal bell
;
;   * IOCTL_OTERM_SIGNAL
;     enable / disable signal bell
;
;   * IOCTL_OTERM_COOK
;     enable / disable cook mode (tty emulation)
;
;   * IOCTL_OTERM_PAUSE
;     enable / disable pause when window filled
;
;   * IOCTL_OTERM_PAGE
;     select scroll or page mode
;
;   * IOCTL_OTERM_CLEAR
;     enable / disable clear window when in page mode
;
;   * IOCTL_OTERM_CLS
;     clear window, set (x,y) = (0,0)
;
;   * IOCTL_OTERM_RESET_SCROLL
;     reset scroll count
;
;   * IOCTL_OTERM_GET_WINDOW_COORD
;     get coord of top left corner of window
;
;   * IOCTL_OTERM_SET_WINDOW_COORD
;     set coord of top left corner of window
;
;   * IOCTL_OTERM_GET_WINDOW_RECT
;     get window size
;
;   * IOCTL_OTERM_SET_WINDOW_RECT
;     set window size
;
;   * IOCTL_OTERM_GET_CURSOR_COORD
;
;   * IOCTL_OTERM_SET_CURSOR_COORD
;
;   * IOCTL_OTERM_GET_OTERM
;
;   * IOCTL_OTERM_SCROLL
;
;   * IOCTL_OTERM_SCREEN_MAP_ADDRESS
;
;   * IOCTL_OTERM_CHARACTER_PATTERN_OFFSET
;
;   * IOCTL_OTERM_PRINT_FLAGS
;
;   * IOCTL_OTERM_BACKGROUND_CHARACTER
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;
; BYTES RESERVED IN FDSTRUCT
; ;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; offset (wrt FDSTRUCT.JP)  description
;
;  8..13                    mutex
;   14                      x coordinate
;   15                      y coordinate
;   16                      window.x
;   17                      window.width
;   18                      window.y
;   19                      window.height
;   20                      scroll_limit
;  21/22                    screen map base address
;  23/24                    character pattern offset (in characters)
;   25                      flags: H-FLIP (bit 1), V-FLIP (bit 2), COLORHALF (bit 3), OVERSPRITES (bit 4)
;  26/27                    background character (clear screen character, absolute)

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC sms_01_output_terminal

EXTERN OTERM_MSG_PRINTC, STDIO_MSG_ICTL, OTERM_MSG_SCROLL
EXTERN OTERM_MSG_CLS, OTERM_MSG_PAUSE, OTERM_MSG_BELL

EXTERN sms_01_output_terminal_base
EXTERN sms_01_output_terminal_oterm_msg_printc
EXTERN sms_01_output_terminal_stdio_msg_ictl
EXTERN sms_01_output_terminal_oterm_msg_scroll
EXTERN sms_01_output_terminal_oterm_msg_cls
EXTERN sms_01_output_terminal_oterm_msg_pause
EXTERN sms_01_output_terminal_oterm_msg_bell

sms_01_output_terminal:

   cp OTERM_MSG_PRINTC
   jp z, sms_01_output_terminal_oterm_msg_printc

   cp STDIO_MSG_ICTL
   jp z, sms_01_output_terminal_stdio_msg_ictl

   cp OTERM_MSG_SCROLL
   jp z, sms_01_output_terminal_oterm_msg_scroll

   jp c, sms_01_output_terminal_base  ; forward to library

   cp OTERM_MSG_CLS
   jp z, sms_01_output_terminal_oterm_msg_cls
   
   cp OTERM_MSG_PAUSE
   jp z, sms_01_output_terminal_oterm_msg_pause
   
   cp OTERM_MSG_BELL
   jp z, sms_01_output_terminal_oterm_msg_bell

   jp sms_01_output_terminal_base     ; forward to library
