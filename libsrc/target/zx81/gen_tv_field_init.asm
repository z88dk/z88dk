;
;       ZX81 libraries
;
;--------------------------------------------------------------
;
;       $Id: gen_tv_field_init.asm,v 1.4 2016-06-26 20:36:33 dom Exp $
;
;----------------------------------------------------------------
;
; gen_tv_field_init(delay) - calibrate the gen_tv_field() function
; depending on the ZX80 frame rate (UK/USA) and set its pointer
; to the current D-FILE location.  If parameter=0 then autodetect.
;
;----------------------------------------------------------------

	SECTION   code_clib
        PUBLIC    gen_tv_field_init
        PUBLIC    _gen_tv_field_init
        EXTERN    DFILE_PTRA
        EXTERN    DFILE_PTRB

gen_tv_field_init:
_gen_tv_field_init:
;	push	hl

;	LD      HL,($400C)      ;; point HL to D-FILE the first HALT
                                ;; instruction.
;	SET     7,H             ;; now point to the DFILE echo in the 
                                ;; top 32K of address space.
;	LD      (DFILE_PTR + 1),HL
	
;	pop		hl
	xor		a
	or		l
	jr		nz,noauto
	ld		a,$E9			; Tuned for z88dk  ;)
noauto:
	LD      (DFILE_PTRA + 1),A

	LD      BC,$FEFE           ;
	IN      A,(C)           ; read a keyboard byte
 	
	RLA                     ; rotate bit 7 out.
	RLA                     ; test bit 6.
	SBC     A,A             ; $FF or $00 (USA)
	AND     24             ; and 24
	ADD     A,32           ; add 32
	LD      (DFILE_PTRB + 1),A

	;LD   A,24			;
	;LD   A,48			;    There are 48 scan lines (UK) above the ZX80
                        ;    main display area, or 24 for USA models.

	RET
