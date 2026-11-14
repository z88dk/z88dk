;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	sd_card_info and card_select must be accessible,
;	a good place to put them is in the vars declared in the CRT0 stub
;
;	The return address stays in sd_c_ret.
;

    PUBLIC  sd_c_return_hl
    PUBLIC  sd_c_return_dehl

    EXTERN  sd_c_ret

sd_c_return_hl:
    push    hl
    ld      hl, (sd_c_ret)
    ld      de, hl
    pop     hl
    push    de
    ret

sd_c_return_dehl:
    push    de
    push    hl
    ld      hl, (sd_c_ret)
    pop     bc
    pop     de
    push    hl
    ld      hl, bc
    ret


    SECTION data_compiler

    PUBLIC  card_select
    PUBLIC  sd_card_info
    PUBLIC  sector_buffer_loc
    PUBLIC  sd_bytes_per_4ms

card_select:
    defb    0

sd_card_info:
    defb    0

sector_buffer_loc:
    defw    sector_buffer

sd_bytes_per_4ms:
    defw    4096


    SECTION bss_compiler

    PUBLIC  sector_buffer
    PUBLIC  sd_c_ret
    PUBLIC  sd_block_count

sector_buffer:
    defs    513

sd_c_ret:
    defs    2

sd_block_count:
    defs    2
