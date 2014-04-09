
; == crt defines ==============

;;;;;;;;
;; errno
;;;;;;;;

XDEF __EOK, __EDOM, __EINVAL, __ENOMEM, __ERANGE
XDEF __EACCES, __ENOLCK, __EOVERFLOW, __ENOTSUP
XDEF __EFBIG, __EBADF, __EMFILE, __EUNKWN

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


;;;;;;;;
;; stdio
;;;;;;;;

XDEF STDIO_MSG_PUTC, STDIO_MSG_WRIT, STDIO_MSG_GETC
XDEF STDIO_MSG_EATC, STDIO_MSG_READ, STDIO_MSG_SEEK
XDEF STDIO_MSG_FLSH, STDIO_MSG_CLOS

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

XDEF STDIO_SEEK_SET, STDIO_SEEK_CUR, STDIO_SEEK_END

defc STDIO_SEEK_SET = 0
defc STDIO_SEEK_CUR = 1
defc STDIO_SEEK_END = 2


;;;;;;;;;;
;; threads
;;;;;;;;;;

XDEF mtx_plain, mtx_recursive, mtx_timed

defc mtx_plain     = $01
defc mtx_recursive = $02
defc mtx_timed     = $04

XDEF thrd_success, thrd_error, thrd_nomem
XDEF thrd_busy, thrd_timedout

defc thrd_success  = $0000
defc thrd_error    = $0001
defc thrd_nomem    = $0002
defc thrd_busy     = $0004
defc thrd_timedout = $0008

; =============================
