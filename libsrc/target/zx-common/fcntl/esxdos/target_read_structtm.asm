

SECTION code_time

PUBLIC target_read_structtm
PUBLIC time
PUBLIC _time
EXTERN _time_from_structtm

EXTERN asm_tm_from_dostm
EXTERN asm_esx_m_getdate


defc time = _time_from_structtm
defc _time = time

; struct tm {
;        int tm_sec;
;        int tm_min;
;        int tm_hour;
;        int tm_mday;
;        int tm_mon;
;        int tm_year;
;...
;};
; struct dos_tm {
;   uint16_t time;
;   uint16_t date;
;};


; Entry: hl = struct tm to fill out
; Return hl = 1 = success
; int target_read_structtm(struct tm *) __z88dk_fastcall
target_read_structtm:
    push   bc
    push   bc
    push   hl
    ld     hl,2
    add    hl,sp
    call   asm_esx_m_getdate
    jr     c,error_return
    ld     hl,2
    add    hl,sp
    pop    de
    call   asm_tm_from_dostm
    pop    bc
    pop    bc
    ld     hl,1
    ret

error_return:
    pop  bc
    pop  bc
    pop  bc
    ld   hl,0
    ret
