;       TS 2068 startup code
;
;       $Id: ts2068_crt0.asm,v 1.30 2016-07-15 21:03:25 dom Exp $
;


                MODULE  ts2068_crt0


;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ; main() is always external to crt0 code

        PUBLIC    cleanup         ; jp'd to by exit()
        PUBLIC    l_dcal          ; jp(hl)


        PUBLIC    call_rom3       ; Interposer

        PUBLIC    call_extrom     ; TS2068 extension ROM interposer

        PUBLIC    _FRAMES
        defc    _FRAMES = 23672	; Timer

;--------
; Set an origin for the application (-zorg=) default to 32768
;--------

        IF DEFINED_ZXVGS
        IF !DEFINED_CRT_ORG_CODE
                DEFC    CRT_ORG_CODE = $5CCB    ;repleaces BASIC program
		defc	DEFINED_CRT_ORG_CODE = 1
        ENDIF
        IF !STACKPTR
                DEFC    STACKPTR = $FF57  ;below UDG, keep eye when using banks
        ENDIF
        ENDIF

        
        IF      !DEFINED_CRT_ORG_CODE
        IF (startup=2)
                defc    CRT_ORG_CODE  = 40000
        ELSE
                defc    CRT_ORG_CODE  = 32768
        ENDIF
        ENDIF
        IF !STACKPTR
                DEFC    STACKPTR = CRT_ORG_CODE-1  ;below UDG, keep eye when using banks
        ENDIF
                org     CRT_ORG_CODE


start:
        ld	iy,23610	; restore the right iy value, fixes the self-relocating trick
IF !DEFINED_ZXVGS
        ld      (start1+1),sp	;Save entry stack
ENDIF
IF 	STACKPTR
        ld	sp,STACKPTR
ENDIF
        exx
        ld	(hl1save + 1),hl

        ld      hl,-64
        add     hl,sp
        ld      sp,hl
	call	crt0_init_bss
        ld      (exitsp),sp

; Optional definition for auto MALLOC init; it takes
; all the space between the end of the program and UDG
IF DEFINED_USING_amalloc
		ld	hl,_heap
		ld	c,(hl)
		inc	hl
		ld	b,(hl)
		inc bc
		; compact way to do "mallinit()"
		xor	a
		ld	(hl),a
		dec hl
		ld	(hl),a

		;  Stack is somewhere else, no need to reduce the size for malloc
		ld	hl,65535-168 ; Preserve UDG
		sbc hl,bc	; hl = total free memory

		push bc ; main address for malloc area
		push hl	; area size
		EXTERN sbrk_callee
		call	sbrk_callee
ENDIF

       
IF (startup=2)
		ld		hl,$6000
		ld		de,$6001
		ld		(hl),0
		ld		bc,6143
		ldir
		;ld      a,@01000110	; disable interrupts
		ld      a,@00000110
		out     (255),a
ENDIF
        
        
        call    _main		;Call user program
cleanup:
;
;       Deallocate memory which has been allocated here!
;
	push	hl
IF !DEFINED_nostreams
	EXTERN	closeall
	call	closeall
ENDIF
cleanup_exit:
hl1save:
	ld	hl,0
	exx

        pop     bc
start1: ld      sp,0            ;Restore stack to entry value
        ret
ENDIF

l_dcal:	jp	(hl)		;Used for function pointer calls



; Call a routine in the spectrum ROM
; The routine to call is stored in the two bytes following
call_rom3:
		in      a,($f4)
		ld      (banksv+1),a
		and     @11111100
		out     ($f4),a
		
        exx                      ; Use alternate registers
        ex      (sp),hl          ; get return address
        ld      c,(hl)
        inc     hl
        ld      b,(hl)           ; BC=BASIC address
        inc     hl
        ex      (sp),hl          ; restore return address
        push    bc
        exx                      ; Back to the regular set
.banksv
        ld      a,0
		out ($f4),a
        ret

call_extrom:
		di
		push af
		in	a,($ff)
		set	7,a
		out	($ff),a
		in	a,($f4)
		ld	(hssave),a
		ld	a,1
		out ($f4),a
		pop	af
		push	hl
		ld	hl,call_extrom_exit
		ex	(sp),hl
		jp	(hl)

hssave:	defb 0

call_extrom_exit:
		ld	a,(hssave)
		out	($f4),a
		in	a,($ff)
		res	7,a
		out	($ff),a
		ei
		ret

	defm	"Small C+ TS2068"	;Unnecessary file signature
	defb	0

	INCLUDE	"crt0_runtime_selection.asm"
        INCLUDE "crt0_section.asm"

        SECTION bss_crt

        SECTION rodata_clib
; Default block size for "gendos.lib"
; every single block (up to 36) is written in a separate file
; the bigger RND_BLOCKSIZE, bigger can be the output file size
; but this comes at cost of the malloc'd space for the internal buffer
; Current block size is kept in a control block (just a structure saved
; in a separate file, so changing this value
; at runtime before creating a file is perfectly legal.
_RND_BLOCKSIZE:	defw	1000

