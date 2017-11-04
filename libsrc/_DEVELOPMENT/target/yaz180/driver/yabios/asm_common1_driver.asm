
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
    pop de              ; pop originating address
    call phexwdreg      ; and output it on serial port
error_handler_loop:
    call delay
    jr error_handler_loop

;------------------------------------------------------------------------------

PUBLIC _far_call_rst

_far_call_rst:          ; RST 10
    push hl
    ld hl, _shadowLock
far_call_try_alt_lock:
    sra (hl)            ; get alt register mutex
    jr C, far_call_try_alt_lock ; just keep trying
    pop hl

    ex af,af            ; all your register are belong to us
    exx

    pop hl              ; get the return PC address
    ld e, (hl)          ; get called address in DE
    inc hl
    ld d, (hl)
    inc hl
    ld c, (hl)          ; get called bank in C
    inc hl
    push hl             ; push the post far_call ret address back on stack

    in0 a, (BBR)        ; get the origin bank
    ld b, a             ; save origin BBR in B    
    rrca                ; move the origin bank to low nibble
    rrca                ; we know BBR lower nibble is 0
    rrca
    rrca
    add a, c            ; create destination far address, from twos complement relative input
    and a, $0F          ; convert it to 4 bit address (not implicit here)

    ld hl, _bankLockBase; get the BANK Lock base address, page aligned
    ld l, a             ; make the reference into BANKnn Lock

    rrca                ; move the origin bank to high nibble
    rrca                ; we know BBR lower nibble is 0
    rrca
    rrca
    ld c, a             ; hold destination BBR in C

    xor a
    and (hl)            ; check bank is not cold
    jr Z, far_call_exit
    sra (hl)            ; now get the bank lock,
    jr C, far_call_exit ; or exit if the bank is hot
    
                        ; OK we're going somewhere nice and warm,
                        ; now make the bank switch
    di
    ld (_bank_sp), sp   ; save the origin bank SP in Page0
    out0 (BBR), c       ; make the bank swap
    ld sp, (_bank_sp)   ; set up the new SP in new Page0
    ei
                        ; now prepare for our return
    push bc             ; push on the origin and destination bank
    
    ld hl, far_ret
    push hl             ; push far_ret function return address
    push de             ; push our destination address
    
far_call_exit:
    exx
    ex af,af            ; alt register are returned

    push hl
    ld hl, _shadowLock  ; give alt register mutex
    ld (hl), $FE
    pop hl
    ret                 ; takes us out if there's error, or call onwards if success


far_ret:                ; we land back here once the far_call function returns
    push hl
    ld hl, _shadowLock
far_ret_try_alt_lock:
    sra (hl)            ; get alt register mutex
    jr C, far_ret_try_alt_lock ; just keep trying, can't give up
    pop hl

    exx

    pop bc              ; get return (origin) BBR in B, and departing (destination) BBR in C

                        ; we left our origin bank lock unchanged, so it is still locked
    di                        
    ld (_bank_sp), sp   ; save the departing bank SP in Page0
    out0 (BBR), b       ; make the bank swap
    ld sp, (_bank_sp)   ; set up the originating SP in old Page0
    ei

    ld hl, _bankLockBase; get the BANK Lock Base, page aligned
    ld a, c             ; make the reference to destination BANKnn Lock
    rrca                ; move the origin bank to low nibble
    rrca                ; we know BBR lower nibble is 0
    rrca
    rrca
    ld l, a
    ld (hl), $FE        ; free the bank we are now departing

    exx                 ; alt registers are returned

    push hl
    ld hl, _shadowLock  ; give alt register mutex
    ld (hl), $FE
    pop hl
    ret


;------------------------------------------------------------------------------
; void far_jp(far *str, int8_t bank)
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

PUBLIC _far_jp, _far_jp_rst

_far_jp:
    pop hl
    pop de
    push de
    push hl

_far_jp_rst:            ; RST 18
    push de             ; save the jump destination from EHL    
    push hl
    
    ld hl, _shadowLock
far_jp_try_alt_lock:
    sra (hl)            ; get alt register mutex
    jr C, far_jp_try_alt_lock ; just keep trying

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

    ld hl, _bankLockBase; get the BANK Lock base address, page aligned
    ld l, a             ; make reference into BANKnn Lock

    rrca                ; move the origin bank to high nibble
    rrca                ; we know BBR lower nibble is 0
    rrca
    rrca
    ld c, a             ; hold destination BBR in C

    xor a
    and (hl)            ; check bank is not cold
    jr Z, far_jp_exit
