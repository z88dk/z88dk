;
; Scan all CPC keyboard rows
;
; Taken from: https://www.cpcwiki.eu/index.php/Programming:Keyboard_scanning
;
    SECTION code_clib

    PUBLIC  __cpc_scan_allrows
    PUBLIC  __cpc_keystate
    EXTERN  l_push_di
    EXTERN  l_pop_ei


; Preserves interrupt enabled state
__cpc_scan_allrows:
    call l_push_di
    ld   hl,__cpc_keystate
    ld   bc,0xf782
    out  (c),c
    ld   bc,0xf40e
    ld   e,b
    out  (c),c
    ld   bc,0xf6c0
    ld   d,b
    out  (c),c
    xor  a
    out  (c),a
    ld   bc,0xf792
    out  (c),c
    ld   a,0x40
    ld   c,0x4a
loop:
    ld   b,d
    out  (c),a
    ld   b,e
    ini
    inc  a
    cp   c
    jr   c,loop
    ld   bc,0xf782
    out  (c),c     
    call l_pop_ei
    ret

    SECTION bss_clib

__cpc_keystate:  ds 10  ;map with 10*8 = 80 key status bits (bit=0 key is pressed)
