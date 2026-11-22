;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Deselect the bus. The Next core supplies card power.
;	sd_spi_budget stores the bytes that fit in 4 ms.
;	AF stays as it was, including the flags.
;

    SECTION code_driver

    PUBLIC  sd_power_off

    EXTERN  sd_deselect_card
    EXTERN  sd_spi_budget

sd_power_off:
    call    sd_deselect_card
    jp      sd_spi_budget
