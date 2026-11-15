;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	The Next core supplies card power.
;	Deselect the bus. sd_spi_budget stores the bytes that fit in 4 ms.
;	AF, BC, DE and HL stay as they were.
;

    SECTION code_driver

    PUBLIC  sd_power_on

    EXTERN  sd_deselect_card
    EXTERN  sd_spi_budget

sd_power_on:
    call    sd_deselect_card
    jp      sd_spi_budget
