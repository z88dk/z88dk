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
;
;       At compile time:
;		-zorg=<location> parameter permits to specify the program position
;
;	$Id: osca_crt0.asm,v 1.11 2012-05-30 07:32:12 stefano Exp $
;


                MODULE  osca_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

                INCLUDE "zcc_opt.def"

; No matter what set up we have, main is always, always external to
; this file

        XREF    _main
        XDEF	snd_tick
;
; Some variables which are needed for both app and basic startup
;

        XDEF    cleanup
        XDEF    l_dcal

; Integer rnd seed

        XDEF    _std_seed

; vprintf is internal to this file so we only ever include one of the set
; of routines

        XDEF	_vfprintf

;Exit variables

        XDEF    exitsp
        XDEF    exitcount

;For stdin, stdout, stder

        XDEF    __sgoioblk

       	XDEF	heaplast	;Near malloc heap variables
        XDEF	heapblocks

; Graphics stuff
        XDEF	base_graphics
        XDEF	coords

; FLOS system variables
        XDEF	sector_lba0		; keep this byte order
        XDEF	sector_lba1
        XDEF	sector_lba2
        XDEF	sector_lba3

        XDEF	a_store1		
        XDEF	bc_store1
        XDEF	de_store1
        XDEF	hl_store1
        XDEF	a_store2
        XDEF	bc_store2
        XDEF	de_store2
        XDEF	hl_store2
        XDEF	storeix
        XDEF	storeiy
        XDEF	storesp
        XDEF	storepc
        XDEF	storef	  
        XDEF	store_registers
        XDEF	com_start_addr

        XDEF	cursor_y		;keep this byte order 
        XDEF	cursor_x		;(allows read as word with y=LSB) 
		
        XDEF	current_scancode
        XDEF	current_asciicode
        XDEF	memmonaddrl
        XDEF	memmonaddrh
        XDEF	ser_loads_banksel
        XDEF	ser_loadaddr
        XDEF	ser_saveaddr
        XDEF	ser_savelengthl
        XDEF	ser_savelengthh
        XDEF	ser_loadlengthl
        XDEF	ser_loadlengthh 

        XDEF	cmdop_start_address
        XDEF	cmdop_end_address

        XDEF	copy_dest_address
        XDEF	copy_dest_bank

        XDEF	in_script_flag
        XDEF	max_bank
        XDEF	script_dir

        XDEF	find_hexstringascii
        XDEF	temphex
        XDEF	os_linecount
        XDEF	ui_index 

        XDEF	commandstring
        XDEF	output_line

        XDEF	os_args_start_lo
        XDEF	os_args_start_hi
        XDEF	os_args_pos_cache

        XDEF	os_extcmd_jmp_addr

        XDEF	os_dir_block_cache

        XDEF	banksel_cache

        XDEF	cursorflashtimer
        XDEF	cursorstatus

        XDEF	script_buffer
        XDEF	script_file_offset
        XDEF	script_buffer_offset
        XDEF	script_orig_dir

        XDEF	scancode_buffer

        XDEF	key_buf_wr_idx
        XDEF	key_buf_rd_idx
        XDEF	key_release_mode		
        XDEF	not_currently_used
        XDEF	key_mod_flags
        XDEF	insert_mode

        XDEF	mouse_packet
        XDEF	mouse_packet_index

        XDEF	use_mouse	

        XDEF	mouse_pos_x
        XDEF	mouse_pos_y
        XDEF	mouse_buttons

        XDEF	mouse_window_size_x
        XDEF	mouse_window_size_y



; Now, getting to the real stuff now!

;--------
; Set an origin for the application (-zorg=) default to $5000
;--------

        IF      !myzorg
                defc    myzorg  = $5000
        ENDIF


	IF ((myzorg = $5000) ~ (!DEFINED_osca_bank))
                org		myzorg
	ELSE
				; optional Program Location File Header
				org		myzorg
				defb	$ed
				defb	$00
				jr	start
				defw	myzorg
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
		;push	hl
		;pop		bc
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
        ld      (exitsp),sp

IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
; Set up the std* stuff so we can be called again
	ld	hl,__sgoioblk+2
	ld	(hl),19	;stdin
	ld	hl,__sgoioblk+6
	ld	(hl),21	;stdout
	ld	hl,__sgoioblk+10
	ld	(hl),21	;stderr
ENDIF
ENDIF


	; Push pointers to argv[n] onto the stack now
	; We must start from the end 
		ld	hl,0	;NULL pointer at end, just in case
		push	hl

		ld	h,b    ; ptr to argument list
		ld	l,c
		ld	b,0    ; parameter counter
		ld	c,b    ; character counter

		ld	a,(hl)
		and	a
		jr	z,argv_done

		dec hl
	find_end:
		inc	hl
		inc c
		ld	a,(hl)
		and	a
		jr	nz,find_end
		dec hl
		; now HL points to the end of command line
		; and C holds the length of args buffer
		
	; Try to find the end of the arguments
	argv_loop_1:
		ld	a,(hl)
		cp	' '
		jr	nz,argv_loop_2
		ld	(hl),0
		dec	hl
		dec	c
		jr	nz,argv_loop_1
	; We've located the end of the last argument, try to find the start
	argv_loop_2:
		ld	a,(hl)
		cp	' '
		jr	nz,argv_loop_3
		ld	(hl),0
		inc	hl
		push	hl
		inc	b
		dec	hl
	argv_loop_3:
		dec	hl
		dec	c
		jr	nz,argv_loop_2

	argv_done:
		ld	hl,end	;name of program (NULL)
		push	hl
		inc	b
		ld	hl,0
		add	hl,sp	;address of argv
		ld	c,b
		ld	b,0
		push	bc	;argc
		push	hl	;argv

			call    _main		;Call user code

		pop	bc	;kill argv
		pop	bc	;kill argc

