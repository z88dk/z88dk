
INCLUDE "config_private.inc"

SECTION rodata_common1_driver

PHASE   __COMMON_AREA_1_PHASE_DRIVER

;------------------------------------------------------------------------------
; start of common area 1 - RST functions
;------------------------------------------------------------------------------

EXTERN _shadowLock, _bankLockBase
EXTERN _bios_sp, _bank_sp

;------------------------------------------------------------------------------

PUBLIC _z180_trap_rst

_z180_trap_rst:         ; RST  0 - also handle an application restart
    ret

;------------------------------------------------------------------------------

PUBLIC _error_handler_rst

_error_handler_rst:     ; RST  8
    pop hl              ; get the originating PC address
    ld e, (hl)          ; get error code in E
    dec hl
    call phexwd         ; output originating RST address on serial port
    ex de, hl           ; get error code in L
    call phex           ; output error code on serial port
    halt

;------------------------------------------------------------------------------

PUBLIC _call_far_rst

_call_far_rst:          ; RST 10
    push af             ; save flags
    push hl
    ld hl, _shadowLock
call_far_try_alt_lock:
    sra (hl)            ; get alt register mutex
    jr C, call_far_try_alt_lock ; just keep trying
    pop hl
    pop af

    ex af,af            ; all your register are belong to us
    exx

    pop hl              ; get the return PC address
    ld e, (hl)          ; get called address in DE
    inc hl
    ld d, (hl)
    inc hl
    ld c, (hl)          ; get called bank in C
    inc hl
    push hl             ; push the post call_far ret address back on stack

    in0 a, (BBR)        ; get the origin bank
    ld b, a             ; save origin BBR in B
    rrca                ; move the origin bank to low nibble
    rrca                ; we know BBR lower nibble is 0
    rrca
    rrca
    add a, c            ; create destination far address, from twos complement relative input
    and a, $0F          ; convert it to 4 bit address (not implicit here)

    ld h, _bankLockBase/$100    ; get the BANK Lock base address, page aligned
    ld l, a             ; make the reference into destination BANKnn Lock

    rlca                ; move the origin bank to high nibble
    rlca                ; we know BBR lower nibble is 0
    rlca
    rlca
    ld c, a             ; hold destination BBR in C

    xor a
    or (hl)             ; check bank is not cold
    jr Z, call_far_exit
    sra (hl)            ; now get the bank lock,
    jr C, call_far_exit ; or exit if the bank is hot

                        ; OK we're going somewhere nice and warm,
                        ; now make the bank switch
    di
    ld (_bank_sp), sp   ; save the origin bank SP in Page0
    out0 (BBR), c       ; make the bank swap
    ld sp, (_bank_sp)   ; set up the new SP in new Page0
    ei
                        ; now prepare for our return
    push bc             ; push on the origin and destination bank

    ld hl, ret_far
    push hl             ; push ret_far function return address
    push de             ; push our destination address

call_far_exit:
    exx
    ex af,af            ; alt register are returned

    push hl
    ld hl, _shadowLock  ; give alt register mutex
    ld (hl), $FE
    pop hl
    ret                 ; takes us out if there's error, or call onwards if success


ret_far:                ; we land back here once the call_far function returns
    push af             ; save flags
    push hl
    ld hl, _shadowLock
ret_far_try_alt_lock:
    sra (hl)            ; get alt register mutex
    jr C, ret_far_try_alt_lock ; just keep trying, can't give up
    pop hl
    pop af

    ex af,af            ; all your register are belong to us
    exx

    pop bc              ; get return (origin) BBR in B, and departing (destination) BBR in C

                        ; we left our origin bank lock unchanged, so it is still locked
    di
    ld (_bank_sp), sp   ; save the departing bank SP in Page0
    out0 (BBR), b       ; make the bank swap
    ld sp, (_bank_sp)   ; set up the originating SP in old Page0
    ei

    ld h, _bankLockBase/$100    ; get the BANK Lock Base, page aligned
    ld a, c             ; make the reference to destination BANKnn Lock
    rrca                ; move the origin bank to low nibble
    rrca                ; we know BBR lower nibble is 0
    rrca
    rrca
    ld l, a
    ld (hl), $FE        ; free the bank we are now departing

    exx                 ; alt registers are returned
    ex af,af

    push hl
    ld hl, _shadowLock  ; give alt register mutex
    ld (hl), $FE
    pop hl
    ret

;------------------------------------------------------------------------------
; void jp_far(far *str, int8_t bank)
;
; str − This is a pointer to the destination array where the content is to be
;       copied, type-cast to a pointer of type void*.
; bank− This is the destination bank, relative to the current bank.
;
; This function returns a void.

; stack:
;   bank far
;   str high
;   str low
;   ret high
;   ret low

PUBLIC _jp_far, _jp_far_rst

_jp_far:
    pop af              ; collect ret address
    pop hl              ; addr in HL
    dec sp
    pop de              ; bank in D
    push af             ; put ret address back for posterity, if called from c application,
                        ; perhaps we'll return one day
                        ; this is the future top of _bios_sp
    ld e, d             ; put bank in E

_jp_far_rst:            ; RST 18
    push de             ; save the jump destination from EHL
    push hl

    ld hl, _shadowLock
jp_far_try_alt_lock:
    sra (hl)            ; get alt register mutex
    jr C, jp_far_try_alt_lock ; just keep trying

    ex af,af            ; all your register are belong to us
    exx

    pop de              ; get jump address in DE
    pop bc              ; get relative jump bank in C  

    in0 a, (BBR)        ; get the origin bank
    rrca                ; move the origin bank to low nibble
    rrca                ; we know BBR lower nibble is 0
    rrca
    rrca
    ld b, a             ; save origin absolute bank in B
    add a, c            ; create destination far address, from twos complement relative input
    and a, $0F          ; convert it to 4 bit address (not implicit here)

    ld h, _bankLockBase/$100    ; get the BANK Lock base address, page aligned
    ld l, a             ; make reference into destination BANKnn Lock

    rlca                ; move the origin bank to high nibble
    rlca                ; we know BBR lower nibble is 0
    rlca
    rlca
    ld c, a             ; hold destination BBR in C

    xor a
    or (hl)            ; check bank is not cold
    jr Z, jp_far_exit
jp_far_try_bank_lock:
    sra (hl)            ; now get the bank lock,
    jr C, jp_far_try_bank_lock  ; keep trying if the bank is hot, we can't go back

                        ; OK we're going somewhere nice and warm,
                        ; now make the bank switch
    xor a
    and b               ; check whether we're jumping from bios
    jr Z, jp_far_from_bios

    di
    ld (_bank_sp), sp   ; save the origin bank SP in Page0
    out0 (BBR), c       ; make the bank swap
    ld sp, (_bank_sp)   ; set up the destination bank SP in new Page0
    ei

jp_far_from_bios_ret:
    push de             ; push our destination address for ret jp

    ld h, _bankLockBase/$100    ; get the BANK Lock Base, page aligned
    ld l, b             ; make reference to originating BANKnn Lock
    ld (hl), $FE        ; free the origin bank, we're not coming back

jp_far_exit:
    exx
    ex af,af            ; alt register are returned

    push hl
    ld hl, _shadowLock  ; give alt register mutex
    ld (hl), $FE
    pop hl

    ret                 ; takes us out if there's error, or jp onwards if success

jp_far_from_bios:
    di
    ld (_bios_sp), sp   ; save the bios SP in COMMON AREA 1
    out0 (BBR), c       ; make the bank swap
    ld sp, (_bank_sp)   ; set up the destination bank SP in new Page0
    ei
    jr jp_far_from_bios_ret

;------------------------------------------------------------------------------

PUBLIC _system_rst

_system_rst:            ; RST 20
    push af             ; save flags
    push hl
    ld hl, _shadowLock

system_try_alt_lock:
    sra (hl)            ; get alt register mutex
    jr C, system_try_alt_lock ; just keep trying
    pop hl
    pop af

    ex af,af            ; all your register are belong to us
    exx

    pop hl              ; get the return PC address
    ld e, (hl)          ; get called address in DE
    inc hl
    ld d, (hl)
    inc hl
    push hl             ; push the post system_rst return address back on stack

    in0 a, (CBAR)       ; get COMMON AREA 1 base address (know BANK base address is 0)
    cp d                ; check whether the called function can be reached in CA1
    jr C, system_local_exit ; success, so we stay local

    in0 b, (BBR)        ; get and save origin BBR in B 
    ld c, 0             ; hold absolute destination, BANK0, in C

    ld hl, _bankLockBase; get the bank Lock Base, for BANK0
system_try_bios_lock:
    sra (hl)            ; now get the bios bank lock,
    jr C, system_try_bios_lock   ; keep trying if bios bank is hot

                        ; now make the bank switch
    di
    ld (_bank_sp), sp   ; save the origin bank SP in Page0
    out0 (BBR), c       ; make the bank swap, use C because out0 doesn't do immediate
    ld sp, (_bios_sp)   ; set up the bios SP
    ei
                        ; now prepare for our return
    push bc             ; push on the origin BBR in B
    inc sp

    ld hl, system_ret
    push hl             ; push system_ret return address

    push de             ; push our destination address

system_exit:
    exx                 ; alt register are returned
    ex af,af
                        ; we keep alt register mutex, as clib has to use alt registers

    ret                 ; takes us out if there's error, or call into yabios if success

system_local_exit:
    push de             ; push our destination address

    exx                 ; alt registers are returned
    ex af,af

    push hl
    ld hl, _shadowLock  ; give alt register mutex
    ld (hl), $FE
    pop hl
    ret                 ; call into yabios CA1

