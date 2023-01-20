;
; HCCA reading/writing routines
;



    SECTION code_clib

    EXTERN  nabu_disable_interrupt
    EXTERN  nabu_enable_interrupt

    EXTERN  __nabu_hcca_rxmode
    EXTERN  __nabu_hcca_rxfinished
    EXTERN  __nabu_hcca_rxheader
    EXTERN  __nabu_hcca_rxpos
    EXTERN  __nabu_hcca_rxcount
    EXTERN  __nabu_hcca_read_block
    EXTERN  __nabu_hcca_rxpos
    EXTERN  __nabu_hcca_rxrpos

    EXTERN  __nabu_hcca_read_blocklen
    EXTERN  __nabu_hcca_read_block


    EXTERN  __nabu_hcca_txpos
    EXTERN  __nabu_hcca_txbuf
    EXTERN  __nabu_hcca_txcount
    EXTERN  __nabu_hcca_txfinished
    EXTERN  __nabu_hcca_txmode
    EXTERN  __nabu_hcca_write_block
    EXTERN  __nabu_hcca_write_blocklen

    EXTERN  __nabu_hcca_rxbuf
    EXTERN  CLIB_RXBUF_SIZE


    PUBLIC  hcca_reset_write
    PUBLIC  _hcca_reset_write
    PUBLIC  hcca_write_byte
    PUBLIC  _hcca_write_byte
    PUBLIC  hcca_writeByte
    PUBLIC  _hcca_writeByte
    PUBLIC  hcca_write_wait_finished
    PUBLIC  _hcca_write_wait_finished
    PUBLIC  hcca_read_wait_finished
    PUBLIC  _hcca_read_wait_finished
    
    PUBLIC  hcca_read_byte
    PUBLIC  _hcca_read_byte
    PUBLIC  hcca_readByte
    PUBLIC  _hcca_readByte
    PUBLIC  hcca_start_write
    PUBLIC  _hcca_start_write
    PUBLIC  hcca_start_read
    PUBLIC  _hcca_start_read

    INCLUDE "target/nabu/def/nabu.def"


; Write a byte to the txuf
;
; void hcca_write_byte(uint8_t byte)
hcca_write_byte:
_hcca_write_byte:
hcca_writeByte:
_hcca_writeByte:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
; Entry: a = byte to write
; Uses: dehl
asm_write_byte:
    ld      de,(__nabu_hcca_txcount)
    ld      hl,__nabu_hcca_txbuf
    add     hl,de
    ld      (hl),a
    inc     de
    ld      (__nabu_hcca_txcount),de
    ret

;
; Reset writing
;
; 1. Disable interrupt
; 2. Reset the txbuf
;
; void hcca_reset_write(void)
hcca_reset_write:
_hcca_reset_write:
    di
    ld      hl,__nabu_hcca_txbuf
    ld      (__nabu_hcca_txpos),hl
    ld      hl,0
    ld      (__nabu_hcca_txcount),hl
    ld      l,INT_MASK_HCCATX
    call    nabu_disable_interrupt
    ei
    ret



; Start writing
;
; 1. Fire up interrupt
; 2. Setup writing mode
; 3. Setup pointers for block to write (if appropriate)
;
; Entry:
;  a = writing mode
; hl = buffer
; bc = length
;
; void hcca_start_write(int mode, void *buf, size_t len)
hcca_start_write:
_hcca_start_write:
    di
    ld      hl,2
    add     hl,sp
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      (__nabu_hcca_write_blocklen),de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      (__nabu_hcca_write_block),de
    ld      a,(hl)
    ld      (__nabu_hcca_txmode),a
    xor     a
    ld      (__nabu_hcca_txfinished),a
    ld      a,i
    ld      h,a
    ld      l,2
    ld      de,hcca_write_int
    ld      (hl),e
    inc     hl
    ld      (hl),d
    ld      l,INT_MASK_HCCATX
    call    nabu_enable_interrupt
    ei
    ret

hcca_write_wait_finished:
_hcca_write_wait_finished:
    ld      a,(__nabu_hcca_txfinished)
    and     a
    jr      z,hcca_write_wait_finished
    ret

hcca_read_wait_finished:
_hcca_read_wait_finished:
    ld      a,(__nabu_hcca_rxfinished)
    and     a
    jr      z,hcca_read_wait_finished
    ret

;
; For writing we setup variables:
;
; __nabu_hcca_txpos   = start of buffer
; __nabu_hcca_txcount = number of bytes to write
;
hcca_write_int:
    push    af
    push    hl
    ld      hl,(__nabu_hcca_txpos)
    ld      a,(hl)
    out     (IO_HCCA),a
    inc     hl
    ld      (__nabu_hcca_txpos),hl
    ld      hl,(__nabu_hcca_txcount)
    dec     hl
    ld      (__nabu_hcca_txcount),hl
    ld      a,h
    or      l
    jr      nz,not_finished_tx
    ; Finished writing that segment 
    ld      a,(__nabu_hcca_txmode)
    and     a
    jr      nz,finished_writing
    inc     a
    ld      (__nabu_hcca_txmode),a
    ld      hl,(__nabu_hcca_write_block)
    ld      (__nabu_hcca_txpos),hl
    ld      hl,(__nabu_hcca_write_blocklen)
    ld      (__nabu_hcca_txcount),hl
    jr      not_finished_tx

