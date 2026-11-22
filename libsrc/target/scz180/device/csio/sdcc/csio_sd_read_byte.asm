
SECTION code_driver

PUBLIC _sd_read_byte

EXTERN asm_sd_read_byte

    ;Do a read bus cycle to the SD drive, via the CSIO
    ;  
    ;output L = byte read from SD drive

defc _sd_read_byte = asm_sd_read_byte
