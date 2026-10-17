; Rabbit: map a banked address to a far address
;
; A banked address is a code or data bank number (XPC = bank * 2) in e and
; the address inside the XPC window in hl. The bank is physical
; 0x10000 + (bank - 1) * 0x2000, so
;
;   far = hl + bank * 0x2000
;
; Bank 0 is the root image and stays a local address.
;
; Entry: ehl = banked address
; Exit:  ehl = far address, d = 0

    SECTION code_l_sccz80_far
    PUBLIC  l_far_mapaddr

l_far_mapaddr:
    ld      a,e
    and     a
    ret     z
    and     $07                     ; (bank & 7) << 13 added to hl
    rrca
    rrca
    rrca
    add     a,h
    ld      h,a
    push    af                      ; keep the carry out of hl
    srl     e                       ; e = bank >> 3
    srl     e
    srl     e
    pop     af
    ld      a,e
    adc     a,0
    ld      e,a
    ld      d,0
    ret
