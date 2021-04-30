SECTION code_clib
PUBLIC in_LookupKey
PUBLIC _in_LookupKey
EXTERN in_keytranstbl

; Given the ascii code of a character, returns the scan row and mask
; corresponding to the key that needs to be pressed to generate the
; character.
;
; The scan row returned will have bit 7 set and bit 6 set to
; indicate if CAPS, SYM SHIFTS also have to be pressed to generate the
; ascii code, respectively.

; enter: L = ascii character code
; exit : L = scan row
;        H = mask
;        else: L = scan row, H = mask
;              bit 7 of L set if SHIFT needs to be pressed
;              bit 6 of L set if FUNC needs to be pressed
; uses : AF,BC,HL

; The 16-bit value returned is a scan code understood by
; in_KeyPressed.

.in_LookupKey
._in_LookupKey
        ld      a,l
        ld      hl,in_keytranstbl
        ld      bc,128 * 3
        cpir
        jr      nz,notfound

        ; Try and find the position with the table here
        ld      de,0            ; Out resulting flags
        ld      hl, 128 * 3 - 1
        and     a
        sbc     hl,bc           ; hl = position within table
        ld      bc,128
        and     a
        sbc     hl,bc
        jr      c, got_table
        ; Now try shifted
        set     7,e
        and     a
        sbc     hl,bc
        jr      c,got_table
        ; It must be control
        res     7,e
        set     6,e
        and     a
        sbc     hl,de
got_table:
        add     hl,bc           ;Add the 96 back on
        ld      a,l
        ld      h,a
        srl     a               ;divide by 8
        srl     a
        srl     a
        or      e
        ld      l,a             ; l = flags + row
        ; Now get the mask
        ld      a,h
        ld      h,1
shift_loop:
        and     7
        ret     z               ; nc
        rl      h
        dec     a
        jr      shift_loop

notfound:
        ld      hl,0
        scf
        ret