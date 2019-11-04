
SECTION code_driver

PUBLIC _sd_read_block

EXTERN asm_sd_read_block

    ;Read a block of 512 bytes (one sector) from the drive
    ;and store it in memory at (HL++)
    ;
    ;input HL = pointer to block
    ;uses AF, BC, DE, HL

._sd_read_block
    pop af
    pop hl
    push hl
    push af
    jp asm_sd_read_block
