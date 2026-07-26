
SECTION code_driver

PUBLIC _sd_write_block_fastcall

EXTERN asm_sd_write_block

    ;Write a block of 512 bytes (one sector) from (HL++) to the drive
    ;
    ;input HL = pointer to block to write
    ;uses AF, BC, DE, HL

defc _sd_write_block_fastcall = asm_sd_write_block
