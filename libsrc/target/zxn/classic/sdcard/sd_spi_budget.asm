;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Bytes the Next SPI master can clock in 4 ms.
;	The master moves one byte in 16 CPU clocks, so the count is CLK/4000.
;	Turbo register 7, bits 1:0:
;	  00  3.5 MHz    875
;	  01  7 MHz     1750
;	  10  14 MHz    3500
;	  11  28 MHz    7000
;	A slower software byte loop only waits longer than 4 ms.
;	AF, BC, DE and HL stay as they were.
;

    SECTION code_driver

    PUBLIC  sd_spi_budget

    EXTERN  sd_bytes_per_4ms

sd_spi_budget:
    push    af
    push    bc
    push    hl
    ld      bc, $243b                   ; NextReg select, then data at $253B
    ld      a, $07
    out     (c), a
    inc     b
    in      a, (c)
    and     $03
    add     a, a
    ld      hl, sd_spi_budget_tab
    add     a, l
    ld      l, a
    jr      nc, sd_spi_budget_word
    inc     h
sd_spi_budget_word:
    ld      a, (hl)
    inc     hl
    ld      h, (hl)
    ld      l, a
    ld      (sd_bytes_per_4ms), hl
    pop     hl
    pop     bc
    pop     af
    ret

sd_spi_budget_tab:
    defw    875
    defw    1750
    defw    3500
    defw    7000
