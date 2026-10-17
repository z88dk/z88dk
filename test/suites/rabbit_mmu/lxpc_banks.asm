; Banks above 255, for the 12-bit LXPC of the Rabbit 4000 and later.
; Bank 300 is 0x12c and bank 2000 is 0x7d0. Bank N is at physical
; N * 0x2000 + 0xE000.
    SECTION BANK_12C
    org $12C0000 + 0xE000
    SECTION CODE_300
    SECTION RODATA_300

    SECTION BANK_7D0
    org $7D00000 + 0xE000
    SECTION CODE_2000
    SECTION RODATA_2000
