
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; library constants ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; error
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   ; keep consistent with "errno.h"
   
   PUBLIC __EOK, __EACCES, __EBADF
   PUBLIC __EBDFD, __EDOM, __EFBIG
   PUBLIC __EINVAL, __EMFILE, __ENFILE
   PUBLIC __ENOLCK, __ENOMEM, __ENOTSUP
   PUBLIC __EOVERFLOW, __ERANGE
   
   defgroup
   {
      __EOK = 0,
      __EACCES,
      __EBADF,
      __EBDFD,
      __EDOM,
      __EFBIG,
      __EINVAL,
      __EMFILE,
      __ENFILE,
      __ENOLCK,
      __ENOMEM,
      __ENOTSUP,
      __EOVERFLOW,
      __ERANGE,
      
      ; define next error number for targets
      
      __ERROR_NEXT__ = 50
   }
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; stdio
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   ; must not be changed consistent with "stdio.h"
   
   PUBLIC STDIO_SEEK_SET, STDIO_SEEK_CUR, STDIO_SEEK_END

   defc STDIO_SEEK_SET = 0
   defc STDIO_SEEK_CUR = 1
   defc STDIO_SEEK_END = 2
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; threads
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   PUBLIC mtx_plain, mtx_recursive, mtx_timed

   defc mtx_plain     = $01
   defc mtx_recursive = $02
   defc mtx_timed     = $04

   PUBLIC thrd_success, thrd_error, thrd_nomem
   PUBLIC thrd_busy, thrd_timedout

   defc thrd_success  = $0000
   defc thrd_error    = $0001
   defc thrd_nomem    = $0002
   defc thrd_busy     = $0004
   defc thrd_timedout = $0008

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; messages
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   ; relative sequence of these messages is significant
   ; but can insert other messages as needed
   
   PUBLIC STDIO_MSG_PUTC, STDIO_MSG_WRIT, STDIO_MSG_GETC
   PUBLIC STDIO_MSG_EATC, STDIO_MSG_READ, STDIO_MSG_SEEK
   PUBLIC STDIO_MSG_ICTL, STDIO_MSG_FLSH, STDIO_MSG_CLOS
   
   PUBLIC ITERM_MSG_GETC, ITERM_MSG_PUTC, ITERM_MSG_PRINT_CURSOR
   PUBLIC ITERM_MSG_ERASE_CURSOR, ITERM_MSG_BS, ITERM_MSG_BS_PWD
   PUBLIC ITERM_MSG_READLINE_BEGIN, ITERM_MSG_READLINE_END, ITERM_MSG_BELL
   PUBLIC ITERM_MSG_ERASE_CURSOR_PWD, ITERM_MSG_INTERRUPT
   
   PUBLIC OTERM_MSG_PUTC, OTERM_MSG_TTY, OTERM_MSG_PRINTC
   PUBLIC OTERM_MSG_SCROLL, OTERM_MSG_CLS, OTERM_MSG_PAUSE
   PUBLIC OTERM_MSG_BELL, OTERM_MSG_PSCROLL
   
   defgroup
   {
      ; stdio messages
      
      STDIO_MSG_PUTC = 1,
      STDIO_MSG_WRIT,
      STDIO_MSG_GETC,
      STDIO_MSG_EATC,
      STDIO_MSG_READ,
      STDIO_MSG_SEEK,
      STDIO_MSG_ICTL,
      STDIO_MSG_FLSH,
      STDIO_MSG_CLOS,
      
      ; input terminal messages
      
      ITERM_MSG_GETC = 15,
      ITERM_MSG_INTERRUPT,
      ITERM_MSG_PUTC,
      ITERM_MSG_PRINT_CURSOR,
      ITERM_MSG_ERASE_CURSOR,
      ITERM_MSG_ERASE_CURSOR_PWD,
      ITERM_MSG_BS,
      ITERM_MSG_BS_PWD,
      ITERM_MSG_READLINE_BEGIN,
      ITERM_MSG_READLINE_END,
      ITERM_MSG_BELL,
      
      __MESSAGE_ITERM_NEXT__,
      
      ; output terminal messages
      
      OTERM_MSG_PUTC = 30,
      OTERM_MSG_TTY,
      OTERM_MSG_PRINTC,
      OTERM_MSG_SCROLL,
      OTERM_MSG_CLS,
      OTERM_MSG_PAUSE,
      OTERM_MSG_BELL,
      OTERM_MSG_PSCROLL,
      
      __MESSAGE_OTERM_NEXT__,
      
      ; define next message id for targets
      
      __MESSAGE_NEXT__ = 45
   
   }

   ; serial character i/o messages
   
   PUBLIC ICHAR_MSG_GETC
   PUBLIC OCHAR_MSG_PUTC_BIN, OCHAR_MSG_PUTC
   
   defc ICHAR_MSG_GETC     = ITERM_MSG_GETC
   defc OCHAR_MSG_PUTC_BIN = OTERM_MSG_PUTC
   defc OCHAR_MSG_PUTC     = OTERM_MSG_PRINTC
   

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; ioctls
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   ; bit patterns are significant, consistent with "ioctl.h"
   
   ; all devices, FILE type = $00
   
   PUBLIC IOCTL_RESET
   
   defc IOCTL_RESET = $0000
   
   ; console_01_input_terminal, FILE type = $01
   
   PUBLIC IOCTL_ITERM_ECHO, IOCTL_ITERM_PASS, IOCTL_ITERM_LINE
   PUBLIC IOCTL_ITERM_COOK, IOCTL_ITERM_CAPS, IOCTL_ITERM_CRLF
   PUBLIC IOCTL_ITERM_CURS
   
   defc IOCTL_ITERM_ECHO = $c081
   defc IOCTL_ITERM_PASS = $c041
   defc IOCTL_ITERM_LINE = $c021
   defc IOCTL_ITERM_COOK = $c011
   defc IOCTL_ITERM_CAPS = $c009
   defc IOCTL_ITERM_CRLF = $c101
   defc IOCTL_ITERM_CURS = $c201
   
   PUBLIC IOCTL_ITERM_TIE, IOCTL_ITERM_GET_EDITBUF, IOCTL_ITERM_SET_EDITBUF
   
   defc IOCTL_ITERM_TIE         = $0201
   defc IOCTL_ITERM_GET_EDITBUF = $0381
   defc IOCTL_ITERM_SET_EDITBUF = $0301
   
   ; console_01_output_terminal, FILE type = $02
   
   PUBLIC IOCTL_OTERM_PAGE, IOCTL_OTERM_PAUSE, IOCTL_OTERM_COOK
   PUBLIC IOCTL_OTERM_CRLF, IOCTL_OTERM_CLEAR, IOCTL_OTERM_SIGNAL
   PUBLIC IOCTL_OTERM_BELL
   
   defc IOCTL_OTERM_PAGE   = $c082
   defc IOCTL_OTERM_PAUSE  = $c042
   defc IOCTL_OTERM_COOK   = $c022
   defc IOCTL_OTERM_CRLF   = $c012
   defc IOCTL_OTERM_CLEAR  = $e002
   defc IOCTL_OTERM_SIGNAL = $c202
   defc IOCTL_OTERM_BELL   = $c102
   
   PUBLIC IOCTL_OTERM_CLS, IOCTL_OTERM_RESET_SCROLL
   PUBLIC IOCTL_OTERM_GET_WINDOW_COORD, IOCTL_OTERM_SET_WINDOW_COORD
   PUBLIC IOCTL_OTERM_GET_WINDOW_RECT, IOCTL_OTERM_SET_WINDOW_RECT
   PUBLIC IOCTL_OTERM_GET_CURSOR_COORD, IOCTL_OTERM_SET_CURSOR_COORD
   PUBLIC IOCTL_OTERM_GET_OTERM, IOCTL_OTERM_SCROLL, IOCTL_OTERM_FONT
   
   defc IOCTL_OTERM_CLS              = $0102
   defc IOCTL_OTERM_RESET_SCROLL     = $0202
   defc IOCTL_OTERM_GET_WINDOW_COORD = $0382
   defc IOCTL_OTERM_SET_WINDOW_COORD = $0302
   defc IOCTL_OTERM_GET_WINDOW_RECT  = $0482
   defc IOCTL_OTERM_SET_WINDOW_RECT  = $0402
   defc IOCTL_OTERM_GET_CURSOR_COORD = $0582
   defc IOCTL_OTERM_SET_CURSOR_COORD = $0502
   defc IOCTL_OTERM_GET_OTERM        = $0602
   defc IOCTL_OTERM_SCROLL           = $0702
   defc IOCTL_OTERM_FONT             = $0802
   
   PUBLIC IOCTL_OTERM_FZX_GET_PAPER_COORD, IOCTL_OTERM_FZX_SET_PAPER_COORD
   PUBLIC IOCTL_OTERM_FZX_GET_PAPER_RECT, IOCTL_OTERM_FZX_SET_PAPER_RECT
   PUBLIC IOCTL_OTERM_FZX_LEFT_MARGIN, IOCTL_OTERM_FZX_LINE_SPACING
   PUBLIC IOCTL_OTERM_FZX_SPACE_EXPAND
   PUBLIC IOCTL_OTERM_FZX_GET_FZX_STATE, IOCTL_OTERM_FZX_SET_FZX_STATE
   
   defc IOCTL_OTERM_FZX_GET_PAPER_COORD = $0a82
   defc IOCTL_OTERM_FZX_SET_PAPER_COORD = $0a02
   defc IOCTL_OTERM_FZX_GET_PAPER_RECT  = $0b82
   defc IOCTL_OTERM_FZX_SET_PAPER_RECT  = $0b02
   defc IOCTL_OTERM_FZX_LEFT_MARGIN     = $0c02
   defc IOCTL_OTERM_FZX_LINE_SPACING    = $0d02
   defc IOCTL_OTERM_FZX_SPACE_EXPAND    = $0e02
   defc IOCTL_OTERM_FZX_GET_FZX_STATE   = $0f82
   defc IOCTL_OTERM_FZX_SET_FZX_STATE   = $0f02

   ; character_00_input, FILE type = $03
   
   PUBLIC IOCTL_ICHAR_CRLF
   
   defc IOCTL_ICHAR_CRLF = $c103
   
   ; character_00_output, FILE type = $04
   
   PUBLIC IOCTL_OCHAR_CRLF
   
   defc IOCTL_OCHAR_CRLF = $c014

;; end library constants ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
