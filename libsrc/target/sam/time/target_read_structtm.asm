
SECTION code_clib

PUBLIC target_read_structtm
PUBLIC time
PUBLIC _time
EXTERN _time_from_structtm

defc time = _time_from_structtm
defc _time = time

defc CLOCK_PORT = 0xef

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
    ex      de,hl
    ld      hl,0
    ld      a,(clock_available)
    dec     a
    jp      z,read_sambus_clock
    dec     a
    jp      z,read_dallas_clock
    ret

read_sambus_clock:
    ex      de,hl
    ld      bc,CLOCK_PORT
    ld      d,@00000111
    call    read_clock8         ;Read seconds
    ld      d,@00000111
    call    read_clock8         ;Read min
    ld      d,@00000011
    call    read_clock8         ;Read hour
    ld      d,@00000011
    call    read_clock8         ;Read mday
    ld      d,@00000001
    call    read_clock8         ;Read mon
    dec     hl
    dec     hl
    dec     (hl)
    inc     hl
    inc     hl
    ld      d,@11111111
    call    read_clock8         ;Read year
normalise_year:
    dec     hl
    dec     hl
    ld      a,(hl)
    cp      70
    jr      nc,noadjust
    add     100
    ld      (hl),a
noadjust:
    scf
    ret
    
read_clock8:
    in      e,(c)
    ld      a,b
    add     $10
    ld      b,a
    in      a,(c)
    and     d



    ld      d,a
    add     a
    add     a
    add     d
    add     a
    add     e
    ld      (hl),a
    inc     hl
    ld      (hl),0
    inc     hl
    ld      a,b
    add     $10
    ld      b,a
    ret


read_dallas_clock:
    ex      de,hl       ;hl = struct tm
    ld      e,0         ;seconds
    call    read_dallas_decode
    ld      e,2         ;minutes
    call    read_dallas_decode
    ld      e,4         ;hour
    call    read_dallas_decode
    ld      e,7         ;day
    call    read_dallas_decode
    ld      e,8         ;month
    call    read_dallas_decode
    dec     hl
    dec     hl
    dec     (hl)
    inc     hl
    inc     hl
    ld      d,9         ;year
    call    read_dallas_decode
    jr      normalise_year

read_dallas_decode:
    call    read_dallas_reg
    ld      e,a
    and     $f0
    rra
    ld      d,a
    rra
    rra
    sub     d
    add     e
    ld      (hl),a
    inc     hl
    ld      (hl),0
    inc     hl
    ret


;- read A from clock addres E -

read_dallas_reg:
    ld      bc,$feef
    out     (c),e
    inc     b
    in      a,(c)
    ret

write_dallas_reg:
    ld      bc,$feef
    out     (c),e
    inc     b
    out     (c),a
    ret


asm_clock_detect:
    LD      BC,$B0EF       ;BC = Year MSB of realtime clock
    LD      DE,$0F00

    IN      A,(C)          ;read in the Year MSB -- we can pretty much
    PUSH    AF             ;guarantee that this won't change while
                       ;testing for the clock's presence.
clk_llp:
    OUT     (C),D          ;output 15 different values to the clock
    IN      A,(C)          ;and ensure that they can be read back
    AND     15             ;strip unused bits
    CP      D
    JR      NZ,no_clk

    DEC     D
    JR      NZ,clk_llp

    LD      E,1            ;set E to 1 if clock is present
no_clk:
    POP     AF
    OUT     (C),A          ;restore YEAR data.

    LD      a,e
    ld      hl,clock_available
    ld      (hl),e
    and     a
    ret     nz
    ; Detect dallas clock here
    ld      de,$003f
    call    read_dallas_reg
    ex      af,af
test_dallas:
    ld      a,d
    call    write_dallas_reg
    call    read_dallas_reg
    cp      d
    jr      nz,finish_dallas_test
    dec     d
    jr      nz,test_dallas
finish_dallas_test:
    ex      af,af
    call    write_dallas_reg
    ex      af,af
    ; If z then dallas clock
    ld      (hl),0
    ret     nz
    ld      (hl),2      ;dallas clock available
    ret

SECTION bss_clib

clock_available: defb 0

SECTION code_crt_init

    call asm_clock_detect

