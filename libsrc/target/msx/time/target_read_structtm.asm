

SECTION code_clib

INCLUDE "target/msx/def/msxdos.def"

PUBLIC target_read_structtm

EXTERN MSXDOS

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

; Entry: hl = struct tm to fill out
; Return hl = 1 = success
; int target_read_structtm(struct tm *) __z88dk_fastcall
target_read_structtm:
    push    hl
    ld      c,_GTIME
    call    MSXDOS
    pop     ix
    ld      (ix+0),d
    ld      (ix+1),0
    ld      (ix+2),l
    ld      (ix+3),0
    ld      (ix+4),h
    ld      (ix+5),0
    push    ix
    ld      c,_GDATE
    call    MSXDOS
    pop     ix
    ld      (ix+6),e
    ld      (ix+7),0
    dec     d
    ld      (ix+8),d
    ld      (ix+9),0
    ld      de,1900
    and     a
    sbc     hl,de
    ld      (ix+10),l
    ld      (ix+11),h
    ld      hl,1
    ret
