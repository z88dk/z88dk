; Sharp MZ-800 keyboard: shared code for in_Inkey, in_KeyPressed and in_LookupKey
;
; 10 strobes of 8 keys through the 8255: the strobe goes to port A ($D0, bit 7 kept set), the keys come from port B ($D1), a pressed key reading 0.  Strobe 8 has the modifiers:
; SHIFT bit 0, CTRL bit 6 (and BREAK at bit 7).

    SECTION code_clib
    PUBLIC  INKeyMZ800Init
    PUBLIC  INKeyMZ800Col

; Nothing to set up (the 8255 is as the IPL left it)
INKeyMZ800Init:
    ret

; enter: A = strobe (0..9)
; exit : A = the keys of the strobe, a 0 bit for each that is down
; uses : AF
INKeyMZ800Col:
    or      $80
    out     ($d0), a
    in      a, ($d1)
    ret
