
SECTION code_driver

PUBLIC _sd_write_block

EXTERN asm_sd_write_block

    ;Write a block of 512 bytes (one sector) from (HL++) to the drive
    ;
    ;input HL = pointer to block to write
    ;uses AF, BC, DE, HL

._sd_write_block
    pop af
    pop hl
    push hl
    push af
    jp asm_sd_write_block
