
; == crt symbols ==============================================

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; errno
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; stdio
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC STDIO_MSG_PUTC, STDIO_MSG_WRIT, STDIO_MSG_GETC
PUBLIC STDIO_MSG_EATC, STDIO_MSG_READ, STDIO_MSG_SEEK
PUBLIC STDIO_MSG_FLSH, STDIO_MSG_CLOS

defgroup
{
   STDIO_MSG_PUTC = 0,
   STDIO_MSG_WRIT,
   STDIO_MSG_GETC,
   STDIO_MSG_EATC,
   STDIO_MSG_READ,
   STDIO_MSG_SEEK,
   STDIO_MSG_FLSH,
   STDIO_MSG_CLOS
}

PUBLIC STDIO_SEEK_SET, STDIO_SEEK_CUR, STDIO_SEEK_END

defc STDIO_SEEK_SET = 0
defc STDIO_SEEK_CUR = 1
defc STDIO_SEEK_END = 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sys/ioctl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC IOCTL_TERMINAL_ECHO, IOCTL_TERMINAL_PASSWORD, IOCTL_TERMINAL_RESET

defc IOCTL_TERMINAL_ECHO     = $81
defc IOCTL_TERMINAL_PASSWORD = $41
defc IOCTL_TERMINAL_FLAGS    = $f9

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; threads
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

; =============================================================
