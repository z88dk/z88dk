;
;       Startup Code for Z88 applications
;
;	The entry point is a dummy function in the DOR which then
;	jumps to routine in this file
;
;       1/4/99 djm
;
;       7/4/99 djm Added function to handle commands - this requires
;       the user to do something for it!
;
;       4/5/99 djm Added in functionality to remove check for expanded
;       machine, not to give those people reluctant to ug something to
;       use, but to save memory in very small apps
;
;	1/4/2000 djm Added in conditionals for:
;		- far heap stuff (Ask GWL for details!)
;		- "ANSI" stdio - i.e. flagged and ungetc'able
;
;	6/10/2001 djm Clean up (after Henk)
;
;	$Id: app_crt0.asm,v 1.30 2016-07-15 19:32:43 dom Exp $


;--------
; Call up some header files (probably too many but...)
;--------
	INCLUDE "stdio.def"
	INCLUDE "fileio.def"
	INCLUDE "memory.def"
	INCLUDE "error.def"
	INCLUDE "time.def"
	INCLUDE "syspar.def"
	INCLUDE "director.def"

;--------
; Set some scope variables
;--------
        PUBLIC    app_entrypoint	;Start of execution in this file 
        EXTERN    applname	;Application name (in DOR)
        EXTERN    in_dor		;DOR address

;--------
; Set an origin for the application (-zorg=) default to 49152
;--------

        IF      !DEFINED_CRT_ORG_CODE
                defc    CRT_ORG_CODE  = 49152
        ENDIF
        org     CRT_ORG_CODE

;--------
; Define the graphics map and segment for apps
;--------
	EXTERN	z88_map_bank
	EXTERN	z88_map_segment
	defc	z88_map_bank = $4D1
	defc	z88_map_segment = 64


;--------
; We need a CRT_Z88_SAFEDATA def. So if not defined set to 0
;--------
        IF      !DEFINED_CRT_Z88_SAFEDATA
                defc    CRT_Z88_SAFEDATA = 0
        ENDIF

	IF	!DEFINED_CRT_Z88_EXPANDED
		defc	CRT_Z88_EXPANDED = 1
	ENDIF

;--------
; Start of execution. We enter with ix pointing to info table about
; memory allocated to us by OZ. 
;--------
app_entrypoint:
crt0_reqpag_check:
	ld	a,0
	and	a
IF CRT_Z88_EXPANDED=0
        jr      z,init_continue
ELSE
        jr      z,init_check_expanded
ENDIF
	add	32
	ld	c,a
        ld      a,(ix+2)	;Check allocated bad memory if needed
        cp      c
        ld      hl,nomemory
IF CRT_Z88_EXPANDED = 0
        jr      nc,init_continue
ELSE
        jr      c,init_error
ENDIF
IF CRT_Z88_EXPANDED != 0
init_check_expanded:
        ld      ix,-1		;Check for an expanded machine
        ld      a,FA_EOF
        call_oz(os_frm)
        jr      z,init_continue
        ld      hl,need_expanded_text
ENDIF

init_error:			;Code to deal with an initialisation error
        push    hl		;The text that we are printing
        ld      hl,clrscr	;Clear the screen
        call_oz(gn_sop)
        ld      hl,windini	;Define a small window
        call_oz(gn_sop)
        pop     hl
        call_oz(gn_sop)		;Print text
        ld      bc,500
        call_oz(os_dly)		;Pause
        xor     a
        call_oz(os_bye)		;Exit

init_continue:			;We had enough memory
        ld   a,SC_DIS		;Disable escape 
        call_oz(Os_Esc)
        xor     a		;Setup our error handler
        ld      b,a
        ld      hl,errhan
        call_oz(os_erh)
        ld      (l_errlevel),a	;Save previous values
        ld      (l_erraddr),hl
        ld      hl,applname	;Name application
        call_oz(dc_nam)
        ld      hl,clrscr	;Setup a BASIC sized window
        call_oz(gn_sop)
        ld      hl,clrscr2
        call_oz(gn_sop)
	
        ld      hl,-64		;Setup atexit() stack
        add     hl,sp
        ld      sp,hl
	call	crt0_init_bss
        ld      (exitsp),sp

IF DEFINED_USING_amalloc
crt0_reqpag_check1:
	ld	hl,0		; reqpag  address
	INCLUDE "amalloc.def"
ENDIF
IF DEFINED_farheapsz
	call	init_far	;Initialise far memory if required
ENDIF
        call    _main		;Call the users code
        xor     a		;Exit with zero 
cleanup:			;Jump back to here from exit()
IF !DEFINED_nostreams
	push	af		;Save exit value
	EXTERN	closeall
	call	closeall	;Close all files
 IF DEFINED_farheapsz
	EXTERN	freeall_far
 	call	freeall_far	;Deallocate far memory
 ENDIF
	pop	af		;Get exit value back
ELSE	;!nostreams
  IF DEFINED_farheapsz
	push	af		;Deallocate far memory
	EXTERN	freeall_far
	call	freeall_far
	pop	af
  ENDIF