far_jp_try_bank_lock:
    sra (hl)            ; now get the bank lock,
    jr C, far_jp_try_bank_lock  ; keep trying if the bank is hot, we can't go back
    
                        ; OK we're going somewhere nice and warm,
                        ; now make the bank switch
    di
    ld (_bank_sp), sp   ; save the origin bank SP in Page0
    out0 (BBR), c       ; make the bank swap
    ld sp, (_bank_sp)   ; set up the destination bank SP in new Page0
    ei

    push de             ; push our destination address for ret jp

    ld hl, _bankLockBase; get the BANK Lock Base, page aligned
    ld l, b             ; make reference to originating BANKnn Lock
    ld (hl), $FE        ; free the origin bank, we're not coming back

far_jp_exit:
    exx
    ex af,af            ; alt register are returned

    push hl
    ld hl, _shadowLock  ; give alt register mutex
    ld (hl), $FE
    pop hl
    ret                 ; takes us out if there's error, or jp onwards if success

;------------------------------------------------------------------------------

PUBLIC _system_rst

_system_rst:            ; RST 20
    push hl
    ld hl, _shadowLock

system_try_alt_lock:
    sra (hl)            ; get alt register mutex
    jr C, system_try_alt_lock ; just keep trying
    pop hl

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
    ret

;------------------------------------------------------------------------------

PUBLIC _am9511a_rst

_am9511a_rst:           ; RST 28
    ret

;------------------------------------------------------------------------------

PUBLIC _user_rst

_user_rst:              ; RST 30
    ret

;------------------------------------------------------------------------------
; start of common area 1 - system functions
;------------------------------------------------------------------------------

EXTERN _shadowLock, _dmac0Lock, _dmac1Lock, _prt0Lock, _prt1Lock

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
    jr C, memcpy_far_left_right   ; if destination is lower bank, we do left right
                        ; otherwise we need to check further

    xor a               ; clear A and Carry
    ex de, hl           ; now source in hl, destination in de
    sbc hl, de          ; check whether destination address < source address
    jr NC, memcpy_far_left_right  ; if so we can do left to right copy

memcpy_far_right_left:
    adc hl, de          ; recover the source address
    dec hl              ; subtract one from source address      
    pop bc              ; get the size of the copy back
    add hl, bc          ; add in the size to the source address
    jr NC, memcpy_far_right_left_src_bank_no_overflow
    in0 a, (SAR0B)
    inc a               ; if copy origin flows into following bank
    out0 (SAR0B), a
    
memcpy_far_right_left_src_bank_no_overflow:    
    ex de, hl           ; swap source to de
    dec hl              ; subtract one from destination address       
    add hl, bc          ; add in the size to the destination address
    jr NC, memcpy_far_right_left_dest_bank_no_overflow
    in0 a, (DAR0B)
    inc a               ; if copy originflows into following bank
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
    adc hl, de          ; recover the source address
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
; void *memset_far(void *str, int8_t bank, const int16_t c, size_t n)
;
; str  − This is a pointer to the block of memory to fill,
;       type-cast to a pointer of type void*.
; bank − This is the bank address, relative to the current bank.
; c    − This is the value to be set. The value is passed as an int, but the
;       function fills the block of memory using the unsigned char conversion.
; n    − This is the number of bytes to be set to the value c.
;
; This function returns a void* pointer to the memory area str in HL.

; stack:
;   n high
;   n low
;   c high
;   c low
;   bank far
;   str high
;   str low
;   ret high
;   ret low

PUBLIC _memset_far

_memset_far:
    ld hl, _dmac0Lock
    sra (hl)            ; take the DMAC0 lock
    jr C, _memset_far

    ld hl, 8
    add hl, sp          ; pointing at nh bytes
    ld d, (hl)          ; d = nh 
    dec hl   
    ld e, (hl)          ; e = nl

    ld a, d             ; test for zero size, and exit
    or a, e
    jr Z, memset_far_error_exit ; return on zero size

    out0 (BCR0H), d     ; set up the transfer size   
    out0 (BCR0L), e
    
    dec hl
    dec hl              ; pointing at c low byte
 
    out0 (SAR0H), h     ; c low byte is source, address in hl
    out0 (SAR0L), l
    
    dec hl              ; pointing at str far
    
    in0 a, (BBR)        ; get the current bank
    rrca                ; move the current bank to low nibble
    rrca
    rrca
    rrca                ; shift current bank to address format

    out0 (SAR0B), a     ; use the current bank for the origin

    add a, (hl)         ; create relative destination far address, from twos complement input
    and a, $0F          ; convert it to 4 bit positive address (think this is implicit)
    out0 (DAR0B), a     ; (DAR0B has only 4 bits)

    dec hl
    ld d, (hl)          ; get destination high address in d
    dec hl
    ld e, (hl)          ; get destination low address in e

    out0 (DAR0H), d
    out0 (DAR0L), e

    ld hl, +(DMODE_SM1|DMODE_MMOD)*$100+DSTAT_DE0
    out0 (DMODE), h     ; DMODE_MMOD - memory00 to memory++, burst mode
    out0 (DSTAT), l     ; DSTAT_DE0 - enable DMA channel 0, no interrupt
                        ; in burst mode the Z180 CPU stops until the DMA completes

    ex de, hl           ; and swap the destination address into hl, to return

