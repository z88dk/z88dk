


SECTION code_clib

PUBLIC  __esp_send_cmd
PUBLIC  __esp_send_byte
PUBLIC  __esp_send_bytes
PUBLIC  __esp_read_bytes
PUBLIC  __esp_read_byte

INCLUDE "target/aquarius/def/aqplus.def"

; Send byte = a
MACRO SENDBYTE
LOCAL l1
    ex      af,af
l1:
    in      a,(PORT_ESPCTRL)
    and     2
    jr      nz,l1
    ex      af,af
    out     (PORT_ESPDATA),a
ENDM

MACRO READBYTE
LOCAL l1
    ex      af,af
l1:
    in      a,(PORT_ESPCTRL)
    and     1
    jr      z,l1
    ex      af,af
    in      a,(PORT_ESPDATA)
ENDM

__esp_read_byte:
    READBYTE
    ret

__esp_send_byte:
    SENDBYTE
    ret

; Send a command
;   a = command to send
__esp_send_cmd:
    ex      af,af
    ld      a,0x83
    out     (PORT_ESPCTRL),a
    ex      af,af
    SENDBYTE
    ret

; Send a block of data
; hl = block
; bc = count
__esp_send_bytes:
    ld      a,b
    or      c
    ret     z
    ld      a,(hl)
    SENDBYTE
    inc     hl
    dec     bc
    jr      __esp_send_bytes

; Read a block of data
; hl = block
; bc = count
__esp_read_bytes:
    ld      a,b
    or      c
    ret     z
    READBYTE
    ld      (hl),a
    inc     hl
    dec     bc
    jr  __esp_read_bytes

