;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	custom interrupt code + key scanning
;
;
; ------
; $Id: ozcustomisr.asm,v 1.1 2003-10-21 17:15:20 stefano Exp $
;

	XLIB	ozcustomisr
	
	XDEF	serial_hook
	XDEF	serial_check_hook

	XDEF	ozkeyclick
	XDEF	oz1hz

	XDEF	oz64hz_word
	XDEF	oz64hz_dword
	XDEF	ozi64hztime
	XDEF	oz4sec_word
	XDEF	ozi64hzcount
	XDEF	ozdisablepowerkey

	XDEF	ozgreyscale
	XDEF	ozgreycount

	XDEF	s_64hz_hook
	XDEF	s_64hz_return

	XREF	cleanup		; exit in oz_crt0
	XREF	s_init_unblank	; exit quickly "

	XREF	KeyboardBuffer
	XREF	KeyBufGetPos
	XREF	KeyBufPutPos

	; settings
	
	XREF	ozkeyrepeatspeed
	XREF	ozkeyrepeatdelay
	XREF	ozclick_setting

defc	PauseFirst = 32


ozintwait:
;; waits for a keystroke, serial data, or interrupt event
        di
serial_check_hook:
        jp NoSerialCheck
;$serial_check_hook equ $-2
NoSerialCheck:
        ld a,(KeyBufGetPos)
        ld c,a
        ld a,(KeyBufPutPos)
        cp c
        jr nz,getout
        ei
        halt
getout:
        ei
        ret

PowerOff:
        ld      a,(ozdisablepowerkey)
        or      a
        jp      nz,NotPowerOff
        inc     a
        ld      (ozdisablepowerkey),a

        ld      hl,kPower
        ld      (KeyboardBuffer),hl
        ld      a,0bh
        ld      (KeyBufGetPos),a
        xor     a
        ld      (KeyBufPutPos),a
        ;jp      _exit
        jp      cleanup

FastClock:
        ld      a,(ozgreyscale)
        or      a
        jp      z,FastClockDone
        push    hl
        ld      hl,(ozgreycount)
        dec     hl
        ld      (ozgreycount),hl
        ld      a,l
        or      h
        jp      nz,pophl_FastClockDone
        in      a,(22h)
        xor     4
        out     (22h),a
        ld      hl,110
        jr      z,NotAdd  ;; second page -- only 300 delay
        add     hl,hl
NotAdd:
        ld      (ozgreycount),hl
pophl_FastClockDone:
        pop     hl
FastClockDone:
        ld      a,d
        and     0ffh - 64
        jr      nz,FromFastClock
        ei
        ret


; ------------------------------------

ozcustomisr:
        in      a,(5)
        ld      d,a

        ld      a,0ffh
        out     (6),a

        in      a,(7) ;; mask
        cpl
        and     d
        ld      d,a

        bit     6,d
        jp      nz,FastClock
FromFastClock:

        bit     0,d   ;; e   ;; get keyboard bit
        call    nz,KbdHit

        in      a,(46h)
        and     16
        jp      nz,PowerOff  ;; power switch depressed
NotPowerOff:
        in      a,(12h)
        and     128
        ;jp      z,__exit   ;; battery switch flipped - get out rapidly
        jp	z,s_init_unblank   ;; battery switch flipped - get out rapidly

serial_hook:
        jp      GetOutPopAF
;$serial_hook    equ $-2

GetOutPopAF:
        bit     4,d  ;; 1hz
        jr      nz,Inc1hz
notInc1hz:
        bit     5,d  ;; 64hz
        jp      nz,KbdAndClock
        ei
        ret

Inc1hz:
        push    hl
        ld      hl,(oz1hz)
        inc     hl
        ld      (oz1hz),hl
        pop     hl
        jr      notInc1hz


KbdHit:
ozi64hztime:
        ld      a,PauseFirst+1
;__ozi64hztime equ $-1
        ld      (ozi64hzcount),a
        or      a
        ret     z
        in      a,(7)    
        and     255-32   ;; enable 64hz interrupt
        or      1        ;; disable keyboard interrupt for now
        out     (7),a
        ret

KbdAndClock:
        ld      a,(keybusy)
        or      a
        ret     nz
        dec     a      ; a=ff
        ld      (keybusy),a
        ei
        jp      key_isr
key_isr_ret:
        xor     a
        ld      (keybusy),a
        ret

ozdisablepowerkey:
	defs 1

ozi64hzcount:
	defs 1
ozgreyscale:
	defs 1
ozgreycount:
	defs 2
oz1hz:
	defs 2
oz64hz_word:
oz64hz_dword:
	defs 1
oz4sec_word:
	defs 1
	defs 2
keybusy:
	defs 1


; Keyboard driver adapted from software labeled:
; Source code free for non-commercial use
; Assembled program (C)2000 OZdev <http://www.ozdev.com/>
; Benjamin Green <benjamin@lh.co.nz>

keyTable:        defs 10

mask10:         defs   1
mask11:         defs   1
repeatcount:    defs   1
repeatkey:      defs   2
mask12:         defs   1

