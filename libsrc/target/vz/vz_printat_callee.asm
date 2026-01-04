;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Jason Oakley
;       Move text cursor to x,y and print
;*****************************************************

; ----- void __CALLEE__ vz_printat_callee(int x, int y, *addr str)

    SECTION code_clib
    PUBLIC  vz_printat_callee
    PUBLIC  _vz_printat_callee
    PUBLIC  asm_vz_printat

vz_printat_callee:
_vz_printat_callee:

    pop     af
    pop     bc
    pop     hl
    pop     de
    push    af

   ; hl = y
   ; de = x
   ; bc = *str

asm_vz_printat:
    push bc     ; save string addr
    ld a,l
    cp $1f
    ret nc
    ld (printat_y),a
    ld a,e
    cp $0e
    ret nc
    ld (printat_x),a
    ld hl,$7000
    ld b,0
    ld c,a
    add hl,bc

    ld de,$0020
    ld a,(printat_y)
    cp $00
    jr z,noy
    ld b,a
mctloop:
    add hl,de   ; hl = screen loc
    djnz mctloop  
    ex de,hl    ; de = screen loc
noy:    
    pop hl      ; Get string addr
printout:
    ld a,(hl)   ; Get string char
    or a
    ret z   ; String print completed
    ex de,hl
    cp $40
    jr c,printit
    sub $40
printit:
    ld (hl),a
    inc hl
    ex de,hl
    inc hl
    jr printout
    ;ret
printat_x:
    defb $00
printat_y:
    defb $00
