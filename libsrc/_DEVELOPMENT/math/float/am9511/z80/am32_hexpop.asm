
SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_am9511_dhexpop

EXTERN asm_am9511_min

asm_am9511_dhexpop:

   ; strtod helper
   ;
   ; create double from mantissa on stack
   ;
   ; enter : stack = mantissa, ret
   ;
   ; exit  : DEHL'= double
   ;
   ; uses  : af, bc', de', hl'

    exx
    pop bc                      ; my return
    pop hl                      ; sdcc_float
    pop de
    dec sp                      ; pop only 6 significant hex digits
    push bc

    ld a,$7f

.normmant
    bit 7,e
    jr NZ,normdone

    sla l
    rl h
    rl e

    dec a
    jr Z,asm_am9511_min         ; safety net, in case something is borked

    jr normmant

.normdone
    ld d,a
    sla e
    srl d
    rr e

    exx
    ret