defc	Mask2nd   = 01h
defc	MaskNew   = 02h
defc	MaskInv   = 04h
defc	MaskShift = 08h

defc	kPower      =  803Ah
defc	kUpperMenu  =  8068h
defc	kUpperEnter =  8066h
defc	kUpperEsc   =  8067h
defc	kEnter  =    8038h
defc	kLShift =    0000h
defc	kRShift =    8836h
defc	k2nd    =    8137h
defc	kEsc    =    8058h
defc	kMenu   =    8032h
defc	kNew    =    8233h
defc	kInv    =    8435h
defc	kUp     =    8040h
defc	kDown   =    8041h
defc	kRight  =    8043h
defc	kLeft   =    8042h
defc	kMain   =    7025h
defc	kTel    =    70e9h
defc	kSched  =    70eah
defc	kMemo   =    70ebh
defc	kMyProg =    7015h
defc	kLight  =    803bh
defc	kPageUp     =  8044h
defc	kPageDown   =  8045h

key_isr:
	push	bc
	push	de
	push	hl

        ld      hl,ozi64hzcount
        ld      a,(hl)
        or      a
        jr      z,skipCountDown
        dec     a
        ld      (hl),a
        jr      nz,skipCountDown
        in      a,(7)
        or      32      ;; disable 64hz interrupt
        and     255-1   ;; but enable keyboard interrupt
        out     (7),a
skipCountDown:
        ld      hl,(oz64hz_dword)
        ld      bc,1
        add     hl,bc
        ld      (oz64hz_dword),hl
        ld      hl,(oz64hz_dword+2)
        ld      bc,0
        adc     hl,bc
        ld      (oz64hz_dword+2),hl


; global $64hz_hook,$64hz_return
s_64hz_hook:
        jp      s_64hz_return
;$64hz_hook equ $-2
s_64hz_return:

rxxoff_hook:
        jp      noxoff
;$rxxoff_hook    equ $-2
noxoff:

        ld      a,(KeyBufPutPos)
        inc     a
        cp      0ch
        jr      c,dontzero
        xor     a
dontzero:
        ld      b,a
        ld      a,(KeyBufGetPos)
        cp      b
        jp      z,KBufferFull


        xor     a
	out	(11h),a
	ld	a,2
	out	(12h),a
        ld      (mask12),a
	ld	hl,keyTable+8
	in	a,(10h)
	ld	b,(hl)
	ld	(hl),a
	or	b
	xor	b
	and	a
        jr      z,noProgKey1

bitP0:	bit	0,a
	jr	z,bitP1
        ld      a,56
        ld      l,1
        jp      lookup
bitP1:	bit	1,a
	jr	z,bitP2
        ld      a,57
        ld      l,2
        jr      lookup
bitP2:	bit	2,a
	jr	z,bitP3
        ld      a,58
        ld      l,4
	jr	lookup
bitP3:	bit	3,a
	jr	z,bitP4
        ld      a,59
        ld      l,8
	jr	lookup
bitP4:	bit	4,a
	jr	z,bitP6
        ld      a,60
        ld      l,16
	jr	lookup
bitP6:	bit	6,a
        jr      z,noProgKey1
        ld      a,61
        ld      l,64
        jr      lookup

noProgKey1:
        ld      a,1
	out	(12h),a
        ld      (mask12),a
        ld      hl,keyTable+9
	in	a,(10h)
	ld	b,(hl)
	ld	(hl),a
	or	b
	xor	b
	and	a
        jr      z,noProgKey2

abitP0:  bit     0,a
        jr      z,abitP3
        ld      a,62
        ld      l,1
        jp      lookup
abitP3:  bit     3,a
        jr      z,abitP4
        ld      a,63
        ld      l,8
        jr      lookup
abitP4:  bit     4,a
        jr      z,abitP5
        ld      a,64
        ld      l,16
	jr	lookup
abitP5: bit     5,a
        jr      z,abitP6
        ld      a,65
        ld      l,32
	jr	lookup
abitP6: bit     6,a
        jr      z,noProgKey2
        ld      a,66
        ld      l,64
lookup: ld      e,a
        xor     a
        ld      (mask11),a
        ld      a,l
        ld      (mask10),a
        jr      lookup2

noProgKey2:
        xor     a
	out	(12h),a
	ld	hl,keyTable
	ld	de,100h

keyscan:
        ld      a,d
	out	(11h),a
	in	a,(10h)
	ld	b,(hl)
	ld	(hl),a
	or	b
	xor	b
	and	a
	jr	nz,bit0
	inc	e
	inc	hl
	sla	d
	jr	nz,keyscan

bit0:   bit     0,a
	jr	z,bit1
	ld	a,e
        ld      l,1
        jr      rlookup
bit1:	bit	1,a
	jr	z,bit2
	ld	a,e
        add     a,8
        ld      l,2
        jr      rlookup
bit2:	bit	2,a
	jr	z,bit3
	ld	a,e
        add     a,16
        ld      l,4
        jr      rlookup
bit3:	bit	3,a
	jr	z,bit4
	ld	a,e
        add     a,24
        ld      l,8
        jr      rlookup
