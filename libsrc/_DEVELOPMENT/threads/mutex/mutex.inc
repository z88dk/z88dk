
;; MUTEX TYPES

defc mtx_plain     = $00
defc mtx_recursive = $01
defc mtx_timed     = $02

;; MUTEX RETURN VALUES

defc thrd_success  = $0000
defc thrd_error    = $0001
defc thrd_nomem    = $0002
defc thrd_busy     = $0004
defc thrd_timedout = $0008
