;       CRT0 stub for the Old School Computer Architecture (FLOS)
;
;       Stefano Bodrato - Jul. 2011
;
;
;       EXTRA OPTIONS:
;
;		At C source level:
;       #pragma output osca_bank=(0..14) set the memory bank for locations > 32768 before loading program
;		#pragma output osca_stack=<value> put the stack in a differen place, i.e. 32767
;		#pragma output nostreams       - No stdio disc files
;		#pragma output noredir         - do not insert the file redirection option while parsing the
;		                                 command line arguments (useless if "nostreams" is set)
;		#pragma output osca_notimer    - Save very few bytes and excludes the clock handling, 
;                                        thus disabling those functions connected to time.h
;		#pragma output osca_restoretxt - works only with FLOS > v547, restores the text mode on program exit
;
;       At compile time:
;		-zorg=<location> parameter permits to specify the program position
;
;	$Id: osca_crt0.asm,v 1.38 2016-07-15 21:38:08 dom Exp $
;


                MODULE  osca_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

		defc    crt0 = 1
                INCLUDE "zcc_opt.def"

; No matter what set up we have, main is always, always external to
; this file

        EXTERN    _main
        

;
; Some variables which are needed for both app and basic startup
;

        PUBLIC    cleanup
        PUBLIC    l_dcal


; FLOS system variables
        PUBLIC	sector_lba0		; keep this byte order
        PUBLIC	sector_lba1
        PUBLIC	sector_lba2
        PUBLIC	sector_lba3

        PUBLIC	a_store1		
        PUBLIC	bc_store1
        PUBLIC	de_store1
        PUBLIC	hl_store1
        PUBLIC	a_store2
        PUBLIC	bc_store2
        PUBLIC	de_store2
        PUBLIC	hl_store2
        PUBLIC	storeix
        PUBLIC	storeiy
        PUBLIC	storesp
        PUBLIC	storepc
        PUBLIC	storef	  
        PUBLIC	store_registers
        PUBLIC	com_start_addr

        PUBLIC	cursor_y		;keep this byte order 
        PUBLIC	cursor_x		;(allows read as word with y=LSB) 
		
        PUBLIC	current_scancode
        PUBLIC	current_asciicode


;--------
; OSCA / FLOS specific definitions
;--------

        INCLUDE "flos.def"
        INCLUDE "osca.def"


; Now, getting to the real stuff now!


;--------
; Set an origin for the application (-zorg=) default to $5000
;--------

IF      !DEFINED_CRT_ORG_CODE
	defc    CRT_ORG_CODE  = $5000
ENDIF


IF ((CRT_ORG_CODE = $5000) | (!DEFINED_osca_bank))
       org	CRT_ORG_CODE
ELSE
	; optional Program Location File Header
	org	CRT_ORG_CODE
	defb	$ed
	defb	$00
	jr	start
	defw	CRT_ORG_CODE
    IF DEFINED_osca_bank
	defb	osca_bank
    ELSE
	defb    0
    ENDIF
	defb	$00 ; control byte: 1=truncate basing on next 3 bytes
	;defw	0   ; Load length 15:0 only needed if truncate flag is set
	;defb	0	; Load length ..bits 23:16, only needed if truncate flag is set
ENDIF
	
start:
        di
	ld	b,h
	ld	c,l

        ld      hl,0
        add     hl,sp
        ld      (start1+1),hl
IF (!DEFINED_osca_stack)
        ld      sp,-64
ELSE
        ld      sp,osca_stack
ENDIF
        ;ld      sp,$7FFF
	push	bc		
	call	crt0_init_bss
	pop	bc
        ld      (exitsp),sp
        push	bc  ; keep ptr to arg list

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
	INCLUDE "amalloc.def"
ENDIF

IF (!DEFINED_osca_notimer)

        ld  hl,(FLOS_irq_vector)            		; The label "irq_vector" = $A01 (contained in equates file)
        ld  (original_irq_vector),hl   		; Store the original FLOS vecotr for restoration later.
        ld  hl,my_custom_irq_handler
        ld  (FLOS_irq_vector),hl

        ld  a,@10000111                		; Enable keyboard, mouse and timer interrupts
        out  (sys_irq_enable),a

        ld a,250
        neg
        out (sys_timer),a

        ld  a,@00000100
        out  (sys_clear_irq_flags),a           ; Clear the timer IRQ flag
ELSE
	ld	b,255
.v_srand_loop
	ld	hl,FLOSvarsaddr
	add	(hl)
	ld	(FRAMES),a
	inc hl
	djnz v_srand_loop
ENDIF
        ei
        
	; Push pointers to argv[n] onto the stack now
	; We must start from the end 
	pop	hl	; command line back again
	ld	bc,0
	ld	a,(hl)
	and	a
	jr	z,argv_done
	dec	hl
find_end:
	inc	hl
	inc	c
	ld	a,(hl)
	and	a
	jr	nz,find_end
	dec	hl

	INCLUDE "crt0_command_line.asm"

        push    hl      ;argv
        push    bc      ;argc

	call    _main		;Call user code

	pop	bc	;kill argv
	pop	bc	;kill argc