ENDIF	;nostreams

        call_oz(os_bye)		;Exit back to OZ

l_dcal:	jp	(hl)		;Used by various things

;-------
; Process a <> command, we call the users handlecmds APPFUNC
;-------
processcmd:
IF DEFINED_handlecmds
        ld      l,a
        ld      h,0
        push    hl
        call    handlecmds
        pop     bc
ENDIF
        ld      hl,0		;dummy return value
        ret


;--------
; Fairly simple error handler
;--------
errhan:	ret	z		;Fatal error - far mem probs?
IF DEFINED_redrawscreen
        cp      RC_Draw		;(Rc_susp for BASIC!)
        jr      nz,errhan2
        push    af		;Call users screen redraw fn if defined
        call    redrawscreen
        pop     af
ENDIF
errhan2:
        cp      RC_Quit		;they don't like us!
        jr      nz,not_quit
IF DEFINED_applicationquit
	call	applicationquit
ENDIF
        xor     a		;Standard cleanup
        jr      cleanup
not_quit:
        xor     a
        ret

;--------
; This bit of code allows us to use OZ ptrs transparently
; We copy any data from up far to a near buffer so that OZ
; is happy about it
; Prototype is extern void __FASTCALL__ *cpfar2near(far void *)
;--------
IF DEFINED_farheapsz
	EXTERN	strcpy_far
_cpfar2near:
	pop	bc	;ret address
	pop	hl
	pop	de	;far ptr
	push	bc	;keep ret address
	ld	a,e
	and	a
	ret	z	;already local
	push	ix	;keep ix safe
	ld	bc,0	;local
	push	bc
	ld	bc,copybuff
	push	bc	;dest
	push	de	;source
	push	hl
	call	strcpy_far
	pop	bc	;dump args
	pop	bc
	pop	bc
	pop	bc
	pop	ix	;get ix back
	ld	hl,copybuff
	ret
ELSE
; We have no far code installed so all we have to do is fix the stack
_cpfar2near:
	pop	bc
	pop	hl
	pop	de
	push	bc
	ret
ENDIF

;--------
; Which printf core routine do we need?
;--------
        INCLUDE "crt0_runtime_selection.asm"

;-------
; Text to define the BASIC style window
;-------
clrscr:		defb    1,'7','#','1',32,32,32+94,32+8,128,1,'2','C','1',0
clrscr2:	defb    1,'2','+','S',1,'2','+','C',0


windini:
          defb   1,'7','#','3',32+7,32+1,32+34,32+7,131     ;dialogue box
          defb   1,'2','C','3',1,'4','+','T','U','R',1,'2','J','C'
          defb   1,'3','@',32,32  ;reset to (0,0)
          defm   "z88dk Application"
          defb   1,'3','@',32,32 ,1,'2','A',32+34  ;keep settings for 10
          defb   1,'7','#','3',32+8,32+3,32+32,32+5,128     ;dialogue box
          defb   1,'2','C','3'
          defb   1,'3','@',32,32,1,'2','+','B'
          defb   0

nomemory:
        defb    1,'3','@',32,32,1,'2','J','C'
        defm    "No memory available"
        defb    13,10,13,10
        defm    "Sorry, please try again later!"
        defb    0

IF CRT_Z88_EXPANDED != 0
need_expanded_text:
        defb    1,'3','@',32,32,1,'2','J','C'
        defm    "Expanded machine needed!"
        defb    0
ENDIF





        ; If we were given a model then use it
IF DEFINED_CRT_MODEL
        defc __crt_model = CRT_MODEL
ELSE
        defc __crt_model = 1
ENDIF

        ; We use a split BSS - so that some basic apps can run without needing bad memory
	; Expose to appmake
	PUBLIC __crt_z88_safedata
	defc __crt_z88_safedata = 120 + CRT_Z88_SAFEDATA
        defc __crt_org_bss = $1ffD - 100 ; __crt_z88_safedata

        ; We have to get user variables to start at 0x2000, and far
        ; data at 8192 to match up with CamelForth
IF CRT_Z88_SAFEDATA = 0
        defc __crt_org_bss_fardata_start = 8192
ENDIF
        INCLUDE "crt0_section.asm"

	SECTION bss_crt
l_erraddr:       defw    0       ;Not sure if these are used...
l_errlevel:      defb    0



IF DEFINED_farheapsz
    IF !CRT_Z88_SAFEDATA
        SECTION code_crt_init
        INCLUDE "init_far.asm"

        SECTION bss_fardata
; If we use CRT_Z88_SAFEDATA then we can't have far memory
        PUBLIC          pool_table
        PUBLIC          malloc_table
        PUBLIC          farpages
        PUBLIC          farmemspec
        pool_table:     defs    224
        malloc_table:   defw    0
        farpages:       defw    1
        farmemspec:     defb    1
        copybuff:       defs    258
        actual_malloc_table: defs ((farheapsz/256)+1)*2
    ENDIF
ENDIF