memset_far_error_exit:
    ld a, $FE
    ld (_dmac0Lock), a  ; give DMAC0 free

    ret

;------------------------------------------------------------------------------
; far void *load_hex(uint8_t bankAbs)
;
; bankAbs − This is the absolute bank address (1 to 15), not BANK0.
;
; Type 2 Extended Segment Address (ESA), is equivalent to BBR data, and translates 1:1.
; Therefore BANK changes can be done by inputting the correct ESA data as 0xn000.

PUBLIC _load_hex, _load_hex_fastcall

EXTERN initString, invalidTypeStr, badCheckSumStr, LoadOKStr

_load_hex:
    pop hl
    push hl

_load_hex_fastcall:
    ld de, initString
    call pstring

    in0 c, (BBR)                ; grab and store the current Bank Base Register in C
    xor a    
    and c                       ; check it is BANK0, so the user can't use this (currently)
    ret NZ
    
    ld a, l                     ; get the destination BBR
    rrca                        ; move the origin bank to high nibble
    rrca                        ; we know BBR lower nibble is 0
    rrca
    rrca
    and a, $F0                  ; be sure it is sane
    ret Z                       ; and not trying to write to BANK0
    out0 (BBR), a               ; set the BBR
                                ; from BANK0, so no need for stack change (currently)

load_hex_wait_lock:
    ld hl, _asci0RxLock
    sra (hl)                    ; take the ASCI0 Rx lock
    jr C, load_hex_wait_lock

load_hex_wait_colon:
    call _asci0_getc            ; Rx byte (a = char received too)
    cp ':'                      ; wait for ':'
    jr NZ, load_hex_wait_colon
    ld hl, 0                    ; reset hl to compute checksum
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
;    ld l, '*'                   ; "*" per byte loaded  # DEBUG
;    call _asci0_putc            ; Print it             # DEBUG
    call load_hex_read_byte
    ld (de), a                  ; write the byte at the RAM address
    inc de
    djnz load_hex_read_data     ; if b non zero, loop to get more data
load_hex_read_chksum:
    call load_hex_read_byte     ; read checksum, but we don't need to keep it
    ld a, l                     ; lower byte of hl checksum should be 0
    or a
    jr NZ, load_hex_bad_chk     ; non zero, we have an issue
    ld l, '#'                   ; "#" per line loaded
    call _asci0_putc            ; Print it
;    ld l, CHAR_CR               ; CHAR_CR              # DEBUG
;    call _asci0_putc            ; Print it             # DEBUG
;    ld l, CHAR_LF               ; CHAR_LF              # DEBUG
;    call _asci0_putc            ; Print it             # DEBUG
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
    ld a, l                     ; lower byte of hl checksum should be 0
    or a
    jr NZ, load_hex_bad_chk     ; non zero, we have an issue
    out0 (BBR), c               ; get our originating BBR back, write it to the BBR
    ld de, LoadOKStr

load_hex_exit:
    call pstring
    call delay
    ld hl, _asci0RxLock         ; give up the ASCI0 Rx mutex
    ld (hl), $FE
    ret

load_hex_inval_type:
    out0 (BBR), c               ; get our originating BBR back, write it to the BBR
    ld de, invalidTypeStr
    jr load_hex_exit

load_hex_bad_chk:
    out0 (BBR), c               ; get our originating BBR back, write it to the BBR
    ld de, badCheckSumStr
    jr load_hex_exit

load_hex_read_byte:             ; Returns byte in a, checksum in hl
    push hl
    call _asci0_getc            ; Rx byte in l (a = char received too)
    sub '0'
    cp 10
    jr C, load_hex_read_nbl2    ; if a<10 read the second nibble
    sub 7                       ; else subtract 'A'-'0' (17) and add 10
