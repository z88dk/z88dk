;       CRT0 for the Amstrad CPC family
;
;       Stefano Bodrato 8/6/2000
;
;       $Id: cpc_crt0.asm,v 1.30 2016-05-16 03:17:54 aralbrec Exp $
;

        MODULE  cpc_crt0


;--------
; Include zcc_opt.def to find out some info
;--------
        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)

        PUBLIC    exitsp          ;atexit() variables
        PUBLIC    exitcount

        PUBLIC    heaplast        ;Near malloc heap variables
        PUBLIC    heapblocks

        PUBLIC    __sgoioblk      ;stdio info block

        PUBLIC    base_graphics   ;Graphical variables
        PUBLIC    coords          ;Current xy position

        PUBLIC    snd_tick        ;Sound variable
        PUBLIC    bit_irqstatus   ;current irq status when DI is necessary

        PUBLIC    cpc_enable_fw_exx_set       ;needed by firmware interposer
        PUBLIC    cpc_enable_process_exx_set  ;needed by firmware interposer
		
		GLOBAL    __interposer_isr__

;--------
; Set an origin for the application (-zorg=) default to $1200
;--------

        IF      !myzorg
                defc    myzorg  = $1200
        ENDIF   
                org     myzorg


;--------
; REAL CODE
;--------

start:

        di
		
		; move stack
		
        ld      (start1+1),sp
		
		IFNDEF STACKPTR
			ld sp,(0xae60)               ; set stack location to last byte of udg area
		ELSE
			IF STACKPTR > -1
				ld sp,STACKPTR          ; user supplied stack location
			ENDIF
		ENDIF
		
		; make room for exit stack
		
		ld      hl,-64                  ; reserve space for 32 entries on the exit stack
		add     hl,sp
        ld      sp,hl
		
        ld      (exitsp),sp

		; enable process exx set
		; install interrupt interposer
		
		call    cpc_enable_process_exx_set

		ei

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF

IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
; Set up the std* stuff so we can be called again
        ld      hl,__sgoioblk+2
        ld      (hl),19 ;stdin
        ld      hl,__sgoioblk+6
        ld      (hl),21 ;stdout
        ld      hl,__sgoioblk+10
        ld      (hl),21 ;stderr
ENDIF
ENDIF


; INIT math identify platform
IF NEED_floatpack
        EXTERN     init_floatpack
        call    init_floatpack
ENDIF

        call    _main

cleanup:
;
;       Deallocate memory which has been allocated here!
;

IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
        EXTERN     closeall
        call    closeall
ENDIF
ENDIF

        di
		
		call    cpc_enable_fw_exx_set
start1: ld      sp,0

        ei
        ret

l_dcal: jp      (hl)


; These subroutines make it possible to coexist with the firmware.
; Interrupts must be disabled while these routines run.

cpc_enable_fw_exx_set:

   exx
   ex af,af'

   ld (__process_exx_set_hl__),hl      ; save process exx set
   ld (__process_exx_set_de__),de
   ld (__process_exx_set_bc__),bc
   push af
   pop hl
   ld (__process_exx_set_af__),hl
   
   ld hl,(__fw_int_address__)
   ld (0x0039),hl                      ; restore firmware isr
   
   ld bc,(__fw_exx_set_bc__)           ; restore firmware exx set
   or a
   
   ex af,af'
   exx
   
   ret

cpc_enable_process_exx_set:
   
   exx
   ex af,af'

   ld (__fw_exx_set_bc__),bc           ; save firmware exx set
   
   ld hl,(0x0039)
   ld (__fw_int_address__),hl          ; save firmware interrupt entry
   
   ld hl,__interposer_isr__
   ld (0x0039),hl                      ; interposer receives interrupts
   
   ld hl,(__process_exx_set_af__)      ; restore process exx set
   push hl
   pop af
   ld bc,(__process_exx_set_bc__)
   ld de,(__process_exx_set_de__)
   ld hl,(__process_exx_set_hl__)
   
   ex af,af'
   exx

   ret

IF startup != 2

__interposer_isr__:

   call cpc_enable_fw_exx_set
   call 0x0038
   di
   call cpc_enable_process_exx_set
   ei
   ret

ENDIF

__fw_exx_set_bc__:        defs 2

__process_exx_set_af__:   defs 2
__process_exx_set_bc__:   defs 2
__process_exx_set_de__:   defs 2
__process_exx_set_hl__:   defs 2

__fw_int_address__:       defs 2


; Now, define some values for stdin, stdout, stderr

__sgoioblk:
IF DEFINED_ANSIstdio
        INCLUDE "stdio_fp.asm"
ELSE
        defw    -11,-12,-10
ENDIF


               INCLUDE "crt0_runtime_selection.asm"
 

exitsp:         defw    0       ;  atexit       
exitcount:      defb    0
base_graphics:
                defw    $C000
coords:         defw    0
firmware_bc:    defw    0
firmware_af:    defw    0

heaplast:       defw    0       ; Address of last block on heap
heapblocks:     defw    0       ; Number of blocks

IF DEFINED_USING_amalloc
EXTERN ASMTAIL
PUBLIC _heap
; The heap pointer will be wiped at startup,
; but first its value (based on ASMTAIL)
; will be kept for sbrk() to setup the malloc area
_heap:
                defw ASMTAIL	; Location of the last program byte
                defw 0
ENDIF

IF DEFINED_NEED1bitsound
snd_tick:       defb	0	; Sound variable
bit_irqstatus:	defw	0
ENDIF

                defm    "Small C+ CPC"
                defb    0

IF NEED_floatpack
        INCLUDE         "float.asm"
;init_floatpack:
;       ret

;seed for random number generator - not used yet..
fp_seed:        defb    $80,$80,0,0,0,0
;Floating point registers...
extra:          defs    6
fa:             defs    6
fasign:         defb    0

ENDIF
