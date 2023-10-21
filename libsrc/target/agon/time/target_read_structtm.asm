
SECTION code_clib

PUBLIC target_read_structtm
PUBLIC time
PUBLIC _time
EXTERN _time_from_structtm

defc time = _time_from_structtm
defc _time = time


INCLUDE "target/agon/def/mos_api.inc"

; struct tm {
;        int tm_sec;
;        int tm_min;
;        int tm_hour;
;        int tm_mday;
;        int tm_mon;
;        int tm_year;
;        int tm_wday;
;        int tm_yday;
;        int tm_isdst;
;};

; Entry: hl = struct tm
; Exit:  hl = 0 failure
;        hl !=0 success
target_read_structtm:
    push    hl
    ; Force a re-read of the rtc
    ld      hl,clockstr
    MOSCALL(mos_getrtc)
    pop     hl
    ; And now we can read the values we care about rather than the string
    push    ix
    MOSCALL(mos_sysvars)
    ld.l    a,(ix+sysvar_rtc+7)	;seconds
    ld      (hl),a
    inc     hl
    ld      (hl),0
    inc     hl
    ld.l    a,(ix+sysvar_rtc+6)	;minutes
    ld      (hl),a
    inc     hl
    ld      (hl),0
    inc     hl
    ld.l    a,(ix+sysvar_rtc+5)	;hours
    ld      (hl),a
    inc     hl
    ld      (hl),0
    inc     hl
    ld.l    a,(ix+sysvar_rtc+2)	;day
    ld      (hl),a
    inc     hl
    ld      (hl),0
    inc     hl
    ld.l    a,(ix+sysvar_rtc+1)	;month
    ld      (hl),a
    inc     hl
    ld      (hl),0
    inc     hl
    ld.l    a,(ix+sysvar_rtc+0)	;year - epoch = 1980
    add     80
    ld      (hl),a
    inc     hl
    ld      (hl),0
    pop     ix
    scf
    ret
    
SECTION bss_clib


clockstr:	defs	30
