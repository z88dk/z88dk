
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; crt symbols ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; errno
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   PUBLIC __EOK, __EDOM, __EINVAL, __ENOMEM, __ERANGE
   PUBLIC __EACCES, __ENOLCK, __EOVERFLOW, __ENOTSUP
   PUBLIC __EFBIG, __EBADF, __EMFILE, __EUNKWN

   defgroup
   {
      __EOK = 0,
      __EDOM,
      __EINVAL,
      __ENOMEM,
      __ERANGE,
      __EACCES,
      __ENOLCK,
      __EOVERFLOW,
      __ENOTSUP,
      __EFBIG,
      __EBADF,
      __EMFILE,
      __EUNKWN
   }

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; stdio
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   PUBLIC STDIO_MSG_PUTC, STDIO_MSG_WRIT, STDIO_MSG_GETC
   PUBLIC STDIO_MSG_EATC, STDIO_MSG_READ, STDIO_MSG_SEEK
   PUBLIC STDIO_MSG_ICTL, STDIO_MSG_FLSH, STDIO_MSG_CLOS

   PUBLIC STDIO_MSG_ITERM_GETCHAR
   PUBLIC STDIO_MSG_OTERM_L1, STDIO_MSG_OTERM_PUTCHAR

   defgroup
   {
      STDIO_MSG_PUTC = 0,
      STDIO_MSG_WRIT,
      STDIO_MSG_GETC,
      STDIO_MSG_EATC,
      STDIO_MSG_READ,
      STDIO_MSG_SEEK,
      STDIO_MSG_ICTL,
      STDIO_MSG_FLSH,
      STDIO_MSG_CLOS,
      STDIO_MSG_ITERM_GETCHAR,
      STDIO_MSG_OTERM_L1,
      STDIO_MSG_OTERM_PUTCHAR
   }

   PUBLIC STDIO_SEEK_SET, STDIO_SEEK_CUR, STDIO_SEEK_END

   defc STDIO_SEEK_SET = 0
   defc STDIO_SEEK_CUR = 1
   defc STDIO_SEEK_END = 2

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; sys/ioctl
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   PUBLIC IOCTL_ITERM_ECHO, IOCTL_ITERM_PASS, IOCTL_ITERM_LINE
   PUBLIC IOCTL_ITERM_COOK, IOCTL_ITERM_CAPS, IOCTL_ITERM_CRLF
   PUBLIC IOCTL_ITERM_CURS
   PUBLIC IOCTL_ITERM_SETF, IOCTL_ITERM_STFM
   PUBLIC IOCTL_ITERM_GETF, IOCTL_ITERM_GTFM
   PUBLIC IOCTL_ITERM_TIE

   defc IOCTL_ITERM_ECHO = $c081
   defc IOCTL_ITERM_PASS = $c041
   defc IOCTL_ITERM_LINE = $c021
   defc IOCTL_ITERM_COOK = $c011
   defc IOCTL_ITERM_CAPS = $c009
   defc IOCTL_ITERM_CRLF = $c101
   defc IOCTL_ITERM_CURS = $c201

   defc IOCTL_ITERM_SETF = $bff9
   defc IOCTL_ITERM_STFM = $8001
   defc IOCTL_ITERM_GETF = $7ff9
   defc IOCTL_ITERM_GTFM = $4001
   
   defc IOCTL_ITERM_TIE  = $0001

   PUBLIC IOCTL_OTERM_COOK
   PUBLIC IOCTL_OTERM_SETF, IOCTL_OTERM_STFM
   PUBLIC IOCTL_OTERM_GETF, IOCTL_OTERM_GTFM
   PUBLIC IOCTL_OTERM_FONT

   defc IOCTL_OTERM_COOK = $c012

   defc IOCTL_OTERM_SETF = $bffa
   defc IOCTL_OTERM_STFM = $8002
   defc IOCTL_OTERM_GETF = $7ffa
   defc IOCTL_OTERM_GTFM = $4002

   defc IOCTL_OTERM_FONT = $0002

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