load_hex_read_nbl2:
    rlca                        ; shift accumulator left by 4 bits
    rlca
    rlca
    rlca
    ld h, a                     ; temporarily store the first nibble in H
    call _asci0_getc            ; Rx byte in l (a = char received too)
    sub '0'
    cp 10
    jr C, load_hex_read_end     ; if a<10 finalize
    sub 7                       ; else subtract 'A' (17) and add 10
load_hex_read_end:
    or h                        ; assemble two nibbles into one byte in A
    pop hl    
    add a, l                    ; add the byte read to l (for checksum)
    ld l, a
    ret                         ; return the byte read in a        


;------------------------------------------------------------------------------
; int8_t bank_get_rel(uint8_t bankAbs)
;
; bankAbs − This is the absolute bank address
;
; Returns the relative bank address

PUBLIC _bank_get_rel, _bank_get_rel_fastcall

_bank_get_rel:
    pop hl
    push hl

_bank_get_rel_fastcall:
    push af
    
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

    pop af
    ret

;------------------------------------------------------------------------------
; uint8_t bank_get_abs(int8_t bankRel)
;
; bankRel − This is the relative bank address (-128 to +127)
;
; Returns the capped absolute bank address (0 to 15)

PUBLIC _bank_get_abs, _bank_get_abs_fastcall

_bank_get_abs:
    pop hl
    push hl

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
    pop hl
    push hl

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
    pop hl
    push hl

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
    pop hl
    push hl

_lock_give_fastcall:
    ld (hl), $FE
    ret



;------------------------------------------------------------------------------
; start of common area 1 driver - system_time functions
;------------------------------------------------------------------------------

PUBLIC	asm_system_tick

EXTERN  __system_time_fraction, __system_time

asm_system_tick:
    push af
    push hl

    in0 a, (TCR)                ; to clear the PRT0 interrupt, read the TCR
    in0 a, (TMDR0L)             ; followed by the TMDR0

    ld hl, __system_time_fraction
    inc (hl)
    jr Z, system_tick_update    ; at 0 we're at 1 second count, interrupted 256 times

system_tick_exit:
    pop hl
    pop af
    ei                          ; interrupts were enabled, or we wouldn't have been here
    ret

system_tick_update:
    ld hl, __system_time        ; inc hl would also work, provided the storage is contiguous
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

; Interrupt Service Routine for the Am9511A-1
; 
; Initially called once the required operand pointers and commands are loaded
; Following calls generated by END signal whenever a single APU command is completed
; Sends a new command (with operands if needed) to the APU
;
; On interrupt exit APUStatus contains either
; __IO_APU_STATUS_BUSY = 1, and rest of APUStatus bits are invalid
; __IO_APU_STATUS_BUSY = 0, idle, and the status bits resulting from the final COMMAND

; FIXME - conversion to yabios model not complete.
; the data pointer buffer becomes a data buffer.
; Some things are done, but not all.

PUBLIC asm_am9511a_isr

EXTERN APUCMDOutPtr, APUDATAOutPtr
EXTERN APUCMDBufUsed, APUDATABufUsed, APUStatus, APUError

asm_am9511a_isr:
    push af                 ; store AF, etc, so we don't clobber them
    push bc
    push de
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

    ld bc, __IO_APU_PORT_STATUS ; the address of the APU status port in BC
    in a, (c)               ; read the APU
    and __IO_APU_STATUS_ERROR   ; any errors?
    call NZ, am9511a_isr_error  ; then capture error in APUError

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
    ld bc, __IO_APU_PORT_CONTROL    ; the address of the APU control port in BC
    out (c), a              ; load the COMMAND, and do it

am9511a_isr_exit:
    ld a, CMR_X2            ; set internal clock = crystal x 2 = 36.864MHz
    out0 (CMR), a           ; CPU Clock Multiplier Reg (CMR)

    pop hl                  ; recover HL, etc
    pop de
    pop bc
    pop af
    ret