system_ret:             ; we land back here once the yabios call is done
    exx                 ; we still have alt register mutex

    pop bc              ; get return (origin) bank in B
    inc sp
                        ; we left our origin bank locked
    di
    ld (_bios_sp), sp   ; save the departing bios SP
    out0 (BBR), b       ; make the bank swap
    ld sp, (_bank_sp)   ; set up the originating SP in old Page0
    ei

    ld hl, _bankLockBase; get the bank Lock Base, for BANK0
    ld (hl), $FE        ; free the departing bios bank

    exx                 ; alt registers are returned

    push hl
    ld hl, _shadowLock  ; give alt register mutex
    ld (hl), $FE
    pop hl
    ret                 ; ret (jp) to the address that we left on the stack

;------------------------------------------------------------------------------

PUBLIC _exit_far

_exit_far:              ; use this to return to yabios from an exiting application
    push af             ; save flags
    push hl
    ld hl, _shadowLock
exit_far_try_alt_lock:
    sra (hl)            ; get alt register mutex
    jr C, exit_far_try_alt_lock ; just keep trying, can't give up
    pop hl
    pop af

    ex af,af            ; all your register are belong to us
    exx

    xor a               ; hold absolute destination, BANK0, in A
    in0 c, (BBR)        ; get and save origin BBR in C

    ld hl, _bankLockBase; get the bank Lock Base, for BANK0
exit_far_try_bios_lock:
    sra (hl)            ; now get the bios bank lock,
    jr C, exit_far_try_bios_lock   ; keep trying if bios bank is hot

    di
    ld (_bank_sp), sp   ; save the departing bank SP in Page0
    out0 (BBR), a       ; make the bank swap
    ld sp, (_bios_sp)   ; set up the arriving SP in bios
    ei

    ld h, _bankLockBase/$100    ; get the BANK Lock Base, page aligned
    ld a, c             ; make the reference to origin BANKnn Lock
    rrca                ; move the origin bank to low nibble
    rrca                ; we know BBR lower nibble is 0
    rrca
    rrca
    ld l, a
    ld (hl), $FE        ; free the bank we are now departing

    exx                 ; alt registers are returned
    ex af,af

    push hl
    ld hl, _shadowLock  ; give alt register mutex
    ld (hl), $FE
    pop hl
    ret                 ; ret (jp) to the address that we left on the bios stack

;------------------------------------------------------------------------------

PUBLIC _am9511a_rst

_am9511a_rst:           ; RST 28
    pop bc              ; get the return address
    inc bc
    ld a, (bc)          ; get APU command in a
    inc bc
    push bc             ; push the post return address back on stack
    jp asm_am9511a_cmd_ld

;------------------------------------------------------------------------------

PUBLIC _user_rst

_user_rst:              ; RST 30
    ret

;------------------------------------------------------------------------------
; start of common area 1 - system functions
;------------------------------------------------------------------------------

EXTERN _shadowLock, _dmac0Lock

;------------------------------------------------------------------------------
; void *memcpy_far(far *str1, int8_t bank1, const void *str2, const int8_t bank2, size_t n)
;
; str1 − This is a pointer to the destination array where the content is to be
;       copied, type-cast to a pointer of type void*.
; bank1− This is the destination bank, relative to the current bank.
; str2 − This is a pointer to the source of data to be copied,
;       type-cast to a pointer of type const void*.
; bank2− This is the source bank, relative to the current bank.
; n    − This is the number of bytes to be copied.
; 
; This function returns a void* to destination, which is str1, in HL.

; stack:
;   n high
;   n low
;   bank2 far
;   str2 high
;   str2 low
;   bank1 far
;   str1 high
;   str1 low
;   ret high
;   ret low


PUBLIC _memcpy_far

_memcpy_far:
    ld hl, _dmac0Lock
    sra (hl)            ; take the DMAC0 lock
    jr C, _memcpy_far

    ld hl, 9
    add hl, sp          ; pointing at nh bytes
    ld b, (hl)          ; b = nh 
    dec hl   
    ld c, (hl)          ; c = nl

    ld a, b             ; test for zero size, and exit
    or a, c
    jr Z, memcpy_far_error_exit ; return on zero size

    out0 (BCR0H), b     ; set up the transfer size   
    out0 (BCR0L), c
    push bc             ; save transfer size (again)

    dec hl              ; pointing at str2 far

    in0 a, (BBR)        ; get the current bank
    rrca                ; move the current bank to low nibble
    rrca
    rrca
    rrca                ; save current bank in address format
    ld c, a             ; and put it in C

    add a, (hl)         ; create source relative far address, from twos complement input
    and a, $0F          ; convert it to 4 bit positive address (think this is implicit)
    ld b, a             ; hold source far address in B
    out0 (SAR0B), b     ; (SAR0B has only 4 bits)

    dec hl
    ld d, (hl)          ; get source high address in D
    dec hl
    ld e, (hl)          ; get source low address in E

    dec hl              ; pointing at str1 far

    ld a, c             ; get current bank in address format
    add a, (hl)         ; create relative far destination address, from twos complement input
    and a, $0F          ; convert it to 4 bit positive address (think this is implicit)
    ld c, a             ; hold far destination address in C
    out0 (DAR0B), c     ; (DAR0B has only 4 bits)

    dec hl
    ld a, (hl)          ; get destination high address in a (h)
    dec hl
    ld l, (hl)          ; get destination low address l
    ld h, a             ; destination high address in h

    ld a, c
    cp b                ; check for bank dest < src
    ex de, hl           ; now source in hl, destination in de
    jr C, memcpy_far_left_right_early   ; if destination is lower bank, we do left right
                        ; otherwise we need to check further

    xor a               ; clear A and Carry
    sbc hl, de          ; check whether destination address < source address
    jr NC, memcpy_far_left_right  ; if so we can do left to right copy

memcpy_far_right_left:
    add hl, de          ; recover the source address
    pop bc              ; get the size of the copy
    dec bc
    add hl, bc          ; add in the copy size to the (source address -1)

    jr NC, memcpy_far_right_left_src_bank_no_overflow
    in0 a, (SAR0B)
    inc a               ; if copy origin flows into following bank
    out0 (SAR0B), a

memcpy_far_right_left_src_bank_no_overflow:
    ex de, hl           ; swap source to de
    add hl, bc          ; add in the copy size to the (destination address -1)
    jr NC, memcpy_far_right_left_dest_bank_no_overflow
    in0 a, (DAR0B)
    inc a               ; if copy destination flows into following bank
    out0 (DAR0B), a

memcpy_far_right_left_dest_bank_no_overflow:
    out0 (SAR0H), d
    out0 (SAR0L), e
    out0 (DAR0H), h
    out0 (DAR0L), l

    ld bc, +(DMODE_DM0|DMODE_SM0|DMODE_MMOD)*$100+DSTAT_DE0
    out0 (DMODE), b     ; DMODE_MMOD - memory-- to memory--, burst mode
    out0 (DSTAT), c     ; DSTAT_DE0 - enable DMA channel 0, no interrupt
                        ; in burst mode the Z180 CPU stops until the DMA completes

    in0 h, (DAR0H)      ; and now the destination address, post memcpy_far
    in0 l, (DAR0L)

memcpy_far_error_exit:
    ld a, $FE
    ld (_dmac0Lock), a  ; give DMAC0 free
    ret

memcpy_far_left_right:
    add hl, de          ; recover the source address, with no carry
memcpy_far_left_right_early:
    pop bc              ; get the size back, just to balance the stack   
    out0 (SAR0H), h
    out0 (SAR0L), l
    out0 (DAR0H), d
    out0 (DAR0L), e

    ld bc, +(DMODE_MMOD)*$100+DSTAT_DE0
    out0 (DMODE), b     ; DMODE_MMOD - memory++ to memory++, burst mode
    out0 (DSTAT), c     ; DSTAT_DE0 - enable DMA channel 0, no interrupt
                        ; in burst mode the Z180 CPU stops until the DMA completes

    ex de, hl           ; and swap the destination address into hl to return

    jr memcpy_far_error_exit


;------------------------------------------------------------------------------
; void load_hex(uint8_t bankAbs)
;
; bankAbs − This is the absolute bank address (1 to 15), not BANK0.
;
; Type 2 Extended Segment Address (ESA), is equivalent to BBR data, and translates 1:1.
; Therefore BANK changes can be done by inputting the correct ESA data as 0xn000.
;
; This is a system function, and can only be called from BANK0.
;
; Reads the _bios_ioByte bit 0 to determine which serial interface to use.

PUBLIC _load_hex, _load_hex_fastcall

EXTERN _bios_ioByte

EXTERN initString, invalidTypeStr, badCheckSumStr, LoadOKStr

_load_hex:
    pop af
    pop hl
    push hl
    push af

_load_hex_fastcall:
    in0 a, (BBR)                ; grab the current Bank Base Register
    and a                       ; check it is BANK0, so the user can't use this function
    ret NZ

    ld a, l                     ; get the destination bank, to convert to BBR
    and a, $0F                  ; be sure it is sane
    ret Z                       ; and not trying to write to BANK0    

    rrca                        ; move the destination bank to high nibble
    rrca                        ; we know BBR lower nibble is 0
    rrca
    rrca
    out0 (BBR), a               ; set the BBR from BANK0, so no need for stack change

    ld a, (_bios_ioByte)        ; get I/O bit
    rrca                        ; put it in Carry
    jr NC, load_hex_get_lock1   ; ASCI1 TTY=0, ASCI0 CRT=1

load_hex_get_lock0:
    ld hl, _asci0RxLock
    sra (hl)                    ; take the ASCI0 Rx lock
    ret C                       ; return if we can't get lock
    call _asci0_flush_Rx_di     ; flush the ASCI0 Rx buffer     
    jr load_hex_print_init

load_hex_get_lock1:
    ld hl, _asci1RxLock
    sra (hl)                    ; take the ASCI1 Rx lock
    ret C                       ; return if we can't get lock
    call _asci1_flush_Rx_di     ; flush the ASCI1 Rx buffer

