


        MODULE  receive_byte

        PUBLIC  receive_byte
        PUBLIC  _receive_byte

	EXTERN	__io_status

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

        ;; Send byte in __io_out to the serial port
receive_byte:
_receive_byte:
        LD      A,IO_RECEIVING
        LD      (__io_status),A ; Store status
        XOR     A
        LDH     (SC),A         ; Use external clock
        LD      A,DT_RECEIVING
        LDH     (SB),A         ; Send RECEIVING byte
        LD      A,0x80
        LDH     (SC),A         ; Use external clock
        RET
