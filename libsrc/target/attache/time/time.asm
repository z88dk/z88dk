 ;
 ;    time_t time(time_t *)
 ;
 ;    Return number of seconds since epoch
 ;
 ;    Our epoch is the UNIX epoch of 00:00:00 1/1/1970
 ;  CP/M epoch is 1/1/1978
 ; 

 ;    Version for the BIOS time service in the Otrona Attache
 ;  The emulated Attache provides a 2 digits Y2K 'compliant' value for year 
 ;
 ; --------
 ; $Id: time.asm $
 ;

SECTION smc_clib

PUBLIC  time
PUBLIC  _time

EXTERN  mktime, __bdos

time:
_time:

    pop     de
    pop     hl
    push    hl
    push    de
    push    ix          ; save callers ix

    ld      a,h
    or      l
    jr      nz,haveparm
    ld      hl,tm_struct    ; use our workspace as a foo parameter location
haveparm:
    push    hl


;---------------------

	;  The Otrona Attachè uses the console to talk to the calendr
	
    ld      c,2
    ld      e,27        ; ESC
    call    __bdos
    ld      c,2
    ld      e,':'       ; 'Today is' ?
    call    __bdos


skip_weekday:
	LD 	c,6
	ld	e,255
	call	__bdos
	and	a
	jr	z,skip_weekday
;	ld      (weekday),a

    call    unbcd
	ld      (mday),a
    call    unbcd
	ld      (month),a
    call    unbcd       ; decode year and put in HL and in A
	ld      (year),a
	

;---------------------

	;  The Otrona Attachè uses the console to talk to the clock driver
	
    ld      c,2
    ld      e,27        ; ESC
    call    __bdos
    ld      c,2
    ld      e,'>'       ; 'what time is it' ?
    call    __bdos

    call    unbcd       ; decode seconds and put in HL
    ld      (secs),a
    call    unbcd       ; decode minutes and put in HL
    ld      (mins),a
    call    unbcd       ; decode minutes and put in HL
    ld      (hours),a

;---------------------

	ld      bc,tm_struct
	push    bc
    call    mktime
	pop     bc
    
    pop     ix
    ld      (ix+0),l
    ld      (ix+1),h
    ld      (ix+2),e
    ld      (ix+3),d
    pop     ix          ;restore callers ix
    ret







;  We just pick a 2 digit number from STDIN
;  'unbcd' name is kept for parallelism with the CP/M routines

unbcd:
	LD 	c,6
	ld	e,255
	call	__bdos
	and	a
	jr	z,unbcd
	push af
unbcd2:
	LD 	c,6
	ld	e,255
	call	__bdos
	and	a
	jr	z,unbcd2
    sub     '0'
    ld      e,a
    add     a
    add     a
    add     e
    add     a           ; *10
    ld      e,a
    pop     hl
    ld      a,h
    sub     '0'
    add     e
    ld      l,a
    ld      h,0
    ret


    SECTION    bss_clib

tm_struct:
secs:    defs    2
mins:    defs    2
hours:   defs    2
mday:    defs    2
month:   defs    2
year:    defs    2
; tm_wday,tm_yday,tm_isdst
         defs    6





    SECTION rodata_clib

mdays: defw 0, 31, 31+29, 31+29+31, 31+29+31+30, 31+29+31+30+31
       defw 31+29+31+30+31+30, 31+29+31+30+31+30+31, 31+29+31+30+31+30+31+31
       defw 31+29+31+30+31+30+31+31+30, 31+29+31+30+31+30+31+31+30+31
       defw 31+29+31+30+31+30+31+31+30+31+30

