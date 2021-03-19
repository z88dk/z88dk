; uint in_LookupKey(uchar c)

SECTION code_clib
PUBLIC in_LookupKey
PUBLIC _in_LookupKey
EXTERN in_keytranstbl

; enter: L = ascii character code
; exit : carry set & HL=0 if ascii code not found
;        else: L = scan row index, H = mask
;              bit 7 of H set if CAPS needs to be pressed
;              bit 6 of H set if SYM SHIFT needs to be pressed
;              Ctrl key representedas CAPS + SYM SHIFT
; uses : AF,BC,HL

; The 16-bit value returned is a scan code understood by
; in_KeyPressed.

.in_LookupKey
._in_LookupKey
    ld      a,l
    ld      hl,in_keytranstbl
    ld      bc,72 * 4
    cpir
    jr      nz, notfound
    ld      hl, 72 * 4 - 1
    and     a
    sbc     hl,bc    ;hl = position within table
    ld      de,0     ;Resulting flags
    ld      bc,72
    and     a
    sbc     hl,bc
    jr      c,got_table
    ; Try shifted
    set     7,e
    and     a
    sbc     hl,bc
    jr      c,got_table
    ; Try sym shift
    res     7,e
    set     6,e
    and     a
    sbc     hl,bc
    jr      c,got_table
    ; It must be control then
    set     7,e
    and     a
    sbc     hl,bc

got_table:
    add     hl,bc
    ld      a,l
    ld      h,a
    rra	;Divide by 8
    rra
    rra
    and     15
    or      e
    ld      l,a
    ; Now, get the mask
    ld      a,h
    ld      h,1
shift_loop:
    and     7
    ret     z               ; nc
    sla     h
    dec     a
    jr      shift_loop

notfound:
    ld      hl,0
    scf
    ret


   