bit4:	bit	4,a
	jr	z,bit5
	ld	a,e
        add     a,32
        ld      l,16
        jr      rlookup
bit5:	bit	5,a
	jr	z,bit6
	ld	a,e
        add     a,40
        ld      l,32
        jr      rlookup
bit6:	bit	6,a
        jp      z,nokey
	ld	a,e
        add     a,48
        ld      l,64

rlookup:
        ld      e,a
        ld      a,l
        ld      hl,mask10
        ld      (hl),a
        inc     hl  ; =mask11
        ld      (hl),d
        xor     a
        ld      (mask12),a

lookup2:
        xor     a
	ld	hl,keyTable
        ld      b,(hl)
        bit     6,b
	jr	z,no2nd
        ld      a,Mask2nd
no2nd:	bit	5,b
        jr      nz,shift
        ld      hl,keyTable+6
        bit     3,(hl)
        jr      z,noShift
shift:  or      MaskShift
noShift:
        ld      hl,keyTable+3
        bit     6,(hl)
        jr      z,noInv
        or      MaskInv
noInv:
        dec     hl
        bit     6,(hl)
        jr      z,noNew
        or      MaskNew
noNew:
lookupKey:
        ld      b,a
        ld      hl,keys
	ld	d,0
	add	hl,de
        add     hl,de
	ld	a,(hl)
        ld      c,a
        inc     hl
        ld      a,(hl)
        xor     b
        ld      b,a

        ld      hl,repeatcount
        ld      a,(ozkeyrepeatdelay)
        ld      (hl),a
        inc     hl      ; =repeatkey
        ld      (hl),c
        inc     hl
        ld      (hl),b

putinbuf:
        call    KbdHit
        ld      a,(ozclick_setting)
        or      a
        call    nz,ozkeyclick
putinbuf_noclick:

        ld      a,(KeyBufPutPos)
        inc     a
        cp      0ch
        jr      c,dontzero2
        xor     a
dontzero2:
        ld      (KeyBufPutPos),a
        ld      e,a
        ld      d,0
        ld      hl,KeyboardBuffer
        add     hl,de
        add     hl,de
        ld      (hl),c
        inc     hl
        ld      (hl),b
KBufferFull:
iret:	ld	a,0ffh
	out	(11h),a
	out	(12h),a
	pop	hl
	pop	de
	pop	bc
        jp      key_isr_ret

clearrepeat:
        xor     a
        ld      hl,mask11
        ld      (hl),a  ; hl=mask11
        inc     hl
        ld      (hl),a  ; hl=mask12
        jr      iret

nokey:
        ld      a,(mask12)
        ld      hl,mask11
        ld      c,(hl)  ; c=(mask11)
        or      c
        jr      z,iret  ; nothing to repeat

        inc     hl      ; =repeatcount
        inc     hl      ; =repeatkey
        ld      hl,repeatkey
        xor     a
        ld      b,(hl)
        or      b
        jr      z,clearrepeat  ; lower shift - do not repeat
        inc     hl
        ld      a,080h
        and     (hl)
        jr      z,doRepeat  ; not any other shift key
        ld      a,b
        cp      kRShift.and.0ffh
        jr      z,clearrepeat
        cp      kNew.and.0ffh
        jr      z,clearrepeat
        cp      kInv.and.0ffh
        jr      z,clearrepeat
        cp      k2nd.and.0ffh
        jr      z,clearrepeat

doRepeat:
        ld      hl,mask10
        ld      a,c
        out     (11h),a ; set mask
        ld      a,(mask12)
        out     (12h),a
        in      a,(10h)
        and     (hl)    ; (mask10)
        inc     hl      ; =mask11
        jr      z,clearrepeat  ; key to be repeated released
        inc     hl      ; =repeatcount
        dec     (hl)
        ld      a,(hl)
        or      a
        jr      nz,iret ; not time yet

        ld      a,(ozkeyrepeatspeed)
        ld      (hl),a

        inc     hl      ; =repeatkey
        ld      c,(hl)
        inc     hl
        ld      b,(hl)
        jp      putinbuf_noclick

keys:   defw     kEsc,'1','2','3','4','5','6','7'
        defw     'q','w','e','r','t','8','9','0'
        defw     0,'y','u','i','o','p',8,'.'
        defw     'g','h','j','k','l',13,kRShift,','
        defw     'a','s','d','f',kLeft,kDown,kRight,kUp
        defw     kLShift,'z','x','c','v','b','n','m'
        defw     k2nd,kMenu,kNew,kInv,' ','-',kEnter,0
        defw     kMain,kTel,kSched,kMemo,kMyProg,kLight
        defw     kUpperMenu,kUpperEsc,kUpperEnter,kPageUp,kPageDown

ozkeyclick:
        in      a,(15h)
        and     a
        ret     nz      ; bell char takes priority
        ld      a,1
        out     (19h),a
        out     (16h),a
        xor     a
keyclick:       dec     a
        jr      nz,keyclick
        out     (16h),a
dontClick:
        ret

