;
; 	ANSI Video handling for the Robotron Z9001
;
;	Stefano Bodrato - Sept. 2016
;
;
; 	CLS - Clear the screen
;	
;
;
;	$Id: f_ansi_cls.asm,v 1.1 2016-09-23 06:21:35 stefano Exp $
;

    SECTION  code_clib
    PUBLIC	ansi_cls

    EXTERN  KRT_DISABLE
    EXTERN  KRT_PORT
    EXTERN	__z9001_attr

.ansi_cls
    ld      a,KRT_DISABLE
    out     (KRT_PORT),a
    ld      hl,$EC00
    ld      (hl),32 ;' '
    ld      d,h
    ld      e,l
    inc     de
    ld      bc,40*24 - 1
    ldir
    ld      hl,$EC00 - 1024
    ld      a,(__z9001_attr)
    ld      (hl),a
    ld      d,h
    ld      e,l
    inc     de
    ld      bc,40 * 24 - 1
    ldir
    ret
