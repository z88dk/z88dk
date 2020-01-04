;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	interrupt driven serial routines
;
;
; ------
; $Id: serial_int.asm,v 1.5 2016-06-27 21:25:36 dom Exp $
;
	SECTION code_clib
	PUBLIC	serial_int
	
	PUBLIC	serial_int_check
	PUBLIC	ozserbufget
	PUBLIC	ozserbufput
	PUBLIC	SerialBuffer
	PUBLIC	ozrxhandshaking
	PUBLIC	ozrxxoff

	EXTERN	ozcustomisr

	EXTERN	rxxoff_hook
	EXTERN	serial_hook

	EXTERN	ozintwait
	
	EXTERN	serial_check_hook
	

; Don't exchange the items position !!


rxxoff_handler:
        ld      a,(ozrxxoff)
        or      a
        ;jp      z,$rxxoff_hook+2
        jp      z,rxxoff_hook+3
        ld      hl,ozserbufput
        ld      a,(hl)
        dec     hl       ; hl=ozserbufget
        sub     (hl)
        cp      150
        jp      nc,rxxoff_hook+3
waittop2:
        in      a,(45h)
        and     20h
        jr      z,waittop2
        ld      a,17  ; XON
        out     (40h),a
        xor     a
        ld      (ozrxxoff),a
        jp      rxxoff_hook+3

serial_int_check:
        ld a,(ozserbufget)
        ld c,a
        ld a,(ozserbufput)
        cp c
        jp z,serial_check_hook+3
        ei
        ret


serial_int:
        in      a,(45h)
        and     1
        jp      z,serial_hook+3  ;; no serial data

        in      a,(40h)
        push    hl
        ld      e,a
        ld      hl,ozserbufput
        ld      a,(hl)
        ld      c,a
        inc     a
        dec     hl  ; hl=ozserbufget
        cp      (hl)
        jp      z,BufferFull
        inc     hl  ; hl=ozserbufput
        ld      (hl),a
        ei

        ld      b,0
        inc     hl  ; hl=SerialBuffer
        add     hl,bc
        ld      (hl),e

        ld      hl,ozserbufget
        sub     (hl)      ; a=buffer size
        cp      200
        jr      c,noXOFF
        ld      a,(ozrxhandshaking)
        or      a
        jr      z,noXOFF
        ld      a,(ozrxxoff)
        or      a
        jr      nz,noXOFF
waittop:
        in      a,(45h)
        and     20h
        jr      z,waittop
        ld      a,19  ; XOFF
        out     (40h),a
        ld      a,1
        ld      (ozrxxoff),a
noXOFF:

BufferFull:
        pop     hl
        jp      serial_hook+3

	SECTION bss_clib
defc	BufLen = 256
ozserbufget:
        defs 1
ozserbufput:
        defs 1
SerialBuffer:
        defs BufLen
ozrxhandshaking:
        defs 1
ozrxxoff:
        defs 1



