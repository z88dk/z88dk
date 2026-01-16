
; Generate references to any portions of UART
; code that must be part of every compile that
; uses the UART.

PUBLIC _uart_need

EXTERN _uart_init

defc _uart_need = _uart_init

; The UART must be initialized before main is called

SECTION code_crt_init
call _uart_init
