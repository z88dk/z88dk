
SECTION code_driver

PUBLIC _sd_read_block_fastcall

EXTERN asm_sd_read_block

    ;Read a block of 512 bytes (one sector) from the drive
    ;and store it in memory at (HL++)
    ;
    ;input HL = pointer to block
    ;uses AF, BC, DE, HL

defc _sd_read_block_fastcall = asm_sd_read_block
