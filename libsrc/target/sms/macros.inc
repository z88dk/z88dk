
        ;
        ; Set the VRAM address.
        ;
        ; Interrupts need to be disabled around the 2 writes to I/O port
        ; $bf because the int_RASTER routine reads this same port to
        ; clear the interrupt from the VDP. This read will clobber the
        ; VRAM address if it happens between the two writes below.
        ;
setVRAM MACRO   cmd1, cmd2
        push    af
        di
        ld      a, cmd1
        out 	($bf),a
        ld      a, cmd2
        or      $40
        out 	($bf),a
        ei
        pop     af
        ENDM

        ;
        ; Set the CRAM address.
        ;
        ; Interrupts need to be disabled around the 2 writes to I/O port
        ; $bf because the int_RASTER routine reads this same port to
        ; clear the interrupt from the VDP. This read will clobber the
        ; CRAM address if it happens between the two writes below.
        ;
setCRAM MACRO   cmd1
        push    af
        di
        ld      a, cmd1
        out 	($bf),a
        ld      a, $c0
        out 	($bf),a
        ei
        pop     af
        ENDM

        ;
        ; Write to a VDP register.
        ;
        ; Interrupts need to be disabled around the 2 writes to I/O port
        ; $bf because the int_RASTER routine reads this same port to
        ; clear the interrupt from the VDP. This read will clobber the
        ; register address if it happens between the two writes below.
        ;
setVDPReg   MACRO   reg, value
        push    af
        di

        ld      a, value
        out     ($bf),a                 ; Output value

        ld      a, reg
        out     ($bf),a

        ei
        pop     af
        ENDM
