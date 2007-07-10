;
;       ZX IF1 & Microdrive functions
;
;       Get Microdrive status
;
;       int if1_mdv_status (int drive);
;       
;       Returns:
;       0: Microdrive Ready, cartridge inserted, no write protection
;       1: Cartridge is write protected
;       2: Microdrive not present
;
;       $Id: if1_mdv_status.asm,v 1.1 2007-07-10 08:12:50 stefano Exp $
;

                XLIB    if1_mdv_status

                LIB     if1_rommap
                XREF    MOTOR
                

if1_mdv_status:

                pop	hl
                pop	bc
                push	bc
                push	hl

                ld      a,c
                ld      hl,-1
                and     a               ; drive no. = 0 ?
                ret     z               ; yes, return -1
                dec     a
                cp      8               ; drive no. >8 ?
                ret     nc              ; yes, return -1
                inc     a

		push	af
                call    if1_rommap
                pop	af
                
		call    MOTOR           ; select drive motor
		ld	hl,retcode+1
		ld	a,2
		ld	(hl),a
		jr	nz,estatus	; microdrive not present

		in	a,($ef)
		and	1		; test the write-protect tab
		;;ret	z		; drive 'write' protected
		xor	1		; invert result (now 1=protected)
		ld	(hl),a
		
estatus:
		xor	a
		call	MOTOR		; Switch microdrive motor off (a=0)
                call    1               ; unpage
                ei

retcode:	ld	hl,0
		ret
