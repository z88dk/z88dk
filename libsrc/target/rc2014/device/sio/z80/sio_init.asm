
    INCLUDE "config_private.inc"

    SECTION code_driver

    EXTERN  __sio_init_async_rodata
    EXTERN  _sioa_reset, _siob_reset

    EXTERN asm_z80_push_di, asm_z80_pop_ei_jp

    PUBLIC  _sio_init

; initialise the SIO interrupt vectors in preamble for IM 2

    _sio_init:

        ld hl,__sio_init_async_rodata
                                    ; load the default SIO configuration
                                    ; ASYNC operation
                                    ; BAUD = 115200 8n1
                                    ; receive enabled
                                    ; transmit enabled
                                    ; receive interrupt enabled
                                    ; transmit interrupt enabled

        call _sio_io_ports          ; initialise the SIO for ASYNC via control Reg A & B

        call _sioa_reset            ; reset and empty the SIOA Tx & Rx buffers
        call _siob_reset            ; reset and empty the SIOB Tx & Rx buffers

        ret

    ; Initialise the I/O ports from an array of addresses and values
    ; Entry HL = base address of array
    ; Exit none
    ; The array consists of byte-length elements in the following order:
    ; - number of bytes to be sent to the I/O port
    ; - port device address (one byte only)
    ; - data values destined for the I/O port
    ; This sequence if repeated for any number of I/O ports
    ; The array is terminated by a NULL in the number of bytes field.
    ; Z80 ALS - Leventhal (1983)

    PUBLIC _sio_io_ports

    _sio_io_ports:
        ld a,(hl)                   ; get number of bytes in the array
        or a                        ; test to see if it is zero, or NULL
        ret Z
        ld b,a                      ; B contains the number of bytes to load
        inc hl                      ; port address
        ld c,(hl)                   ; in C for output
        inc hl                      ; first data value to output
        otir                        ; send data to I/O ports
        jr _sio_io_ports            ; do it again, until we find a NULL terminator

