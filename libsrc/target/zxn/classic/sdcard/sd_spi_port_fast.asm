;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	The Next SPI clock has no programmable divider.
;	sd_spi_budget stores the bytes that fit in 4 ms. AF stays as it was.
;

    SECTION code_driver

    PUBLIC  sd_spi_port_fast

    EXTERN  sd_spi_budget

sd_spi_port_fast:
    jp      sd_spi_budget
