;
; Allow the port the am9511 runs on to be configured
;
; override with -pragma-define:IO_AM9511_BASE=nn

IFNDEF IO_AM9511_BASE_PORT
   defc IO_AM9511_BASE_PORT = 0x42
ENDIF

   PUBLIC __IO_AM9511_BASE_PORT
   defc __IO_AM9511_BASE_PORT = IO_AM9511_BASE_PORT
