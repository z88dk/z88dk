
SECTION code_driver

PUBLIC sd_read_block

EXTERN asm_sd_read_block

    ;Read a block of 512 bytes (one sector) from the drive
    ;and store it in memory at (HL++)
    ;
    ;input HL = pointer to block
    ;uses AF, BC, DE, HL

defc sd_read_block = asm_sd_read_block
