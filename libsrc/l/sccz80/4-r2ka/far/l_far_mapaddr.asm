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
; Rabbit 4000 and later: the bank is 16 bits, in de.
;
; Entry: ehl = banked address (de on the Rabbit 4000 and later)
; Exit:  ehl = far address, d = 0

    SECTION code_l_sccz80_far
    PUBLIC  l_far_mapaddr

l_far_mapaddr:
IF __CPU_R4K__ || __CPU_R5K__ || __CPU_R6K__
    ; The bank has 16 bits here: d is its high byte
    ld      a,e
    or      d
    ret     z                       ; bank 0 is the root image, a local address
    ld      a,e
    and     $07
    rrca
    rrca
    rrca                            ; (bank & 7) << 5
    ld      b,a
    ld      a,e
    rrca
    rrca
    rrca
    and     $1f                     ; low part of bank >> 3
    ld      e,a
    ld      a,d
    rlca
    rlca
    rlca
    rlca
    rlca                            ; high part of bank >> 3
    or      e
    ld      e,a                     ; e = bank >> 3
    ld      a,h
    add     a,b
    ld      h,a
    ld      a,e
    adc     a,0
    ld      e,a
    ld      d,0
    ret
ELSE
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
ENDIF
