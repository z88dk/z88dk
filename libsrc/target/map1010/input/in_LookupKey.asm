; uint in_LookupKey(uchar c)
; 07.2018 suborb

    SECTION code_clib
    PUBLIC  in_LookupKey
    PUBLIC  _in_LookupKey
    EXTERN  in_keytranstbl

; Given the ascii code of a character, returns the key index
; corresponding to the key that needs to be pressed to generate the
; character.
;
; The scan row returned will have bit 7 set and bit 6 set to
; indicate if CAPS, SYM SHIFTS also have to be pressed to generate the
; ascii code, respectively.

; enter: L = ascii character code
; exit : L = key index
;        H =   bit 7 of H set if SHIFT needs to be pressed
;              bit 6 of H set if FUNC needs to be pressed
; uses : AF,BC,HL

; The 16-bit value returned is a scan code understood by
; in_KeyPressed.

in_LookupKey:
_in_LookupKey:
    ld      a, l
    ld      hl, in_keytranstbl
    ld      bc, 96*3
    cpir
    jr      nz, notfound

	; Try and find the position with the table here
    ld      de, 0                       ; Our resulting flags
    ld      hl, 96*3-1
    and     a
    sbc     hl, bc                      ; hl = position within table
    ld      bc, 96
    and     a
    sbc     hl, bc
    jr      c, got_table
	; Now try shifted
    set     7, d
    and     a
    sbc     hl, bc
    jr      c, got_table
	; It must be control
    res     7, d
    set     6, d
    and     a
    sbc     hl, bc
got_table:
    add     hl, bc                      ;Add the 96 back on
    ld      e,l                         ;key index
    and     a
    ret

notfound:
    ld      hl, 0
    scf
    ret