cleanup:
;
;       Deallocate memory which has been allocated here!
;
        push	hl		;save exit value
IF !DEFINED_nostreams
	EXTERN	closeall
	call	closeall
ENDIF
	; kjt_flos_display restores the text mode but makes the screen flicker
	; if it is in text mode already
	;
IF (DEFINED_osca_restoretxt)
        call	$10c4 ; kjt_flos_display (added in v547)
ENDIF
IF (!DEFINED_osca_notimer)
        di
        ld		hl,(original_irq_vector)
        ld		(FLOS_irq_vector),hl
        ld		a,@10000011                     ; Enable keyboard and mouse interrupts only
        out		(sys_irq_enable),a
        ei
ENDIF
        pop	hl	; restore exit value
start1:
        ld	sp,0
        xor	a
        or	h	; ATM we are not mamaging the 'spawn' exception
        jr	nz,cmdok
        ld	l,a
cmdok:
        ld	a,l	; return code (lowest byte only)
        and	a	; set Z flag to set the eventual error condition
        ;xor a ; (set A and flags for RESULT=OK)
        ret

l_dcal:
        jp      (hl)

IF (!DEFINED_osca_notimer)
; ----------------------------------
; Custom Interrupt handlers
; ----------------------------------
my_custom_irq_handler:
        push af
        in  a,(sys_irq_ps2_flags)
        bit  0,a        
        call nz,kjt_keyboard_irq_code      ; Kernal keyboard irq handler
        bit  1,a
        call nz,kjt_mouse_irq_code         ; Kernal mouse irq handler
        bit  2,a
        call nz,my_timer_irq_code          ; User's timer irq handler
        pop af
        ei
        reti

my_timer_irq_code:
        push af                            ; (do whatever, push/pop registers!)
        push hl

;        ld hl,(frames_pre)
;        inc (hl)
;        ld a,(hl)
;        bit 4,a
;        jr nz,timer_irq_count_done

        ld hl,(FRAMES)
        inc hl
        ld (FRAMES),hl
        ;;ld	(palette),hl		; testing purposes
        ld a,h
        or l
        jr nz,timer_irq_count_done
        ld hl,(FRAMES+2)
        inc hl
        ld (FRAMES+2),hl

timer_irq_count_done:
        ld  a,@00000100
        out  (sys_clear_irq_flags),a           ; Clear the timer IRQ flag

        pop  hl
        pop  af
        ret
ENDIF

	SECTION		bss_crt

        PUBLIC	FRAMES
original_irq_vector:
	defw 0

FRAMES:
	defw 0
	defw 0



         defm  "Small C+ OSCA"
end:
         defb  0


;--------------------------------------------------------------------------------------------
;
; OS_variables location as defined in system_equates.asm
; FLOSv582 sets it to $B00, hopefully it won't change much
; but we keep the option for making it dynamic
;
;--------------------------------------------------------------------------------------------

IF !DEFINED_FLOSvarsaddr
      defc FLOSvarsaddr = $B00
ENDIF

;--------------------------------------------------------------------------------------------

DEFVARS FLOSvarsaddr
{

sector_lba0	ds.b 1		; keep this byte order
sector_lba1	ds.b 1
sector_lba2	ds.b 1
sector_lba3	ds.b 1

a_store1		ds.b 1		
bc_store1		ds.b 2
de_store1		ds.b 2
hl_store1		ds.b 2
a_store2		ds.b 1
bc_store2		ds.b 2
de_store2		ds.b 2
hl_store2		ds.b 2
storeix		ds.b 2
storeiy		ds.b 2
storesp		ds.b 2
storepc		ds.b 2
storef	  	ds.b 1
store_registers	ds.b 1
com_start_addr	ds.w 1

cursor_y		ds.b 1		;keep this byte order 
cursor_x		ds.b 1		;(allows read as word with y=LSB) 

current_scancode	ds.b 1
current_asciicode	ds.b 1

; The other variable positions depend on the FLOS version
; ..
}

;--------------------------------------------------------------------------------------------

        INCLUDE "crt0_runtime_selection.asm"
	INCLUDE "crt0_section.asm"

	SECTION  code_crt_init
	ld	hl,$2000
	ld	(base_graphics),hl


        SECTION  rodata_clib
IF !DEFINED_noredir
IF !DEFINED_nostreams
redir_fopen_flag:               defb    'w',0
redir_fopen_flagr:              defb    'r',0
ENDIF
ENDIF



; SD CARD interface
IF DEFINED_NEED_SDCARD
	SECTION bss_crt
	PUBLIC card_select
	PUBLIC sd_card_info

	PUBLIC sector_buffer_loc

; Keep the following 2 bytes in the right order (1-card_select, 2-sd_card_info) !!!
card_select:		defb    0    ; Currently selected MMC/SD slot
sd_card_info:		defb    0    ; Card type flags..

sector_buffer_loc:	defw	0
sector_buffer:		defs	513

	SECTION code_crt_init
	ld	hl,sector_buffer
	ld	(sector_buffer_loc),hl

ENDIF

