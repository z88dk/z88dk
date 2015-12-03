
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CONSOLE_01_OUTPUT_TERMINAL_FZX
; library driver for output fzx terminals
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Windowed output terminal for proportional fzx fonts.
;
; ;;;;;;;;;;;;;;;;;;;;
; DRIVER CLASS DIAGRAM
; ;;;;;;;;;;;;;;;;;;;;
;
; CONSOLE_01_OUTPUT_TERMINAL (root, abstract)
; CONSOLE_01_OUTPUT_TERMINAL_FZX (abstract)
;
; This driver implements most of the functions necessary
; for proprtional fzx output terminals, including
; consuming messages delivered from an attached
; CONSOLE_01_INPUT_TERMINAL.  
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
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES CONSUMED FROM CONSOLE_01_INPUT_TERMINAL
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;   * ITERM_MSG_PUTC
;   * ITERM_MSG_PRINT_CURSOR
;   * ITERM_MSG_BS
;   * ITERM_MSG_BS_PWD
;   * ITERM_MSG_ERASE_CURSOR
;   * ITERM_MSG_ERASE_CURSOR_PWD
;   * ITERM_MSG_READLINE_BEGIN
;   * ITERM_MSG_READLINE_END
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGES GENERATED FOR DERIVED DRIVERS
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;   * OTERM_MSG_TTY (optional)
;
;     enter  :  c = char to output
;     exit   :  c = char to output (possibly modified)
;               carry reset if tty emulation absorbs char
;     can use:  af, bc, de, hl
;
;     The driver should call the tty emulation module.
;     If not implemented characters are output without processing.
;
;   * OTERM_MSG_BELL (optional)
;
;     can use:  af, bc, de, hl
;
;     Sound the terminal's bell.
;
;   * OTERM_MSG_PSCROLL
;
;     enter  :  hl = number of pixels to scroll
;     exit   :  hl = actual number if pixels scrolled
;               else carry set if screen clears
;     can use:  af, bc, de, hl
;
;     Scroll the window upward at least hl pixels
;
;   * OTERM_MSG_CLS
;
;     can use:  af, bc, de, hl
;
;     Clear the window.
;
;   * OTERM_MSG_PAUSE
;
;     can use:  af, bc, de, hl
;
;     The scroll count has reached zero so the driver
;     should pause the output somehow.
;
;   * ITERM_MSG_BELL (optional)
;
;     can use:  af, bc, de, hl
;
;     The input terminal generates this message to
;     indicate the edit buffer is either empty or full.
;     The output terminal generates this message to
;     indicate the output window is full and is being paused.
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
; THE FZX WINDOW IS THE AREA THAT IS CLEARED AND SCROLLED
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
;   * IOCTL_OTERM_FONT
;
; THE FZX PAPER IS THE AREA WHERE PRINTING OCCURS
; THE FZX WINDOW CONTAINS THE FZX PAPER
;
;   * IOCTL_OTERM_FZX_GET_PAPER_COORD
;     get coord of top left corner of paper
;
;   * IOCTL_OTERM_FZX_SET_PAPER_COORD
;     set coord of top left corner of paper
;
;   * IOCTL_OTERM_FZX_GET_PAPER_RECT
;     get paper size
;
;   * IOCTL_OTERM_FZX_SET_PAPER_RECT
;     set paper size
;
;   * IOCTL_OTERM_FZX_LEFT_MARGIN
;;
;   * IOCTL_OTERM_FZX_LINE_SPACING
;
;   * IOCTL_OTERM_FZX_SPACE_EXPAND
;
;   * IOCTL_OTERM_FZX_GET_FZX_STATE
;
;   * IOCTL_OTERM_FZX_SET_FZX_STATE
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;
; BYTES RESERVED IN FDSTRUCT
; ;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; offset (wrt FDSTRUCT.JP)  description
;
;  8..13                    mutex
; 14..15                    reserved
;   16                      window.x
;   17                      window.width
;   18                      window.y
;   19                      window.height
;   20                      scroll_limit
;   21                      line_spacing
;   22                      temp: cursor ascii code
; 23..24                    temp: fzx_draw mode
; 25..26                    temp: edit x coord
; 27..28                    temp: edit y coord
;   29                      temp: space_expand
;
;   30                      JP
; 31..32                    fzx_draw
; 33..34                    struct fzx_font *
; 35..36                    x coordinate
; 37..38                    y coordinate
; 39..40                    paper.x
; 41..42                    paper.width
; 43..44                    paper.y
; 45..46                    paper.height
; 47..48                    left_margin
;   49                      space_expand
; 50..51                    reserved

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_terminal_fzx

