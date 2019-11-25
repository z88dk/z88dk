
SECTION code_driver

PUBLIC sd_read_byte

EXTERN asm_sd_read_byte

    ;Do a read bus cycle to the SD drive, via the CSIO
    ;  
    ;output L = byte read from SD drive

defc sd_read_byte = asm_sd_read_byte
