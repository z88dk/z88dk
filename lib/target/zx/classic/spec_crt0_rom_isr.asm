;
; ZX Spectrum startup code for z88dk
; ROM mode interrupt handler, part of spec_crt0.asm
; this file is linked in when the "-startup=2" parameter is used
;
; Stefano Bodrato, 19/02/2009
;
; $Id: spec_crt0_rom_isr.as1,v 1.3 2009-06-10 17:26:05 stefano Exp $
;


; This block starts at location $0038, (56 decimal).

        push    af
        push    hl
        ld      hl,($5c78)      ; frames
        inc     hl
        ld      ($5c78),hl
        ld      a,h
        or      l
        jr      nz,key_chk
        ld      hl,$5c7a
        inc     (hl)
        
key_chk:
;--- --- --- --- cut here to remove the keyboard handler --- --- --- --- 
        push    bc
        push    de
        
        ld      hl,r1
        ld      c,$fe   ; lower part of keyboard port address is always $fe
        ld      d,8
krloop:
        call    readkrow
        jr      nc,kfound
        dec     d
        ld      a,d
        jr      z,kfound
        inc     hl
        jr      krloop

kfound:
        ld      ($5C08),a
        pop     de
        pop     bc
;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        pop     hl	; End of interrrupt
        pop     af
        ei
        ret



;--- --- --- --- cut here to remove the keyboard handler --- --- --- --- 

; Read keyboard row, used by interrupt service routine

readkrow:
        ld      b,(hl)  ; C holds $FE, so the full port addr is $xxFE
        in      a,(c)
        ld      e,5
e_lp:   inc     hl
        rra
        jr      c,no_za
        ld      a,(hl)          ; A holds the key code,
        ret                     ; carry flag is reset
no_za:  dec     e
        jr      nz,e_lp
        ret                     ; no keypress detected, 
                                ; carry flag is set

; Key Table

r1:     defb    $f7
        defb    '1'
        defb    '2'
        defb    '3'
        defb    '4'
        defb    '5'
r2:     defb    $ef
        defb    '0'
        defb    '9'
        defb    '8'
        defb    '7'
        defb    '6'
r3:     defb    $fb
        defb    'q'
        defb    'w'
        defb    'e'
        defb    'r'
        defb    't'
r4:     defb    $df
        defb    'p'
        defb    'o'
        defb    'i'
        defb    'u'
        defb    'y'
r5:     defb    $fd
        defb    'a'
        defb    's'
        defb    'd'
        defb    'f'
        defb    'g'
r6:     defb    $bf
        defb    13
        defb    'l'
        defb    'k'
        defb    'j'
        defb    'h'
r7:     defb    $fe
        defb    0       ; Caps Shift
        defb    'z'
        defb    'x'
        defb    'c'
        defb    'v'
r8:     defb    $7f
        defb    ' '
        defb    12      ; Sym Shift is now BS
        defb    'm'
        defb    'n'
        defb    'b'

;--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