finished_writing:
    ; Signal that we've finished writing
    ld      (__nabu_hcca_txfinished),a      ;a != 0
    ; Finished writing, disable the interrupt
    ld      l,INT_MASK_HCCATX
    call    nabu_disable_interrupt
not_finished_tx:
    pop     hl
    pop     af
    ei
    ret


; Start writing
;
; 1. Fire up interrupt
; 2. Setup reading mode
; 3. Setup pointers for block to read (if appropriate)
;
; Entry:
;  a = reading mode
; hl = buffer
; bc = length
;
; void hcca_start_readint mode, void *buf, size_t len)
hcca_start_read:
_hcca_start_read:
    di
    ld      hl,2
    add     hl,sp
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      (__nabu_hcca_read_block),de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      (__nabu_hcca_read_blocklen),de
    ld      a,(hl)
    ld      (__nabu_hcca_rxmode),a
    ; 255 = ring buffer
    ; 0 = header
    ; 1 = block
    cp      255
    jr      z,setup_read_rb
    and     a
    jr      z,setup_read_header

    ; Must be reading a block to memory
    ld      hl,(__nabu_hcca_read_block)
    ld      (__nabu_hcca_rxpos),hl
    ld      hl,(__nabu_hcca_read_blocklen)
    ld      (__nabu_hcca_rxcount),hl
    jr      setup_read_int

setup_read_header:
    ld      hl,__nabu_hcca_rxheader
    ld      (__nabu_hcca_rxpos),hl
    ld      hl,3
    ld      (__nabu_hcca_rxcount),hl
    jr      setup_read_int


setup_read_rb:
    ld      hl,0
    ld      (__nabu_hcca_rxpos),hl
    ld      (__nabu_hcca_rxrpos),hl

    
setup_read_int:
    ld      a,i
    ld      h,a
    ld      l,0
    ld      de,hcca_read_int
    ld      (hl),e
    inc     hl
    ld      (hl),d
    ld      l,INT_MASK_HCCARX
    call    nabu_enable_interrupt
    ei
    ret

; Read a byte from the ringbuffer
;
; Blocks until data is available
;
; uint8_t hcca_read_byte(void)
hcca_read_byte:
_hcca_read_byte:
hcca_readByte:
_hcca_readByte:
    ld      hl,(__nabu_hcca_rxpos)
    ld      de,(__nabu_hcca_rxrpos)
    and     a
    sbc     hl,de
    ld      a,h
    or      l
    jr      z,hcca_read_byte
    ld      hl,__nabu_hcca_rxbuf
    add     hl,de
    ld      l,(hl)
    ld      h,0
    inc     de
    ld      a,d
    and     +((CLIB_RXBUF_SIZE -1) / 256)
    ld      d,a
    ld      (__nabu_hcca_rxrpos),de
    ret

ead_mode:



hcca_read_int:
    push    af
    push    de
    push    hl
    ld      a,(__nabu_hcca_rxmode)
    inc     a
    jp      z,hcca_read_ringbuf

    ; We're now in the "zero-copy"/headed reading code
    ld      hl,(__nabu_hcca_rxpos)
    in      a,(IO_HCCA)
    ld      (hl),a
    inc     hl
    ld      (__nabu_hcca_rxpos),hl
    ld      hl,(__nabu_hcca_rxcount)
    dec     hl
    ld      (__nabu_hcca_rxcount),hl
    ld      a,h
    or      l
    jr      nz,continue_reading

    ; We've read everything in this block, what do we do next?
    ld      a,(__nabu_hcca_rxmode)
    and     a
    jr      nz,signal_block_read
    inc     a
    ld      (__nabu_hcca_rxmode),a
    ld      hl,(__nabu_hcca_rxheader+1)
    ld      (__nabu_hcca_rxcount),hl
    ld      hl,(__nabu_hcca_read_block)
    ld      (__nabu_hcca_rxpos),hl
    jr      continue_reading

signal_block_read:
    ld      (__nabu_hcca_rxfinished),a        ; a != 0

    ; Reset reading variables
    xor     a
    ld      (__nabu_hcca_rxmode),a
    ld      hl,3
    ld      (__nabu_hcca_rxcount),hl
    ld      hl,__nabu_hcca_rxheader
    ld      (__nabu_hcca_rxpos),hl

    ld      l,INT_MASK_HCCARX
    call    nabu_disable_interrupt


continue_reading:
    pop     hl
    pop     de
    pop     af
    ei
    ret


hcca_read_ringbuf:
    ld      hl,(__nabu_hcca_rxpos)
    ld      de,__nabu_hcca_rxbuf
    ex      de,hl
    add     hl,de
    in      a,(IO_HCCA)
    ld      (hl),a
    ex      de,hl
    inc     hl
    ld      a,h
    and     +((CLIB_RXBUF_SIZE-1) / 256)
    ld      h,a
    ld      (__nabu_hcca_rxpos),hl
    pop     hl
    pop     de
    pop     af
    ei
    ret


 