am9511a_isr_end:            ; we've finished a COMMAND sentence
    ld bc, __IO_APU_PORT_STATUS ; the address of the APU status port in BC
    in a, (c)               ; read the APU
    tst __IO_APU_STATUS_BUSY    ; test the STATUS byte is valid (i.e. we're not busy)
    jr NZ, am9511a_isr_end
    ld (APUStatus), a       ; update status byte
    jr am9511a_isr_exit     ; we're done here

am9511a_isr_op_ent:
    ld hl, (APUDATAOutPtr)  ; get the pointer to where we pop OPERAND
    ld e, (hl)              ; read the OPERAND PTR low byte from the APUDATAOutPtr
    inc l                   ; move the POINTER low byte along, 0xFF rollover
    ld d, (hl)              ; read the OPERAND PTR high byte from the APUDATAOutPtr
    inc l
    ld (APUDATAOutPtr), hl  ; write where the next POINTER should be read

    ld hl, APUDATABufUsed   ; decrement of POINTER count remaining
    dec (hl)
    dec (hl)

    ld bc, __IO_APU_PORT_DATA+$0300 ; the address of the APU data port (+3) in BC
    ex de, hl               ; move the base address of the OPERAND to HL

    outi                    ; output 16 bit OPERAND

    ex (sp), hl             ; delay for 38 cycles (5us) TWI @1.152MHz 3.472us
    ex (sp), hl
    outi

    pop af                  ; recover the COMMAND 
    cp __IO_APU_OP_ENT16    ; is it a 2 byte OPERAND
    jp Z, am9511a_isr_entry ; yes? then go back to get another COMMAND

    ex (sp), hl             ; delay for 38 cycles (5us) TWI 1.280us
    ex (sp), hl
    outi                    ; output last two bytes of 32 bit OPERAND

    ex (sp), hl             ; delay for 38 cycles (5us) TWI @1.152MHz 3.472us
    ex (sp), hl
    outi

    jp am9511a_isr_entry    ; go back to get another COMMAND

am9511a_isr_op_rem:
    ld hl, (APUDATAOutPtr)   ; get the pointer to where we pop OPERAND PTR
    ld e, (hl)              ; read the OPERAND PTR low byte from the APUDATAOutPtr
    inc l                   ; move the POINTER low byte along, 0xFF rollover
    ld d, (hl)              ; read the OPERAND PTR high byte from the APUDATAOutPtr
    inc l
    ld (APUDATAOutPtr), hl  ; write where the next POINTER should be read

    ld hl, APUDATABufUsed   ; decrement of OPERAND POINTER count remaining
    dec (hl)
    dec (hl)

    ld bc, __IO_APU_PORT_DATA+$0300 ; the address of the APU data port (+3) in BC
    ex de, hl               ; move the base address of the OPERAND to HL

    inc hl                  ; reverse the OPERAND bytes to load

    pop af                  ; recover the COMMAND 
    cp __IO_APU_OP_REM16    ; is it a 2 byte OPERAND
    jr Z, am9511a_isr_op_rem16  ; yes then skip over 32bit stuff

    inc hl                  ; increment two more bytes for 32bit OPERAND
    inc hl

    ind                     ; get the higher two bytes of 32bit OPERAND
    ind

am9511a_isr_op_rem16:
    ind                     ; get 16 bit OPERAND
    ind

    jp am9511a_isr_entry    ; go back to get another COMMAND

am9511a_isr_error:          ; we've an error to notify in A
    ld hl, APUError         ; collect any previous errors
    or (hl)                 ; and we add any new error types
    ld (hl), a              ; set the APUError status
    ret                     ; we're done here

;------------------------------------------------------------------------------  
;       Initialises the APU buffers
;

PUBLIC asm_am9511a_reset

EXTERN APUCMDBuf, APUDATABuf
EXTERN APUCMDInPtr, APUCMDOutPtr, APUDATAInPtr, APUDATAOutPtr
EXTERN APUCMDBufUsed, APUDATABufUsed, APUStatus, APUError, _APULock

asm_am9511a_reset:
    push af
    push bc
    push de
    push hl

am9511a_reset_lock_get:
    ld hl, _APULock         ; load the mutex lock address
    sra (hl)                ; get the lock
    jr C, am9511a_reset_lock_get    ; or not

    ld  HL, APUCMDBuf       ; Initialise COMMAND Buffer
    ld (APUCMDInPtr), HL
    ld (APUCMDOutPtr), HL

    ld HL, APUDATABuf       ; Initialise OPERAND POINTER Buffer
    ld (APUDATAInPtr), HL
    ld (APUDATAOutPtr), HL

    xor A                   ; clear A register to 0

    ld (APUCMDBufUsed), A   ; 0 both Buffer counts
    ld (APUDATABufUsed), A

    ld (APUCMDBuf), A       ; clear COMMAND Buffer
    ld HL, APUCMDBuf
    ld D, H
    ld E, L
    inc DE
    ld BC, __APU_CMD_SIZE-1
    ldir

    ld (APUDATABuf), A      ; clear OPERAND Buffer
    ld HL, APUDATABuf
    ld D, H
    ld E, L
    inc DE
    ld BC, __APU_DATA_SIZE-1
    ldir

    ld (APUStatus), a       ; set APU status to idle (NOP)
    ld (APUError), a        ; clear APU errors

am9511a_reset_loop:
    ld bc, __IO_APU_PORT_STATUS ; the address of the APU status port in bc
    in a, (c)                   ; read the APU
    and __IO_APU_STATUS_BUSY    ; busy?
    jr NZ, am9511a_reset_loop

    ld hl, _APULock         ; load the mutex lock address
    ld (hl), $FE            ; give mutex lock
    
    pop hl
    pop de
    pop bc
    pop af
    ret

;------------------------------------------------------------------------------
;       Confirms whether the APU is idle
;       Loop until it returns ready
;       Operand Entry and Removal takes little time,
;       and we'll be interrupted for Command entry.
;       Use after the first APU_ISR call.
;
;       L = contents of (APUStatus || APUError)
;       SCF if no errors (aggregation of any errors found)
;
;       APUError is zeroed on return
;       Uses AF, HL

PUBLIC asm_am9511a_chk_idle

EXTERN APUStatus, APUError

asm_am9511a_chk_idle:
    ld a, (APUStatus)       ; get the status of the APU (but don't disturb APU)
    tst __IO_APU_STATUS_BUSY    ; check busy bit is set,
    jr NZ, asm_am9511a_chk_idle ; so we wait

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
;       APU_CMD_ld
;
;       DE = POINTER to OPERAND, IF REQUIRED
;       A = APU COMMAND

PUBLIC asm_am9511a_cmd_ld    

EXTERN APUCMDInPtr, APUDATAInPtr
EXTERN APUCMDBufUsed, APUDATABufUsed, _APULock

asm_am9511a_cmd_ld:
    push hl                 ; store HL so we don't clobber it

    ld hl, _APULock         ; load the mutex lock address
    sra (hl)                ; get the lock
    jr C, am9511a_command_locked_exit   ; or not

    ld l, a                 ; store COMMAND so we don't clobber it

    ld a, (APUCMDBufUsed)   ; Get the number of bytes in the COMMAND buffer
    cp __APU_CMD_SIZE-1     ; check whether there is space in the buffer
    jr NC, am9511a_command_exit ; COMMAND buffer full, so exit
    
    cp __APU_DATA_SIZE-4    ; check whether there is space for an OPERAND
    jr NC, am9511a_command_exit ; OPERAND buffer full, so exit

    ld a, l                 ; recover the COMMAND
    ld hl, (APUCMDInPtr)    ; get the pointer to where we poke
    ld (hl), a              ; write the COMMAND byte to the APUCMDInPtr   

    inc l                   ; move the COMMAND pointer low byte along, 0xFF rollover
    ld (APUCMDInPtr), hl    ; write where the next byte should be poked

    ld hl, APUCMDBufUsed
    inc (hl)                ; atomic increment of COMMAND count

    and $F0                 ; mask only most significant nibble of COMMAND
    cp __IO_APU_OP_ENT      ; check whether it is OPERAND entry COMMAND
    jr Z, am9511a_cmd_op    ; load an OPERAND pointer
    cp __IO_APU_OP_REM      ; check whether it is OPERAND removal COMMAND
    jr Z, am9511a_cmd_op    ; load an OPERAND pointer

am9511a_command_exit:
    ld hl, _APULock         ; load the mutex lock address
    ld (hl), $FE            ; give mutex lock

am9511a_command_locked_exit:
    pop hl                  ; recover HL
    ret

am9511a_cmd_op:
    ld hl, (APUDATAInPtr)   ; get the pointer to where we poke
    ld (hl), e              ; write the low byte of OPERAND to the APUDATAInPtr   
    inc l                   ; move the POINTER low byte along, 0xFF rollover
    ld (hl), d              ; write the high byte of OPERAND to the APUDATAInPtr   
    inc l
    ld (APUDATAInPtr), hl   ; write where the next DATA should be poked

    ld hl, APUDATABufUsed
    inc (hl)                ; increment of OPERAND count
    inc (hl)

    jr am9511a_command_exit


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

EXTERN asm_z180_push_di, asm_z180_pop_ei_jp

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
    
    ret

PUBLIC _asci0_flush_Rx_di
PUBLIC _asci0_flush_Rx

EXTERN asm_z180_push_di, asm_z180_pop_ei
EXTERN asci0RxCount, asci0RxIn, asci0RxOut, asci0RxBuffer, _asci0RxLock

_asci0_flush_Rx_di:
    push af
    push hl

    call asm_z180_push_di       ; di

    call _asci0_flush_Rx

    call asm_z180_pop_ei        ; ei

    ld hl, _asci0RxLock         ; load the mutex lock address
    ld (hl), $FE                ; give mutex lock
    
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
PUBLIC _asci0_flush_Tx

EXTERN asm_z180_push_di, asm_z180_pop_ei
EXTERN asci0TxCount, asci0TxIn, asci0TxOut, asci0TxBuffer, _asci0TxLock

_asci0_flush_Tx_di:
    push af
    push hl

    call asm_z180_push_di       ; di

    call _asci0_flush_Tx

    call asm_z180_pop_ei        ; ei

    ld hl, _asci0TxLock         ; load the mutex lock address
    ld (hl), $FE                ; give mutex lock

    pop hl
    pop af
    ret

_asci0_flush_Tx:
    xor a
    ld (asci0TxCount), a        ; reset the Tx counter (set 0)

    ld hl, asci0TxBuffer        ; load Tx buffer pointer home
    ld (asci0TxIn), hl
    ld (asci0TxOut), hl

    ret

PUBLIC _asci0_reset

EXTERN _asci0_flush_Rx, _asci0_flush_Tx

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
EXTERN asm_z180_push_di, asm_z180_pop_ei_jp

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
    ld (asci0TxIn), hl          ; write where the next byte should be poked

    ld hl, asci0TxCount
    inc (hl)                    ; atomic increment of Tx count

    ld l, 0                     ; indicate Tx buffer was not full

asci0_clean_up_tx:
    in0 a, (STAT0)              ; load the ASCI0 status register
    and STAT0_TIE               ; test whether ASCI0 interrupt is set
    ret nz                      ; if so then just return

    call asm_z180_push_di       ; critical section begin
    in0 a, (STAT0)              ; get the ASCI status register again
    or STAT0_TIE                ; mask in (enable) the Tx Interrupt
    out0 (STAT0), a             ; set the ASCI status register
    
    jp asm_z180_pop_ei_jp       ; critical section end


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

EXTERN asm_z180_push_di, asm_z180_pop_ei_jp

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
    
    ret

PUBLIC _asci1_flush_Rx_di
PUBLIC _asci1_flush_Rx

EXTERN asm_z180_push_di, asm_z180_pop_ei
EXTERN asci1RxCount, asci1RxIn, asci1RxOut, asci1RxBuffer, _asci1RxLock

_asci1_flush_Rx_di:
    push af
    push hl

    call asm_z180_push_di       ; di

    call _asci1_flush_Rx

    call asm_z180_pop_ei        ; ei

    ld hl, _asci1RxLock         ; load the mutex lock address
    ld (hl), $FE                ; give mutex lock

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
PUBLIC _asci1_flush_Tx

EXTERN asm_z180_push_di, asm_z180_pop_ei
EXTERN asci1TxCount, asci1TxIn, asci1TxOut, asci1TxBuffer, _asci1TxLock


_asci1_flush_Tx_di:
    push af
    push hl

    call asm_z180_push_di       ; di

    call _asci1_flush_Tx

    call asm_z180_pop_ei        ; ei

    ld hl, _asci1TxLock         ; load the mutex lock address
    ld (hl), $FE                ; give mutex lock

    pop hl
    pop af
    ret

_asci1_flush_Tx:

    xor a
    ld (asci1TxCount), a        ; reset the Tx counter (set 0)

    ld hl, asci1TxBuffer        ; load Tx buffer pointer home
    ld (asci1TxIn), hl
    ld (asci1TxOut), hl

    ret

PUBLIC _asci1_reset

EXTERN _asci1_flush_Rx, _asci1_flush_Tx

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
EXTERN asm_z180_push_di, asm_z180_pop_ei_jp

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
    ld (asci1TxIn), hl          ; write where the next byte should be poked

    ld hl, asci1TxCount
    inc (hl)                    ; atomic increment of Tx count

    ld l, 0                     ; indicate Tx buffer was not full

asci1_clean_up_tx:
    in0 a, (STAT1)              ; load the ASCI1 status register
    and STAT1_TIE               ; test whether ASCI1 interrupt is set
    ret nz                      ; if so then just return

    call asm_z180_push_di       ; critical section begin
    in0 a, (STAT1)              ; get the ASCI status register again
    or STAT1_TIE                ; mask in (enable) the Tx Interrupt
    out0 (STAT1), a             ; set the ASCI status register

    jp asm_z180_pop_ei_jp       ; critical section end


;==============================================================================
;       DEBUGGING SUBROUTINES
;

PUBLIC delay
PUBLIC rhexdwd, rhexwd, rhex
PUBLIC phexdwd, phexwd, phex
PUBLIC phexdwdreg, phexwdreg
PUBLIC pstring, pnewline

EXTERN _asci0_reset, _asci0_putchar, _asci0_putc, _asci0_getc

;==============================================================================
;       DELAY SUBROUTINES
;

delay:
    push bc
    ld b, $00
delay_loop:
    ex (sp), hl
    ex (sp), hl
    djnz delay_loop
    pop bc
    ret
        
;==============================================================================
;       INPUT SUBROUTINES
;

rhexdwd:                        ; returns 4 bytes LE, to address in DE, with echo
    push af
    inc de
    inc de
    inc de
    call rhex
    ld (de), a
    call phex
    dec de
    call rhex
    ld (de), a
    call phex
    dec de
    call rhex
    ld (de), a
    call phex
    dec de
    call rhex
    ld (de), a
    call phex     
    pop af
    ret

rhexwd:                         ; returns 2 bytes LE, to address in DE, with echo
    push af
    inc de
    call rhex
    ld (de), a
    call phex
    dec de
    call rhex
    ld (de), a
    call phex
    pop af
    ret

rhex:                       ; Returns byte in a
    push hl
    call _asci0_getc        ; Rx byte in l (a = char received too)
    sub '0'
    cp 10
    jr C, rhexnbl2          ; if a<10 read the second nibble
    sub 7                   ; else subtract 'A'-'0' (17) and add 10
rhexnbl2:
    rlca                    ; shift accumulator left by 4 bits
    rlca
    rlca
    rlca
    ld h, a                 ; temporarily store the first nibble in h
    call _asci0_getc        ; Rx byte in l (a = char received too)
    sub '0'
    cp 10
    jr C, rhexend           ; if a<10 finalize
    sub 7                   ; else subtract 'A' (17) and add 10
rhexend:
    or h                    ; assemble two nibbles into one byte in a
    pop hl
    ret                     ; return the byte read in a

;==============================================================================
;       OUTPUT SUBROUTINES
;

    ;print string
pstring: 
    ld a, (de)          ;Get character from DE address
    or a                ;Is it $00 ?
    ret Z               ;Then RETurn on terminator
    ld l, a
    call _asci0_putc    ;Print it
    inc de              ;Point to next character 
    jr pstring          ;Continue until $00

    ;print CR/LF
pnewline:
    ld l, CHAR_CR
    call _asci0_putc
    ld l, CHAR_LF
    call _asci0_putc
    ret

    ;print Double Word at address DE as 32 bit number in ASCII HEX
phexdwd:
    push af
    inc de
    inc de
    inc de
    ld a, (de)
    call phex
    dec de
    ld a, (de)
    call phex
    dec de
    ld a, (de)
    call phex
    dec de
    ld a, (de)
    call phex
    pop af
    ret

    ;print Word at address DE as 16 bit number in ASCII HEX
phexwd:
    push af
    inc de
    ld a, (de)
    call phex
    dec de
    ld a, (de)
    call phex
    pop af
    ret

    ;print contents of DEHL as 32 bit number in ASCII HEX
phexdwdreg:
    push af
    ld a, d
    call phex
    ld a, e
    call phex
    ld a, h
    call phex
    ld a, l
    call phex
    pop af
    ret

    ;print contents of DE as 16 bit number in ASCII HEX
phexwdreg:
    push af
    ld a, h
    call phex
    ld a, l
    call phex
    pop af
    ret

    ;print contents of A as 8 bit number in ASCII HEX
phex:
    push hl
    push af             ;store the binary value
    rlca                ;shift accumulator left by 4 bits
    rlca
    rlca
    rlca
    and $0F             ;now high nibble is low position
    cp 10
    jr C, phex_b        ;jump if high nibble < 10
    add a, 7            ;otherwise add 7 before adding '0'
phex_b:
    add a, '0'          ;add ASCII 0 to make a character
    ld l, a
    call _asci0_putc    ;print high nibble
    pop af              ;recover the binary value
phex1:
    and $0F
    cp 10
    jr C, phex_c        ;jump if low nibble < 10
    add a, 7
phex_c:
    add a, '0'
    ld l, a
    call _asci0_putc    ;print low nibble
    pop hl
    ret

DEPHASE