load_hex_print_init:
    ld de, initString
    call pstring                ; pstring modifies AF, DE, & HL

load_hex_wait_colon:
    call rchar                  ; Rx byte in L (A = char received too)
    cp CHAR_CTRL_C              ; check for CTRL_C
    jr Z, load_hex_done         ; exit done
    cp ':'                      ; wait for ':'
    jr NZ, load_hex_wait_colon
    ld c, 0                     ; reset C to compute checksum
    call load_hex_read_byte     ; read byte count
    ld b, a                     ; store it in b
    call load_hex_read_byte     ; read upper byte of address
    ld d, a                     ; store in d
    call load_hex_read_byte     ; read lower byte of address
    ld e, a                     ; store in e
    call load_hex_read_byte     ; read record type
    cp 02                       ; check if record type is 02 (ESA)
    jr Z, load_hex_esa_data
    cp 01                       ; check if record type is 01 (end of file)
    jr Z, load_hex_end_load
    cp 00                       ; check if record type is 00 (data)
    jr NZ, load_hex_inval_type  ; if not, error
load_hex_read_data:
    call load_hex_read_byte
    ld (de), a                  ; write the byte at the RAM address
    inc de
    djnz load_hex_read_data     ; if b non zero, loop to get more data
load_hex_read_chksum:
    call load_hex_read_byte     ; read checksum, but we don't need to keep it
    ld a, c                     ; lower byte of c checksum should be 0
    or a
    jr NZ, load_hex_bad_chk     ; non zero, we have an issue
    ld l, '#'                   ; "#" per line loaded
    call pchar                  ; Print it
    jr load_hex_wait_colon

load_hex_esa_data:
    call load_hex_read_byte     ; get high byte of ESA
    and a, $F0                  ; be sure it is sane
    jr Z, load_hex_esa_data_bank0   ; and we're not trying to overwrite yabios RAM
    out0 (BBR), a               ; write it to the BBR
load_hex_esa_data_bank0:
    call load_hex_read_byte     ; get low byte of ESA, abandon it, but calc checksum
    jr load_hex_read_chksum     ; calculate checksum

load_hex_end_load:
    call load_hex_read_byte     ; read checksum, but we don't need to keep it
    ld a, c                     ; lower byte of c checksum should be 0
    or a
    jr NZ, load_hex_bad_chk     ; non zero, we have an issue

load_hex_done:
    ld de, LoadOKStr

load_hex_exit:
    xor a
    out0 (BBR), a               ; get our originating BANK0 BBR back, write it to the BBR

    call pstring                ; pstring modifies AF, DE, & HL

    ld a, (_bios_ioByte)        ; get I/O bit
    rrca                        ; put it in Carry
    jr NC, load_hex_unlock1     ; ASCI1 TTY=0, ASCI0 CRT=1

load_hex_unlock0:
    ld hl, _asci0RxLock         ; give up the ASCI0 Rx mutex
    ld (hl), $FE
    ret

load_hex_unlock1:
    ld hl, _asci1RxLock         ; give up the ASCI1 Rx mutex
    ld (hl), $FE
    ret

load_hex_inval_type:
    ld de, invalidTypeStr
    jr load_hex_exit

load_hex_bad_chk:
    ld de, badCheckSumStr
    jr load_hex_exit

load_hex_read_byte:             ; returns byte in A, checksum in C
    call rhex
    ld l, a                     ; put assembled byte into L
    add a, c                    ; add the byte read to C (for checksum)
    ld c, a
    ld a, l
    ret                         ; return the byte read in L (A = char received too)  


;------------------------------------------------------------------------------
; int8_t bank_get_rel(uint8_t bankAbs)
;
; bankAbs − This is the absolute bank address
;
; Returns the relative bank address

PUBLIC _bank_get_rel, _bank_get_rel_fastcall

_bank_get_rel:
    pop af
    pop hl
    push hl
    push af

_bank_get_rel_fastcall:  
    ld a, l
    and a, $0F          ; limit input to 0 to 15 bank
    ld l, a

    in0 a, (BBR)        ; get the current bank
    rrca                ; move the current bank to low nibble
    rrca
    rrca
    rrca

    sub a, l            ; create source relative far address, from absolute input
    ld l, a

    ret

;------------------------------------------------------------------------------
; uint8_t bank_get_abs(int8_t bankRel)
;
; bankRel − This is the relative bank address (-128 to +127)
;
; Returns the capped absolute bank address (0 to 15)

PUBLIC _bank_get_abs, _bank_get_abs_fastcall

_bank_get_abs:
    pop af
    pop hl
    push hl
    push af

_bank_get_abs_fastcall:
    push af

    in0 a, (BBR)        ; get the current bank
    rrca                ; move the current bank to low nibble
    rrca
    rrca
    rrca

    add a, l            ; create source relative far address, from twos complement input
    and a, $0F          ; convert it to 4 bit positive address
    ld l, a

    pop af
    ret

;------------------------------------------------------------------------------
; void lock_get(uint8_t * mutex)
;
; mutex − This is a pointer to a simple mutex semaphore

PUBLIC _lock_get, _lock_get_fastcall

_lock_get:
    pop af
    pop hl
    push hl
    push af

_lock_get_fastcall:
    sra (hl)
    jr C, _lock_get_fastcall
    ret

;------------------------------------------------------------------------------
; uint8_t lock_try(uint8_t * mutex)
;
; mutex − This is a pointer to a simple mutex semaphore
;
; This function returns 1 if it got the lock, 0 otherwise

PUBLIC _lock_try, _lock_try_fastcall

_lock_try:
    pop af
    pop hl
    push hl
    push af

_lock_try_fastcall:
    sra (hl)
    ld l, 0
    jr C, lock_got_not
    inc l
lock_got_not:
    ret

;------------------------------------------------------------------------------
; void lockGive(uint8_t * mutex)
;
; mutex − This is a pointer to a simple mutex semaphore

PUBLIC _lock_give, _lock_give_fastcall

_lock_give:
    pop af
    pop hl
    push hl
    push af

_lock_give_fastcall:
    ld (hl), $FE
    ret

;------------------------------------------------------------------------------
; start of common area 1 driver - system_time functions
;------------------------------------------------------------------------------

PUBLIC	asm_system_tick

EXTERN  __system_time_fraction, __system_time, _bios_stack_canary

asm_system_tick:
    push af
    push hl

    in0 a, (TCR)                ; to clear the PRT0 interrupt, read the TCR
    in0 a, (TMDR0L)             ; followed by the TMDR0

    ld hl, __system_time_fraction
    inc (hl)
    jr Z, system_tick_stack_check ; at 0 we're at 1 second count, interrupted 256 times

system_tick_exit:
    pop hl
    pop af
    ei                          ; interrupts were enabled, or we wouldn't have been here
    ret

system_tick_stack_check:
    ld hl, _bios_stack_canary   ; check that the bios stack has not collided with code
    ld a, (hl)                  ; grab first byte $AA
    rrca                        ; rotate it to $55
    inc hl                      ; point to second byte $55
    xor (hl)                    ; if correct, zero result
    jr Z, system_tick_update    ; so continue as normal
    rst 8                       ; Okay, Houston, we've had a problem!
    defb $40                    ; Stack Error Code 0x40 '@'

system_tick_update:
    ld hl, __system_time
    inc (hl)
    jr NZ, system_tick_exit
    inc hl
    inc (hl)
    jr NZ, system_tick_exit
    inc hl
    inc (hl)
    jr NZ, system_tick_exit
    inc hl
    inc (hl)
    jr system_tick_exit

;------------------------------------------------------------------------------
; start of common area 1 driver - am9511a functions
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Interrupt Service Routine for the Am9511A-1
; 
; Initially called once the required operand pointers and commands are loaded.
;
; Following calls generated by END signal whenever a single APU command is completed.
; Sends a new command (with operands if needed) to the APU.
;
; On interrupt exit APUStatus contains either
; __IO_APU_STATUS_BUSY = 1, and rest of APUStatus bits are invalid
; __IO_APU_STATUS_BUSY = 0, idle, and the status bits resulting from the final COMMAND


PUBLIC _apu_init, asm_am9511a_isr

EXTERN APUCMDOutPtr, APUDataEntOutPtr, APUDataRemInPtr
EXTERN APUCMDBufUsed, APUDataEntBufUsed, APUDataRemBufUsed
EXTERN APUStatus, APUError

_apu_init:
asm_am9511a_isr:
    push af                 ; store AF, etc, so we don't clobber them
    push bc
    push hl

    xor a                   ; set internal clock = crystal x 1 = 18.432MHz
                            ; that makes the PHI 9.216MHz
    out0 (CMR), a           ; CPU Clock Multiplier Reg (CMR)
                            ; Am9511A-1 needs TWCS 30ns. This provides 41.7ns.

am9511a_isr_entry:
    ld a, (APUCMDBufUsed)   ; check whether we have a command to do
    or a                    ; zero?
    jr Z, am9511a_isr_end   ; if so then clean up and END

    ld hl, APUStatus        ; set APUStatus to busy
    ld (hl), __IO_APU_STATUS_BUSY

    ld bc, __IO_APU_STATUS  ; the address of the APU status port in BC
    in a, (c)               ; read the APU
    and __IO_APU_STATUS_ERROR   ; any errors?
    call NZ, am9511a_isr_error  ; then capture the error in APUError

    ld hl, (APUCMDOutPtr)   ; get the pointer to place where we pop the COMMAND
    ld a, (hl)              ; get the COMMAND byte
    push af                 ; save the COMMAND 

    inc l                   ; move the COMMAND pointer low byte along, 0xFF rollover
    ld (APUCMDOutPtr), hl   ; write where the next byte should be popped

    ld hl, APUCMDBufUsed
    dec (hl)                ; atomically decrement COMMAND count remaining

    and $F0                 ; mask only most significant nibble of COMMAND
    cp __IO_APU_OP_ENT      ; check whether it is OPERAND entry COMMAND
    jr Z, am9511a_isr_op_ent    ; load an OPERAND

    cp __IO_APU_OP_REM      ; check whether it is OPERAND removal COMMAND
    jr Z, am9511a_isr_op_rem    ; remove an OPERAND

    pop af                  ; recover the COMMAND 
    ld bc, __IO_APU_CONTROL ; the address of the APU control port in BC
    out (c), a              ; load the COMMAND, and do it

