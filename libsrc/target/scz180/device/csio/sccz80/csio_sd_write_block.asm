
SECTION code_driver

PUBLIC sd_write_block

EXTERN asm_sd_write_block

    ;Write a block of 512 bytes (one sector) from (HL++) to the drive
    ;
    ;input HL = pointer to block to write
    ;uses AF, BC, DE, HL

defc sd_write_block = asm_sd_write_block
