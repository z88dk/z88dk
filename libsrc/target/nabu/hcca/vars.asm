    SECTION bss_clib


    PUBLIC  __nabu_hcca_rxmode
    PUBLIC  __nabu_hcca_rxfinished
    PUBLIC  __nabu_hcca_rxheader
    PUBLIC  __nabu_hcca_rxcount
    PUBLIC  __nabu_hcca_read_block
    PUBLIC  __nabu_hcca_read_blocklen
    PUBLIC  __nabu_hcca_rxpos
    PUBLIC  __nabu_hcca_rxrpos



    PUBLIC  __nabu_hcca_txcount
    PUBLIC  __nabu_hcca_txpos
    PUBLIC  __nabu_hcca_txmode
    PUBLIC  __nabu_hcca_write_block
    PUBLIC  __nabu_hcca_write_blocklen
    PUBLIC  __nabu_hcca_txfinished


__nabu_hcca_txcount:
    defw    0

__nabu_hcca_txpos:
    defw    0

__nabu_hcca_txmode:
    defb    0

__nabu_hcca_txfinished:
    defb    0

__nabu_hcca_write_blocklen:
    defw    0

__nabu_hcca_write_block:
    defw    0

; 255 = ringbuffer mode
;   0 = reading header
;   1 = reading block direct t memory
__nabu_hcca_rxmode:
    defb    0

; Non-ringbuffer: Block read indicator
__nabu_hcca_rxfinished:
    defb    0

; Non-ringbuffer: Header fo the message
__nabu_hcca_rxheader:
    defs    3

; Non-ringbugger: Where the next byte is read to
; Ringbuffer: Offset within the ringbuffer
__nabu_hcca_rxpos:
    defw    0

; Non-ringbuffer: How much we have left to read
__nabu_hcca_rxcount:
    defw    0

; Non-ringbuffer: Indicates where the block should be read to
__nabu_hcca_read_block:
    defw    0

; Non-ringbuffer: Indicates how long a block to read
__nabu_hcca_read_blocklen:
    defw    0



; Ringbuffer: Offset within the ringbuffer for reading
__nabu_hcca_rxrpos:
    defw    0