EXTERN console_01_output_terminal, error_zc, console_01_output_fzx_stdio_msg_ictl
EXTERN console_01_output_fzx_oterm_msg_putc, console_01_output_fzx_iterm_msg_putc
EXTERN console_01_output_fzx_iterm_msg_bs, console_01_output_fzx_iterm_msg_bs_pwd
EXTERN console_01_output_fzx_iterm_msg_print_cursor, console_01_output_fzx_iterm_msg_erase_cursor
EXTERN console_01_output_fzx_iterm_msg_readline_begin, console_01_output_fzx_iterm_msg_readline_end
EXTERN console_01_output_fzx_iterm_msg_erase_cursor_pwd

EXTERN OTERM_MSG_TTY, OTERM_MSG_BELL, ITERM_MSG_BELL
EXTERN OTERM_MSG_PUTC, STDIO_MSG_ICTL, ITERM_MSG_PUTC, ITERM_MSG_BS, ITERM_MSG_READLINE_BEGIN
EXTERN ITERM_MSG_BS_PWD, ITERM_MSG_PRINT_CURSOR, ITERM_MSG_ERASE_CURSOR, ITERM_MSG_READLINE_END
EXTERN ITERM_MSG_ERASE_CURSOR_PWD

console_01_output_terminal_fzx:

   ; messages generated by stdio

   cp OTERM_MSG_PUTC
   jp z, console_01_output_fzx_oterm_msg_putc

cp OTERM_MSG_TTY   ;; prevent error generation for unimplemented message
jp z, error_zc     ;; placed further up to speed up putchar

   cp STDIO_MSG_ICTL
   jp z, console_01_output_fzx_stdio_msg_ictl
   
   ; messages generated by input terminal
   
   cp ITERM_MSG_PUTC
   jp z, console_01_output_fzx_iterm_msg_putc
   
   jp c, console_01_output_terminal    ; forward to library
   
   cp ITERM_MSG_BS
   jp z, console_01_output_fzx_iterm_msg_bs
   
   cp ITERM_MSG_BS_PWD
   jp z, console_01_output_fzx_iterm_msg_bs_pwd
   
   cp ITERM_MSG_PRINT_CURSOR
   jp z, console_01_output_fzx_iterm_msg_print_cursor
   
   cp ITERM_MSG_ERASE_CURSOR
   jp z, console_01_output_fzx_iterm_msg_erase_cursor
   
   cp ITERM_MSG_ERASE_CURSOR_PWD
   jp z, console_01_output_fzx_iterm_msg_erase_cursor_pwd
   
   cp ITERM_MSG_READLINE_BEGIN
   jp z, console_01_output_fzx_iterm_msg_readline_begin
   
   cp ITERM_MSG_READLINE_END
   jp z, console_01_output_fzx_iterm_msg_readline_end
   
   ; prevent error generation for unimplemented optional messages
   
;; cp OTERM_MSG_TTY   ;; moved further up because it's a commonly issued message
;; jp z, error_zc
   
   cp OTERM_MSG_BELL
   jp z, error_zc
   
   cp ITERM_MSG_BELL
   jp z, error_zc
   
   jp console_01_output_terminal       ; forward to library