am9511a_isr_exit:
    ld a, CMR_X2            ; set internal clock = crystal x 2 = 36.864MHz
    out0 (CMR), a           ; CPU Clock Multiplier Reg (CMR)

    pop hl                  ; recover HL, etc
    pop bc
    pop af

    ei                      ; interrupts were enabled, or we wouldn't have been here
    ret                     ; no Z80 interrupt chaining

am9511a_isr_end:            ; we've finished a COMMAND sentence
    ld bc, __IO_APU_STATUS  ; the address of the APU status port in BC
    in a, (c)               ; read the APU
    tst __IO_APU_STATUS_BUSY    ; test the STATUS byte is valid (i.e. we're not busy)
    jr NZ, am9511a_isr_end
    ld (APUStatus), a       ; update status byte
    jr am9511a_isr_exit     ; we're done here

am9511a_isr_op_ent:
    ld bc, __IO_APU_DATA    ; the address of the APU data port in BC
    call am9511a_isr_op16_ent

    pop af                  ; recover the COMMAND 
    cp __IO_APU_OP_ENT16    ; is it a 2 byte OPERAND
    jr Z, am9511a_isr_entry ; yes? then go back to get another COMMAND

    call am9511a_isr_op16_ent
    jr am9511a_isr_entry    ; go back to get another COMMAND

am9511a_isr_op_rem:         ; REMINDER operands removed BIG ENDIAN !!!
    ld bc, __IO_APU_DATA   ; the address of the APU data port in BC
    call am9511a_isr_op16_rem

    pop af                  ; recover the COMMAND 
    cp __IO_APU_OP_REM16    ; is it a 2 byte OPERAND
    jr Z, am9511a_isr_entry ; yes then skip over 32bit stuff, and get another COMMAND

    call am9511a_isr_op16_rem
    jr am9511a_isr_entry    ; go back to get another COMMAND

am9511a_isr_op16_ent:
    ld hl, (APUDataEntOutPtr)  ; get the pointer to where we pop OPERAND

    ld a, (hl)              ; read the OPERAND low byte from the APUDataEntOutPtr
    out (c), a              ; write to APU
    inc l                   ; move the interleaved POINTER low byte along, 0xFF rollover
    inc l

    ex (sp), hl             ; delay for 38 cycles (5us) TWI @1.152MHz 3.472us
    ex (sp), hl

    ld a, (hl)              ; read the OPERAND high byte from the APUDataEntOutPtr
    out (c), a              ; write to APU
    inc l
    inc l
    ld (APUDataEntOutPtr), hl  ; write where the next OPERAND should be read

    ld hl, APUDataEntBufUsed   ; decrement of OPERAND byte count
    dec (hl)
    dec (hl)

    ex (sp), hl             ; delay for 38 cycles (5us) TWI @1.152MHz 3.472us
    ex (sp), hl
    ret

am9511a_isr_op16_rem:
    ld hl, (APUDataRemInPtr)   ; get the pointer to where we write OPERAND

    in a, (c)
    ld (hl), a              ; write the OPERAND high byte
    inc l                   ; move the POINTER low byte along, 0xFF rollover
    inc l

    in a, (c)
    ld (hl), a              ; write the OPERAND low byte
    inc l                   ; move the POINTER low byte along, 0xFF rollover
    inc l

    ld (APUDataRemInPtr), hl    ; write where the next POINTER should be read

    ld hl, APUDataRemBufUsed    ; increment of OPERAND byte count 
    inc (hl)
    inc (hl)
    ret

am9511a_isr_error:          ; we've an error to notify in A
    ld hl, APUError         ; collect any previous errors
    or (hl)                 ; and we add any new error types
    ld (hl), a              ; set the APUError status
    ret

;------------------------------------------------------------------------------  
;       Initialises the APU buffers
;

PUBLIC _apu_reset

EXTERN APUCMDBuf, APUDataBuf
EXTERN APUCMDInPtr, APUCMDOutPtr
EXTERN APUDataEntInPtr, APUDataEntOutPtr
EXTERN APUDataRemInPtr, APUDataRemOutPtr
EXTERN APUCMDBufUsed, APUDataEntBufUsed, APUDataRemBufUsed
EXTERN APUStatus, APUError, _APULock

_apu_reset:
    push af
    push bc
    push de
    push hl

    ld  HL, APUCMDBuf       ; Initialise COMMAND Buffer
    ld (APUCMDInPtr), HL
    ld (APUCMDOutPtr), HL

    ld HL, APUDataBuf       ; Initialise OPERAND Load Buffer, point to even bytes
    ld (APUDataEntInPtr), HL
    ld (APUDataEntOutPtr), HL

    ld HL, APUDataBuf+1     ; Initialise OPERAND Removal Buffer, point to odd bytes
    ld (APUDataRemInPtr), HL
    ld (APUDataRemOutPtr), HL

    xor A                   ; clear A register to 0

    ld (APUCMDBufUsed), A   ; 0 all Buffer counts
    ld (APUDataEntBufUsed), A
    ld (APUDataRemBufUsed), A

    ld (APUCMDBuf), A       ; clear COMMAND Buffer
    ld HL, APUCMDBuf
    ld D, H
    ld E, L
    inc DE
    ld BC, __APU_CMD_SIZE-1
    ldir

    ld (APUDataBuf), A      ; clear both (interleaved) OPERAND Buffers
    ld HL, APUDataBuf
    ld D, H
    ld E, L
    inc DE
    ld BC, __APU_DATA_SIZE-1
    ldir

    ld (APUStatus), a       ; set APU status to idle (NOP)
    ld (APUError), a        ; clear APU errors
   
am9511a_reset_loop:
    ld bc, __IO_APU_STATUS  ; the address of the APU status port in bc
    in a, (c)                   ; read the APU
    and __IO_APU_STATUS_BUSY    ; busy?
    jr NZ, am9511a_reset_loop

    in0 a,(ITC)
    or a, ITC_ITE0          ; enable INT0 for APU
    out0 (ITC),a

    ld hl, _APULock         ; load the mutex lock address
    ld (hl), $FE            ; give mutex lock

    pop hl
    pop de
    pop bc
    pop af
    ret

;------------------------------------------------------------------------------
;       Confirms whether the APU is idle.
;       Loop until it returns ready.
;       Operand Entry and Removal takes little time,
;       and we'll be interrupted for Command entry.
;       Use after the first _apu_init call.
;
;       L = contents of (APUStatus || APUError)
;       SCF if no errors (aggregation of any errors found)
;
;       APUError is zeroed on return
;       Uses AF, HL

PUBLIC _apu_chk_idle_fastcall

EXTERN APUStatus, APUError

_apu_chk_idle_fastcall:
    ld a, (APUStatus)       ; get the status of the APU (but don't disturb APU)
    tst __IO_APU_STATUS_BUSY; check busy bit is set,
    jr NZ, _apu_chk_idle_fastcall ; so we wait

    ld hl, APUError
    or (hl)                 ; collect the aggregated errors, with APUStatus
    tst __IO_APU_STATUS_ERROR   ; any errors?
    ld (hl), 0              ; clear any aggregated errors in APUError
    ld h, 0
    ld l, a
    ret nz                  ; return with no carry if errors
    scf                     ; set carry flag
    ret                     ; return with (APUStatus || APUError) with carry set if no errors

;------------------------------------------------------------------------------
;       APU_CMD_LD
;
;       DEHL = OPERAND, IF REQUIRED
;       A = APU COMMAND
;
;       BC = USED

PUBLIC _apu_cmd_ld_callee, asm_am9511a_cmd_ld

EXTERN APUCMDInPtr, APUDataEntInPtr
EXTERN APUCMDBufUsed, APUDataEntBufUsed
EXTERN _APULock

_apu_cmd_ld_callee:
    pop bc
    pop hl
    pop de
    dec sp
    pop af
    push bc

asm_am9511a_cmd_ld:
    ex de, hl               ; put low word in DE
    ld b, h                 ; store high word in BC so we don't clobber it
    ld c, l

    ld l, a                 ; store COMMAND so we don't clobber it

    ld a, (APUCMDBufUsed)   ; Get the number of bytes in the COMMAND buffer
    cp __APU_CMD_SIZE-1     ; check whether there is space in the buffer
    ret NC                  ; COMMAND buffer full, so exit

    ld a, (APUDataEntBufUsed)   ; Get the number of bytes in the OPERAND entry buffer
    cp +(__APU_DATA_SIZE/2)-4   ; check whether there is space for an OPERAND
    ret NC                  ; OPERAND Load buffer full, so exit

    ld a, l                 ; recover the COMMAND
    ld hl, (APUCMDInPtr)    ; get the pointer to where we poke
    ld (hl), a              ; write the COMMAND byte to the APUCMDInPtr   

    inc l                   ; move the COMMAND pointer low byte along, 0xFF rollover
    ld (APUCMDInPtr), hl    ; write where the next byte should be poked

    ld hl, APUCMDBufUsed
    inc (hl)                ; atomic increment of COMMAND count

    cp __IO_APU_OP_ENT16    ; is it a 2 byte OPERAND entry
    jr Z, am9511a_op_ent16  ; load an OPERAND

    cp __IO_APU_OP_ENT32    ; check whether COMMAND is 4 byte OPERAND entry 
    jr Z, am9511a_op_ent32  ; load an OPERAND

    ret                     ; just complete, and exit

am9511a_op_ent32:
    call am9511a_op_ent16   ; load the low word

    ld d, b                 ; get the high word
    ld e, c

am9511a_op_ent16:           ; load the high (or low) word
    ld hl, (APUDataEntInPtr)   ; get the pointer to where we poke
    ld (hl), e              ; write the low byte of OPERAND to the APUDataEntInPtr   
    inc l                   ; move the POINTER low byte along, 0xFF rollover
    inc l
    ld (hl), d              ; write the high byte of OPERAND to the APUDataEntInPtr   
    inc l
    inc l
    ld (APUDataEntInPtr), hl   ; write where the next DATA should be poked

    ld hl, APUDataEntBufUsed
    inc (hl)                ; increment of OPERAND byte count
    inc (hl)
    ret

;------------------------------------------------------------------------------
;       APU_OP_REM
;
;       HL = OPERAND POINTER
;
;       returns number of bytes recovered in L
;       seeks to recover ALL bytes in the buffer to operand pointer
;
;       uses AF, BC, DE


PUBLIC _apu_op_rem_callee, asm_am9511a_op_rem  

EXTERN APUDataRemOutPtr
EXTERN APUDataRemBufUsed
EXTERN _APULock

_apu_op_rem_callee:
    pop af
    pop hl
    push af

asm_am9511a_op_rem:
    ld d, h                 ; store destination pointer in DE
    ld e, l

    ld a, (APUDataRemBufUsed)   ; Get the number of bytes in the OPERAND entry buffer
    or a
    jr Z, am9511a_op_rem_exit ; OPERAND buffer empty, so exit

    ld c, a                 ; store OPERAND bytes count in C
    dec a                   ; create index, rather than count
    ld b, a                 ; store unload interations in B

    ld hl, (APUDataRemOutPtr)   ; get the pointer to where we pop OPERANDS (BIG ENDED)
    add a                   ; create interleaved (doubled) reverse index
    add a, l
    ld l, a                 ; point to LSB BIG ENDED

    push hl                 ; save last location for later

am9511a_op_rem:
    ld a, (hl)              ; read LSB of OPERAND
    ld (de), a              ; store it at our destination
    dec l                   ; move the OPERAND POINTER low byte along, 0xFF rollover
    dec l
    inc de
    djnz am9511a_op_rem     ; repeat for number of bytes to unload

    pop hl
    inc l
    inc l
    ld (APUDataRemOutPtr), hl  ; write the pointer to where we next pop OPERANDS (BIG ENDED)

    xor a                   ; set buffer fullness to zero
    ld  (APUDataRemBufUsed), a

    ld a, c                 ; store total bytes recovered in A

am9511a_op_rem_exit:
    ld h, 0
    ld l, a                 ; exit with total bytes recovered in L (and A)
    ret

;------------------------------------------------------------------------------
; start of common area 1 driver - asci0 functions
;------------------------------------------------------------------------------

PUBLIC _asci0_interrupt

EXTERN asci0RxCount, asci0RxIn
EXTERN asci0TxCount, asci0TxOut

_asci0_interrupt:
    push af
    push hl
                                ; start doing the Rx stuff
    in0 a, (STAT0)              ; load the ASCI0 status register
    tst STAT0_RDRF              ; test whether we have received on ASCI0
    jr Z, ASCI0_TX_CHECK        ; if not, go check for bytes to transmit

ASCI0_RX_GET:
    in0 l, (RDR0)               ; move Rx byte from the ASCI0 RDR to l

    and STAT0_OVRN|STAT0_PE|STAT0_FE ; test whether we have error on ASCI0
    jr NZ, ASCI0_RX_ERROR       ; drop this byte, clear error, and get the next byte

    ld a, (asci0RxCount)        ; get the number of bytes in the Rx buffer
    cp __ASCI0_RX_SIZE-1        ; check whether there is space in the buffer
    jr NC, ASCI0_RX_CHECK       ; buffer full, check whether we need to drain H/W FIFO

    ld a, l                     ; get Rx byte from l
    ld hl, (asci0RxIn)          ; get the pointer to where we poke
    ld (hl), a                  ; write the Rx byte to the asci0RxIn target

    inc l                       ; move the Rx pointer low byte along, 0xFF rollover
    ld (asci0RxIn), hl          ; write where the next byte should be poked

    ld hl, asci0RxCount
    inc (hl)                    ; atomically increment Rx buffer count
    jr ASCI0_RX_CHECK           ; check for additional bytes

ASCI0_RX_ERROR:
    in0 a, (CNTLA0)             ; get the CNTRLA0 register
    and ~CNTLA0_EFR             ; to clear the error flag, EFR, to 0 
    out0 (CNTLA0), a            ; and write it back

ASCI0_RX_CHECK:                 ; Z8S180 has 4 byte Rx H/W FIFO
    in0 a, (STAT0)              ; load the ASCI0 status register
    tst STAT0_RDRF              ; test whether we have received on ASCI0
    jr NZ, ASCI0_RX_GET         ; if still more bytes in H/W FIFO, get them

ASCI0_TX_CHECK:                 ; now start doing the Tx stuff
    and STAT0_TDRE              ; test whether we can transmit on ASCI0
    jr Z, ASCI0_TX_END          ; if not, then end

    ld a, (asci0TxCount)        ; get the number of bytes in the Tx buffer
    or a                        ; check whether it is zero
    jr Z, ASCI0_TX_TIE0_CLEAR   ; if the count is zero, then disable the Tx Interrupt

    ld hl, (asci0TxOut)         ; get the pointer to place where we pop the Tx byte
    ld a, (hl)                  ; get the Tx byte
    out0 (TDR0), a              ; output the Tx byte to the ASCI0

    inc l                       ; move the Tx pointer low byte along, 0xFF rollover
    inc l
    ld (asci0TxOut), hl         ; write where the next byte should be popped

    ld hl, asci0TxCount
    dec (hl)                    ; atomically decrement current Tx count

    jr NZ, ASCI0_TX_END         ; if we've more Tx bytes to send, we're done for now

ASCI0_TX_TIE0_CLEAR:
    in0 a, (STAT0)              ; get the ASCI0 status register
    and ~STAT0_TIE              ; mask out (disable) the Tx Interrupt
    out0 (STAT0), a             ; set the ASCI0 status register

ASCI0_TX_END:
    pop hl
    pop af

    ei
    ret

PUBLIC _asci0_init

_asci0_init:
    ; initialise the ASCI0
                                ; load the default ASCI configuration
                                ; BAUD = 115200 8n1
                                ; receive enabled
                                ; transmit enabled
                                ; receive interrupt enabled
                                ; transmit interrupt disabled

    ld      a,CNTLA0_RE|CNTLA0_TE|CNTLA0_MODE_8N1
    out0    (CNTLA0),a          ; output to the ASCI0 control A reg

                                ; PHI / PS / SS / DR = BAUD Rate
                                ; PHI = 18.432MHz
                                ; BAUD = 115200 = 18432000 / 10 / 1 / 16 
                                ; PS 0, SS_DIV_1 0, DR 0
    xor     a                   ; BAUD = 115200
    out0    (CNTLB0),a          ; output to the ASCI0 control B reg

    ld      a,STAT0_RIE         ; receive interrupt enabled
    out0    (STAT0),a           ; output to the ASCI0 status reg

    ld hl, _asci0TxLock         ; load the mutex lock address
    ld (hl), $FE                ; give mutex lock
    ld hl, _asci0RxLock         ; load the mutex lock address
    ld (hl), $FE                ; give mutex lock

    ret

PUBLIC _asci0_flush_Rx_di

EXTERN asci0RxCount, asci0RxIn, asci0RxOut, asci0RxBuffer, _asci0RxLock

_asci0_flush_Rx_di:
    push af
    push hl

    di                          ; di
    call _asci0_flush_Rx
    ei                          ; ei

    pop hl
    pop af
    ret

_asci0_flush_Rx:
    xor a
    ld (asci0RxCount), a        ; reset the Rx counter (set 0)  		
    ld hl, asci0RxBuffer        ; load Rx buffer pointer home
    ld (asci0RxIn), hl
    ld (asci0RxOut), hl
    ret

PUBLIC _asci0_flush_Tx_di
;PUBLIC _asci0_flush_Tx

EXTERN asci0TxCount, asci0TxIn, asci0TxOut, asciTxBuffer, _asci0TxLock

_asci0_flush_Tx_di:
    push af
    push hl

    di                          ; di
    call _asci0_flush_Tx
    ei                          ; ei

    pop hl
    pop af
    ret

_asci0_flush_Tx:
    xor a
    ld (asci0TxCount), a        ; reset the Tx counter (set 0)
    ld hl, asciTxBuffer         ; load Tx buffer pointer home
    ld (asci0TxIn), hl
    ld (asci0TxOut), hl
    ret

PUBLIC _asci0_reset

_asci0_reset:
    ; interrupts should be disabled
    call _asci0_init
    call _asci0_flush_Rx
    call _asci0_flush_Tx
    ret

PUBLIC _asci0_getc

EXTERN asci0RxCount, asci0RxOut

_asci0_getc:

    ; exit     : l = char received (a = char received too)
    ;            carry reset if Rx buffer is empty
    ;
    ; modifies : af, l

    ld a, (asci0RxCount)        ; get the number of bytes in the Rx buffer
    or a                        ; see if there are zero bytes available
    ret Z                       ; if the count is zero, then return

    push hl

    ld hl, (asci0RxOut)         ; get the pointer to place where we pop the Rx byte
    ld a, (hl)                  ; get the Rx byte

    inc l                       ; move the Rx pointer low byte along, 0xFF rollover
    ld (asci0RxOut), hl         ; write where the next byte should be popped

    ld hl, asci0RxCount
    dec (hl)                    ; atomically decrement Rx count

    pop hl

    ld l, a                     ; put the byte in l
    scf                         ; indicate char received
    ret

PUBLIC _asci0_peekc

EXTERN asci0RxCount, asci0RxOut

_asci0_peekc:

    ld a, (asci0RxCount)        ; get the number of bytes in the Rx buffer
    ld l, a                     ; and put it in l
    or a                        ; see if there are zero bytes available
    ret Z                       ; if the count is zero, then return

    push hl

    ld hl, (asci0RxOut)         ; get the pointer to place where we pop the Rx byte
    ld a, (hl)                  ; get the Rx byte

    pop hl

    ld l, a                     ; and put it in l
    ret

PUBLIC _asci0_pollc

EXTERN asci0RxCount

_asci0_pollc:

    ; exit     : l = number of characters in Rx buffer
    ;            carry reset if Rx buffer is empty
    ;
    ; modifies : af, l

    ld a, (asci0RxCount)        ; load the Rx bytes in buffer
    ld l, a	                    ; load result

    or a                        ; check whether there are non-zero count
    ret Z                       ; return if zero count

    scf                         ; set carry to indicate char received
    ret

PUBLIC _asci0_putc

EXTERN asci0TxCount, asci0TxIn

_asci0_putc:

    ; enter    : l = char to output
    ; exit     : l = 1 if Tx buffer is full
    ;            carry reset
    ; modifies : af, hl

    ld a, (asci0TxCount)        ; get the number of bytes in the Tx buffer
    or a                        ; check whether the buffer is empty
    jr NZ, asci0_put_buffer_tx  ; buffer not empty, so abandon immediate Tx

    in0 a, (STAT0)              ; get the ASCI0 status register
    and STAT0_TDRE              ; test whether we can transmit on ASCI0
    jr Z, asci0_put_buffer_tx   ; if not, so abandon immediate Tx

    out0 (TDR0), l              ; output the Tx byte to the ASCI0

    ld l, 0                     ; indicate Tx buffer was not full
    ret                         ; and just complete

asci0_put_buffer_tx:
    ld a, (asci0TxCount)        ; Get the number of bytes in the Tx buffer
    cp __ASCI0_TX_SIZE-1        ; check whether there is space in the buffer
    ld a,l                      ; Tx byte

    ld l,1
    jr NC, asci0_clean_up_tx    ; buffer full, so drop the Tx byte and clean up

    ld hl, (asci0TxIn)          ; get the pointer to where we poke
    ld (hl), a                  ; write the Tx byte to the asci0TxIn

    inc l                       ; move the Tx pointer low byte along, 0xFF rollover
    inc l
    ld (asci0TxIn), hl          ; write where the next byte should be poked

    ld hl, asci0TxCount
    inc (hl)                    ; atomic increment of Tx count

    ld l, 0                     ; indicate Tx buffer was not full

asci0_clean_up_tx:
    in0 a, (STAT0)              ; load the ASCI0 status register
    and STAT0_TIE               ; test whether ASCI0 interrupt is set
    ret nz                      ; if so then just return

    di                          ; critical section begin

    in0 a, (STAT0)              ; get the ASCI status register again
    or STAT0_TIE                ; mask in (enable) the Tx Interrupt
    out0 (STAT0), a             ; set the ASCI status register

    ei                          ; critical section end
    ret


;------------------------------------------------------------------------------
; start of common area 1 driver - asci1 functions
;------------------------------------------------------------------------------

PUBLIC _asci1_interrupt

EXTERN asci1RxCount, asci1RxIn
EXTERN asci1TxCount, asci1TxOut

_asci1_interrupt:
    push af
    push hl
                                ; start doing the Rx stuff
    in0 a, (STAT1)              ; load the ASCI1 status register
    tst STAT1_RDRF              ; test whether we have received on ASCI1
    jr Z, ASCI1_TX_CHECK        ; if not, go check for bytes to transmit

ASCI1_RX_GET:
    in0 l, (RDR1)               ; move Rx byte from the ASCI1 RDR to l

    and STAT1_OVRN|STAT1_PE|STAT1_FE ; test whether we have error on ASCI1
    jr NZ, ASCI1_RX_ERROR       ; drop this byte, clear error, and get the next byte

    ld a, (asci1RxCount)        ; get the number of bytes in the Rx buffer
    cp __ASCI1_RX_SIZE-1        ; check whether there is space in the buffer
    jr NC, ASCI1_RX_CHECK       ; buffer full, check whether we need to drain H/W FIFO

    ld a, l                     ; get Rx byte from l
    ld hl, (asci1RxIn)          ; get the pointer to where we poke
    ld (hl), a                  ; write the Rx byte to the asci1RxIn target

    inc l                       ; move the Rx pointer low byte along, 0xFF rollover
    ld (asci1RxIn), hl          ; write where the next byte should be poked

    ld hl, asci1RxCount
    inc (hl)                    ; atomically increment Rx buffer count
    jr ASCI1_RX_CHECK           ; check for additional bytes

ASCI1_RX_ERROR:
    in0 a, (CNTLA1)             ; get the CNTRLA1 register
    and ~CNTLA1_EFR             ; to clear the error flag, EFR, to 0 
    out0 (CNTLA1), a            ; and write it back

ASCI1_RX_CHECK:                 ; Z8S180 has 4 byte Rx H/W FIFO
    in0 a, (STAT1)              ; load the ASCI1 status register
    tst STAT1_RDRF              ; test whether we have received on ASCI1
    jr NZ, ASCI1_RX_GET         ; if still more bytes in H/W FIFO, get them

ASCI1_TX_CHECK:                 ; now start doing the Tx stuff
    and STAT1_TDRE              ; test whether we can transmit on ASCI1
    jr Z, ASCI1_TX_END          ; if not, then end

    ld a, (asci1TxCount)        ; get the number of bytes in the Tx buffer
    or a                        ; check whether it is zero
    jr Z, ASCI1_TX_TIE1_CLEAR   ; if the count is zero, then disable the Tx Interrupt

    ld hl, (asci1TxOut)         ; get the pointer to place where we pop the Tx byte
    ld a, (hl)                  ; get the Tx byte
    out0 (TDR1), a              ; output the Tx byte to the ASCI1

    inc l                       ; move the Tx pointer low byte along, 0xFF rollover
    inc l
    ld (asci1TxOut), hl         ; write where the next byte should be popped

    ld hl, asci1TxCount
    dec (hl)                    ; atomically decrement current Tx count

    jr NZ, ASCI1_TX_END         ; if we've more Tx bytes to send, we're done for now

ASCI1_TX_TIE1_CLEAR:
    in0 a, (STAT1)              ; get the ASCI1 status register
    and ~STAT1_TIE              ; mask out (disable) the Tx Interrupt
    out0 (STAT1), a             ; set the ASCI1 status register

ASCI1_TX_END:
    pop hl
    pop af

    ei
    ret

PUBLIC _asci1_init

_asci1_init:
    ; initialise the ASCI1
                                ; load the default ASCI configuration
                                ; BAUD = 115200 8n1
                                ; receive enabled
                                ; transmit enabled
                                ; receive interrupt enabled
                                ; transmit interrupt disabled

    ld      a,CNTLA1_RE|CNTLA1_TE|CNTLA1_MODE_8N1
    out0    (CNTLA1),a          ; output to the ASCI1 control A reg

                                ; PHI / PS / SS / DR = BAUD Rate
                                ; PHI = 18.432MHz
                                ; BAUD = 115200 = 18432000 / 10 / 1 / 16 
                                ; PS 0, SS_DIV_1 0, DR 0
    xor     a                   ; BAUD = 115200
    out0    (CNTLB1),a          ; output to the ASCI1 control B reg

    ld      a,STAT1_RIE         ; receive interrupt enabled
    out0    (STAT1),a           ; output to the ASCI1 status reg

    ld hl, _asci1TxLock         ; load the mutex lock address
    ld (hl), $FE                ; give mutex lock
    ld hl, _asci1RxLock         ; load the mutex lock address
    ld (hl), $FE                ; give mutex lock

    ret

PUBLIC _asci1_flush_Rx_di

EXTERN asci1RxCount, asci1RxIn, asci1RxOut, asci1RxBuffer, _asci1RxLock

_asci1_flush_Rx_di:
    push af
    push hl

    di                          ; di
    call _asci1_flush_Rx
    ei                          ; ei

    pop hl
    pop af
    ret

_asci1_flush_Rx:
    xor a
    ld (asci1RxCount), a        ; reset the Rx counter (set 0)  		
    ld hl, asci1RxBuffer        ; load Rx buffer pointer home
    ld (asci1RxIn), hl
    ld (asci1RxOut), hl
    ret

PUBLIC _asci1_flush_Tx_di
;PUBLIC _asci1_flush_Tx

EXTERN asci1TxCount, asci1TxIn, asci1TxOut, asciTxBuffer, _asci1TxLock

_asci1_flush_Tx_di:
    push af
    push hl

    di                          ; di
    call _asci1_flush_Tx
    ei                          ; ei

    pop hl
    pop af
    ret

_asci1_flush_Tx:

    xor a
    ld (asci1TxCount), a        ; reset the Tx counter (set 0)
    ld hl, asciTxBuffer+1       ; load Tx buffer pointer home
    ld (asci1TxIn), hl
    ld (asci1TxOut), hl
    ret

PUBLIC _asci1_reset

_asci1_reset:
    ; interrupts should be disabled
    call _asci1_init
    call _asci1_flush_Rx
    call _asci1_flush_Tx
    ret

PUBLIC _asci1_getc

EXTERN asci1RxCount, asci1RxOut

_asci1_getc:

    ; exit     : l = char received (a = char received too)
    ;            carry reset if Rx buffer is empty
    ;
    ; modifies : af, l

    ld a, (asci1RxCount)        ; get the number of bytes in the Rx buffer
    or a                        ; see if there are zero bytes available
    ret Z                       ; if the count is zero, then return

    push hl

    ld hl, (asci1RxOut)         ; get the pointer to place where we pop the Rx byte
    ld a, (hl)                  ; get the Rx byte

    inc l                       ; move the Rx pointer low byte along, 0xFF rollover
    ld (asci1RxOut), hl         ; write where the next byte should be popped

    ld hl, asci1RxCount
    dec (hl)                    ; atomically decrement Rx count

    pop hl

    ld l, a                     ; put the byte in l
    scf                         ; indicate char received
    ret

PUBLIC _asci1_peekc

EXTERN asci1RxCount, asci1RxOut

_asci1_peekc:

    ld a, (asci1RxCount)        ; get the number of bytes in the Rx buffer
    ld l, a                     ; and put it in l
    or a                        ; see if there are zero bytes available
    ret Z                       ; if the count is zero, then return

    push hl

    ld hl, (asci1RxOut)         ; get the pointer to place where we pop the Rx byte
    ld a, (hl)                  ; get the Rx byte

    pop hl

    ld l, a                     ; and put it in l
    ret

PUBLIC _asci1_pollc

EXTERN asci1RxCount

_asci1_pollc:

    ; exit     : l = number of characters in Rx buffer
    ;            carry reset if Rx buffer is empty
    ;
    ; modifies : af, l

    ld a, (asci1RxCount)        ; load the Rx bytes in buffer
    ld l, a	                    ; load result

    or a                        ; check whether there are non-zero count
    ret Z                       ; return if zero count

    scf                         ; set carry to indicate char received
    ret

PUBLIC _asci1_putc

EXTERN asci1TxCount, asci1TxIn

_asci1_putc:

    ; enter    : l = char to output
    ; exit     : l = 1 if Tx buffer is full
    ;            carry reset
    ; modifies : af, hl

    ld a, (asci1TxCount)        ; get the number of bytes in the Tx buffer
    or a                        ; check whether the buffer is empty
    jr NZ, asci1_put_buffer_tx  ; buffer not empty, so abandon immediate Tx

    in0 a, (STAT1)              ; get the ASCI1 status register
    and STAT1_TDRE              ; test whether we can transmit on ASCI1
    jr Z, asci1_put_buffer_tx   ; if not, so abandon immediate Tx

    out0 (TDR1), l              ; output the Tx byte to the ASCI1

    ld l, 0                     ; indicate Tx buffer was not full
    ret                         ; and just complete

asci1_put_buffer_tx:
    ld a, (asci1TxCount)        ; Get the number of bytes in the Tx buffer
    cp __ASCI1_TX_SIZE-1        ; check whether there is space in the buffer
    ld a,l                      ; Tx byte

    ld l,1
    jr NC, asci1_clean_up_tx    ; buffer full, so drop the Tx byte and clean up

    ld hl, (asci1TxIn)          ; get the pointer to where we poke
    ld (hl), a                  ; write the Tx byte to the asci1TxIn

    inc l                       ; move the Tx pointer low byte along, 0xFF rollover
    inc l
    ld (asci1TxIn), hl          ; write where the next byte should be poked

    ld hl, asci1TxCount
    inc (hl)                    ; atomic increment of Tx count

    ld l, 0                     ; indicate Tx buffer was not full

asci1_clean_up_tx:
    in0 a, (STAT1)              ; load the ASCI1 status register
    and STAT1_TIE               ; test whether ASCI1 interrupt is set
    ret nz                      ; if so then just return

    di                          ; critical section begin

    in0 a, (STAT1)              ; get the ASCI status register again
    or STAT1_TIE                ; mask in (enable) the Tx Interrupt
    out0 (STAT1), a             ; set the ASCI status register

    ei                          ; critical section end
    ret

;------------------------------------------------------------------------------
; start of common area 1 driver - 8255 functions
;------------------------------------------------------------------------------

PUBLIC ide_read_byte,  ide_write_byte
PUBLIC ide_read_block, ide_write_block

    ;Do a read bus cycle to the drive, using the 8255.
    ;input A = ide register address
    ;output A = lower byte read from IDE drive

ide_read_byte:
    push bc
    push de
    ld d, a                 ;copy address to D
    ld bc, __IO_PIO_IDE_CTL
    out (c), a              ;drive address onto control lines
    or __IO_IDE_RD_LINE
    out (c), a              ;and assert read pin
    ld bc, __IO_PIO_IDE_LSB
    in e, (c)               ;read the lower byte
    ld bc, __IO_PIO_IDE_CTL
    out (c), d              ;deassert read pin
    xor a
    out (c), a              ;deassert all control pins
    ld a, e
    pop de
    pop bc
    ret

    ;Read a block of 512 bytes (one sector) from the drive
    ;16 bit data register and store it in memory at (HL++)
ide_read_block:
    push bc
    push de
    ld bc, __IO_PIO_IDE_CTL
    ld d, __IO_IDE_DATA
    out (c), d              ;drive address onto control lines
    ld e, $0                ;keep iterative count in e

IF (__IO_PIO_IDE_CTL = __IO_PIO_IDE_MSB+1) & (__IO_PIO_IDE_MSB = __IO_PIO_IDE_LSB+1)
ide_rdblk2:
    ld d, __IO_IDE_DATA|__IO_IDE_RD_LINE
    out (c), d              ;and assert read pin
    ld bc, __IO_PIO_IDE_LSB+$0200 ;drive lower lines with lsb, plus ini b offset
    ini                     ;read the lower byte (HL++)
    inc c                   ;drive upper lines with msb
    ini                     ;read the upper byte (HL++)
    inc c                   ;drive control port
    ld d, __IO_IDE_DATA
    out (c), d              ;deassert read pin
    dec e                   ;keep iterative count in e
    jr NZ, ide_rdblk2

ELSE
ide_rdblk2:
    ld d, __IO_IDE_DATA|__IO_IDE_RD_LINE
    out (c), d              ;and assert read pin
    ld bc, __IO_PIO_IDE_LSB ;drive lower lines with lsb
    ini                     ;read the lower byte (HL++)
    ld bc, __IO_PIO_IDE_MSB ;drive upper lines with msb
    ini                     ;read the upper byte (HL++)
    ld bc, __IO_PIO_IDE_CTL
    ld d, __IO_IDE_DATA
    out (c), d              ;deassert read pin
    dec e                   ;keep iterative count in e
    jr NZ, ide_rdblk2

ENDIF
;   ld bc, __IO_PIO_IDE_CTL ;remembering what's in bc
    ld d, $0
    out (c), d              ;deassert all control pins
    pop de
    pop bc
    ret

    ;Do a write bus cycle to the drive, via the 8255
    ;input A = ide register address
    ;input E = lsb to write to IDE drive
ide_write_byte:
    push bc
    push de
    ld d, a                 ;copy address to D
    ld bc, __IO_PIO_IDE_CONFIG
    ld a, __IO_PIO_IDE_WR
    out (c), a              ;config 8255 chip, write mode
    ld bc, __IO_PIO_IDE_CTL
    ld a, d
    out (c), a              ;drive address onto control lines
    or __IO_IDE_WR_LINE
    out (c), a              ;and assert write pin
    ld bc, __IO_PIO_IDE_LSB
    out (c), e              ;drive lower lines with lsb
    ld bc, __IO_PIO_IDE_CTL
    out (c), d              ;deassert write pin
    xor a
    out (c), a              ;deassert all control pins
    ld bc, __IO_PIO_IDE_CONFIG
    ld a, __IO_PIO_IDE_RD
    out (c), a              ;config 8255 chip, read mode
    pop de
    pop bc
    ret

    ;Write a block of 512 bytes (one sector) from (HL++) to
    ;the drive 16 bit data register
ide_write_block:
    push bc
    push de
    ld bc, __IO_PIO_IDE_CONFIG
    ld d, __IO_PIO_IDE_WR
    out (c), d              ;config 8255 chip, write mode
    ld bc, __IO_PIO_IDE_CTL
    ld d, __IO_IDE_DATA
    out (c), d              ;drive address onto control lines
    ld e, $0                ;keep iterative count in e

IF (__IO_PIO_IDE_CTL = __IO_PIO_IDE_MSB+1) & (__IO_PIO_IDE_MSB = __IO_PIO_IDE_LSB+1)
ide_wrblk2: 
    ld d, __IO_IDE_DATA|__IO_IDE_WR_LINE
    out (c), d              ;and assert write pin
    ld bc, __IO_PIO_IDE_LSB+$0200 ;drive lower lines with lsb, plus outi b offset
    outi                    ;write the lower byte (HL++)
    inc c                   ;drive upper lines with msb
    outi                    ;write the upper byte (HL++)
    inc c                   ;drive control port
    ld d, __IO_IDE_DATA
    out (c), d              ;deassert write pin
    dec e                   ;keep iterative count in e
    jr NZ, ide_wrblk2

ELSE
ide_wrblk2: 
    ld d, __IO_IDE_DATA|__IO_IDE_WR_LINE
    out (c), d              ;and assert write pin
    ld bc, __IO_PIO_IDE_LSB ;drive lower lines with lsb
    outi                    ;write the lower byte (HL++)
    ld bc, __IO_PIO_IDE_MSB ;drive upper lines with msb
    outi                    ;write the upper byte (HL++)
    ld bc, __IO_PIO_IDE_CTL
    ld d, __IO_IDE_DATA
    out (c), d              ;deassert write pin
    dec e                   ;keep iterative count in e
    jr NZ, ide_wrblk2

ENDIF
;   ld bc, __IO_PIO_IDE_CTL ;remembering what's in bc
    ld d, $0
    out (c), d              ;deassert all control pins
    ld bc, __IO_PIO_IDE_CONFIG
    ld d, __IO_PIO_IDE_RD
    out (c), d              ;config 8255 chip, read mode
    pop de
    pop bc
    ret

;------------------------------------------------------------------------------
; start of common area 1 driver - IDE functions
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; IDE internal subroutines 
;
; These routines talk to the drive, using the low level I/O.
; Normally a program should not call these directly.
;------------------------------------------------------------------------------

EXTERN ideStatus

PUBLIC ide_setup_lba
PUBLIC ide_wait_ready, ide_wait_drq, ide_test_error

; set up the drive LBA registers
; LBA is contained in BCDE registers

ide_setup_lba:
    push hl
    ld a, __IO_IDE_LBA0
    call ide_write_byte     ;set LBA0 0:7
    ld e, d
    ld a, __IO_IDE_LBA1
    call ide_write_byte     ;set LBA1 8:15
    ld e, c
    ld a, __IO_IDE_LBA2
    call ide_write_byte     ;set LBA2 16:23
    ld a, b
    and 00001111b           ;lowest 4 bits used only
    or  11100000b           ;to enable LBA address mode
    ld hl, ideStatus        ;set bit 4 accordingly
    bit 0, (hl)
    jr Z, ide_setup_master
    or $10                  ;if it is a slave, set that bit
ide_setup_master:
    ld e, a
    ld a, __IO_IDE_LBA3
    call ide_write_byte     ;set LBA3 24:27 + bits 5:7=111
    pop hl
    ret

; How to poll (waiting for the drive to be ready to transfer data):
; Read the Regular Status port until bit 7 (BSY, value = 0x80) clears,
; and bit 3 (DRQ, value = 0x08) sets.
; Or until bit 0 (ERR, value = 0x01) or bit 5 (DFE, value = 0x20) sets.
; If neither error bit is set, the device is ready right then.

; Carry is set on wait success.

ide_wait_ready:
    push af
ide_wait_ready2:
    ld a, __IO_IDE_ALT_STATUS    ;get IDE alt status register
    call ide_read_byte
    tst 00100001b           ;test for ERR or DFE
    jr NZ, ide_wait_error
    and 11000000b           ;mask off BuSY and RDY bits
    xor 01000000b           ;wait for RDY to be set and BuSY to be clear
    jr NZ, ide_wait_ready2
    pop af
    scf                     ;set carry flag on success
    ret

ide_wait_error:
    pop af
    or a                    ;clear carry flag on failure
    ret

; Wait for the drive to be ready to transfer data.
; Returns the drive's status in A

; Carry is set on wait success.

ide_wait_drq:
    push af
ide_wait_drq2:
    ld a, __IO_IDE_ALT_STATUS    ;get IDE alt status register
    call ide_read_byte
    tst 00100001b           ;test for ERR or DFE
    jr NZ, ide_wait_error
    and 10001000b           ;mask off BuSY and DRQ bits
    xor 00001000b           ;wait for DRQ to be set and BuSY to be clear
    jr NZ, ide_wait_drq2
    pop af
    scf                     ;set carry flag on success
    ret


; load the IDE status register and if there is an error noted,
; then load the IDE error register to provide details.

; Carry is set on no error.

ide_test_error:
    push af
    ld a, __IO_IDE_ALT_STATUS    ;select status register
    call ide_read_byte      ;get status in A
    bit 0, a                ;test ERR bit
    jr Z, ide_test_success
    bit 5, a
    jr NZ, ide_test2        ;test write error bit

    ld a, __IO_IDE_ERROR    ;select error register
    call ide_read_byte      ;get error register in a
ide_test2:
    inc sp                  ;pop old af
    inc sp
    or a                    ;make carry flag zero = error!
    ret                     ;if a = 0, ide write busy timed out

ide_test_success:
    pop af
    scf                     ;set carry flag on success
    ret

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should not be called by
; the main program.

; read a sector
; LBA specified by the 4 bytes in BCDE
; the address of the buffer to fill is in HL
; HL is left incremented by 512 bytes

; return carry on success, no carry for an error

PUBLIC ide_read_sector

ide_read_sector:
    push af
    push bc
    push de
    call ide_wait_ready     ;make sure drive is ready
    jr NC, _disk_x_sector_error
    call ide_setup_lba      ;tell it which sector we want in BCDE
    ld e, $1
    ld a, __IO_IDE_SEC_CNT
    call ide_write_byte     ;set sector count to 1
    ld e, __IDE_CMD_READ
    ld a, __IO_IDE_COMMAND
    call ide_write_byte     ;ask the drive to read it
    call ide_wait_ready     ;make sure drive is ready to proceed
    jr NC, _disk_x_sector_error
    call ide_wait_drq       ;wait until it's got the data
    jr NC, _disk_x_sector_error
    call ide_read_block     ;grab the data into (HL++)

_ide_x_sector_ok:
    pop de
    pop bc
    pop af
    scf                     ;carry = 1 on return = operation ok
    ret

_disk_x_sector_error:
    pop de
    pop bc
    pop af
    jr ide_test_error       ;carry = 0 on return = operation failed


;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should not be called by
; the main program.

; write a sector
; specified by the 4 bytes in BCDE
; the address of the origin buffer is in HL
; HL is left incremented by 512 bytes

; return carry on success, no carry for an error

PUBLIC ide_write_sector

ide_write_sector:
    push af
    push bc
    push de
    call ide_wait_ready     ;make sure drive is ready
    jr NC, _disk_x_sector_error
    call ide_setup_lba      ;tell it which sector we want in BCDE
    ld e, $1
    ld a, __IO_IDE_SEC_CNT
    call ide_write_byte     ;set sector count to 1
    ld e, __IDE_CMD_WRITE
    ld a, __IO_IDE_COMMAND
    call ide_write_byte     ;instruct drive to write a sector
    call ide_wait_ready     ;make sure drive is ready to proceed
    jr NC, _disk_x_sector_error
    call ide_wait_drq       ;wait until it wants the data
    jr NC, _disk_x_sector_error
    call ide_write_block    ;send the data to the drive from (HL++)
    call ide_wait_ready
    jr NC, _disk_x_sector_error
;   ld e, __IDE_CMD_CACHE_FLUSH
;   ld a, __IO_IDE_COMMAND
;   call ide_write_byte     ;tell drive to flush its hardware cache
;   call ide_wait_ready     ;wait until the write is complete
;   jr NC, _disk_x_sector_error
    jr _ide_x_sector_ok     ;carry = 1 on return = operation ok

;==============================================================================
;       DEBUGGING SUBROUTINES
;

PUBLIC rhex, rchar
PUBLIC phexwd, phex, pchar
PUBLIC pstring, pnewline

EXTERN _bios_ioByte

EXTERN _asci0_putc, _asci0_getc
EXTERN _asci1_putc, _asci1_getc
 
;==============================================================================
;       OUTPUT SUBROUTINES
;

    ; print string from location in DE to asci0/1, modifies AF, DE, & HL
pstring: 
    ld a, (de)          ; Get character from DE address
    or a                ; Is it $00 ?
    ret Z               ; Then return on terminator
    ld l, a
    call pchar          ; Print it
    inc de              ; Point to next character 
    jr pstring          ; Continue until $00

    ; print CR/LF to asci0/1,, modifies AF & HL
pnewline:
    ld l, CHAR_CR
    call pchar
    ld l, CHAR_LF
    jr pchar

    ; print contents of HL as 16 bit number in ASCII HEX, modifies AF & HL
phexwd:
    push hl
    ld l, h         ; high byte to L
    call phex
    pop hl          ; recover HL, for low byte in L  
    call phex
    ret

    ; print contents of L as 8 bit number in ASCII HEX to asci0/1, modifies AF & HL
phex:
    ld a, l         ; _asci0_putc / _asci1_putc modifies AF, HL
    push af
    rrca
    rrca
    rrca
    rrca
    call  phex_conv
    pop af
phex_conv:
    and  $0F
    add  a,$90
    daa
    adc  a,$40
    daa
    ld l, a

    ; print contents of L to asci0/1, modifies AF & HL
pchar:
    ld a, (_bios_ioByte); get I/O bit
    rrca                ; put it in Carry
    jp NC, _asci1_putc  ; TTY=0 (asci1)
    jp _asci0_putc      ; CRT=1 (asci0)

;==============================================================================
;       INPUT SUBROUTINES
;

rhex:                   ; Returns byte in A, modifies HL
    call rhex_nibble    ; read the first nibble
    rlca                ; shift it left by 4 bits
    rlca
    rlca
    rlca
    ld h, a             ; temporarily store the first nibble in H
    call rhex_nibble    ; get the second (low) nibble
    or h                ; assemble two nibbles into one byte in A
    ret                 ; return the byte read in A  

rhex_nibble:
    call rchar          ; Rx byte in L (A = byte Rx too) SCF if char read
    jr NC, rhex_nibble  ; keep trying if no characters
    sub '0'
    cp 10
    ret C               ; if A<10 just return
    sub 7               ; else subtract 'A'-'0' (17) and add 10
    ret

rchar:                  ; Rx byte in L (A = byte Rx too) SCF if char read
    ld a, (_bios_ioByte); get I/O bit
    rrca                ; put it in Carry
    jp NC, _asci1_getc  ; TTY=0 (asci1)
    jp _asci0_getc      ; CRT=1 (asci0)

;==============================================================================
;       BIOS STACK CANARY
;

PUBLIC _bios_stack_canary

_bios_stack_canary:
    defb $AA
    defb $55

PUBLIC _common1_phase_end
_common1_phase_end:     ; just to make sure there's enough space

DEPHASE