cleanup:
;
;       Deallocate memory which has been allocated here!
;
        push	hl
IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
	LIB	closeall
	call	closeall
ENDIF
ENDIF
		; kjt_flos_display restores the text mode but makes the screen flicker
		; if it is in text mode already
		;
        ;call	$10c4 ; kjt_flos_display (added in v547)
        pop	hl
start1:
        ld  sp,0
        xor a
        or  h	; ATM we are not mamaging the 'spawn' exception
        jr	nz,cmdok
        ld	l,a
cmdok:
        ld  a,l	; return code (lowest byte only)
        and a	; set Z flag to set the eventual error condition
        ;xor a ; (set A and flags for RESULT=OK)
        ret

l_dcal:
        jp      (hl)

; Now, define some values for stdin, stdout, stderr

__sgoioblk:
IF DEFINED_ANSIstdio
	INCLUDE	"stdio_fp.asm"
ELSE
        defw    -11,-12,-10
ENDIF


; Now, which of the vfprintf routines do we need?


_vfprintf:
IF DEFINED_floatstdio
	LIB	vfprintf_fp
	jp	vfprintf_fp
ELSE
	IF DEFINED_complexstdio
		LIB	vfprintf_comp
		jp	vfprintf_comp
	ELSE
		IF DEFINED_ministdio
			LIB	vfprintf_mini
			jp	vfprintf_mini
		ENDIF
	ENDIF
ENDIF


;Seed for integer rand() routines
_std_seed:       defw    0

;Atexit routine
exitsp:          defw    0
exitcount:       defb    0

; Heap stuff
heaplast:        defw    0
heapblocks:      defw    0

; mem stuff
base_graphics:   defw    $2000
coords:          defw    0
snd_tick:        defb    0


;--------------------------------------------------------------------------------------------
;
; OS_variables location as defined in system_equates.asm
; FLOSv582 sets it to $B00, hopefully it won't change much
; We try to keep it dynamic
;
;--------------------------------------------------------------------------------------------

IF !DEFINED_FLOSvarsaddr
      defc FLOSvarsaddr = $B00
ENDIF

defc OS_window_cols = 40
defc OS_window_rows = 25

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
memmonaddrl	ds.b 1
memmonaddrh	ds.b 1
ser_loads_banksel	ds.b 1
ser_loadaddr	ds.b 2
ser_saveaddr	ds.b 2
ser_savelengthl	ds.b 1
ser_savelengthh	ds.b 1
ser_loadlengthl	ds.b 1
ser_loadlengthh 	ds.b 1

cmdop_start_address	ds.b 2
cmdop_end_address	ds.b 2

copy_dest_address	ds.b 2
copy_dest_bank	ds.b 1

in_script_flag	ds.b 1
max_bank		ds.b 1
script_dir	ds.w 1

find_hexstringascii ds.b 2
temphex		ds.b 1
os_linecount	ds.b 1
ui_index		ds.b 1 

commandstring	ds.b OS_window_cols+2
output_line	ds.b OS_window_cols+2

os_args_start_lo	ds.b 1
os_args_start_hi	ds.b 1
os_args_pos_cache	ds.w 1

os_extcmd_jmp_addr	ds.w 1

os_dir_block_cache  ds.w 1

banksel_cache	ds.b 1

cursorflashtimer	ds.b 1
cursorstatus	ds.b 1

script_buffer		ds.b OS_window_cols+2
script_file_offset		ds.w 1
script_buffer_offset	ds.w 1
script_orig_dir		ds.w 1

scancode_buffer		ds.b 32

key_buf_wr_idx		ds.b 1
key_buf_rd_idx		ds.b 1
key_release_mode		ds.b 1		
not_currently_used		ds.b 1
key_mod_flags		ds.b 1
insert_mode		ds.b 1

mouse_packet		ds.b 3
mouse_packet_index		ds.b 1

use_mouse			ds.b 1

mouse_pos_x		ds.w 1
mouse_pos_y		ds.w 1
mouse_buttons		ds.b 1

mouse_window_size_x		ds.w 1
mouse_window_size_y		ds.w 1

;=======================================================================================
;first_os_var		equ cursor_y
;last_os_var		equ mouse_window_size_y+2
;=======================================================================================
}

defc first_os_var = cursor_y
defc last_os_var  = mouse_window_size_y+2

;--------------------------------------------------------------------------------------------


; Signature
         defm  "Small C+ OSCA"
end:
         defb  0

;All the float stuff is kept in a different file...for ease of altering!
;It will eventually be integrated into the library
;
;Here we have a minor (minor!) problem, we've no idea if we need the
;float package if this is separated from main (we had this problem before
;but it wasn't critical..so, now we will have to read in a file from
;the directory (this will be produced by zcc) which tells us if we need
;the floatpackage, and if so what it is..kludgey, but it might just work!
;
;Brainwave time! The zcc_opt file could actually be written by the
;compiler as it goes through the modules, appending as necessary - this
;way we only include the package if we *really* need it!

IF NEED_floatpack
        INCLUDE         "float.asm"

;seed for random number generator - not used yet..
fp_seed:        defb    $80,$80,0,0,0,0
;Floating point registers...
extra:          defs    6
fa:             defs    6
fasign:         defb    0

ENDIF

