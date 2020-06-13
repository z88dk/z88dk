;	A couple of routines for +3 library


; 	Routine to call +3DOS Routines. Located in startup
;	code to ensure we don't get paged out
;	(These routines have to be below 49152)
;
;	djm 17/3/2000 (after the manual!)
;
;	$Id: dodos.asm,v 1.3 2016-03-07 13:44:48 dom Exp $

	SECTION	code_driver
	PUBLIC	dodos

        EXTERN  l_push_di
        EXTERN  l_pop_ei
        EXTERN  l_jpiy

dodos:
        call    dodos2          ;dummy routine to restore iy afterwards
        ld      iy,23610
        ret
dodos2:
        push    af
        push    bc
        call    l_push_di
        ld      a,7
        ld      bc,32765
        ld      (23388),a
        out     (c),a
        call    l_pop_ei
        pop     bc
        pop     af
        call    l_jpiy
        push    af
        push    bc
        call    l_push_di
        ld      a,16
        ld      bc,32765
        ld      (23388),a
        out     (c),a
        call    l_pop_ei
        pop     bc
        pop     af
        ret
