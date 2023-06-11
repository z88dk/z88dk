;-------------------------------------------------------------------------
; Read/write driver for serial eeprom memory for micro8085_cilb
; Functions below assumes support for INTEL 8085 "undocumented" opcodes

        SECTION code_clib

        EXTERN  eepgsz
        EXTERN  sprxbf
        EXTERN  spirx
        EXTERN  sptxbf
        EXTERN  spitx
        EXTERN  puartd
        EXTERN  puartc
        EXTERN  uenabl
        EXTERN  udtr
        EXTERN  CPU_CLK_kHz
        
        PUBLIC  _ee_mem_rd
        PUBLIC  _ee_mem_wr

;-------------------------------------------------------------------------
; SERIAL EEPROM COMMANDS
eewren  equ  6H
eerdsr  equ  5H
eewrdi  equ  4H
eerdda  equ  3H
eewrda  equ  2H
eewrsr  equ  1H
eewipb  equ  1H

;-------------------------------------------------------------------------
; SERIAL EEPROM READ AND WRITE
;-------------------------------------------------------------------------
; extern bool ee_mem_rd(uint8 *pData, uint16 Address, uint16 Length);
;-------------------------------------------------------------------------
_ee_mem_rd:
        call    pollwip         ;wait for write in progress to
        ld      a,h             ;finish before next access
        or      l               ;test for ok
        ret     z               ;otherwise return false
        ld      de,sp+2         ;get arguments from stack
        ld      hl,(de)         ;last pushed is length
        ld      a,h             ;test for
        or      l               ;zero length
        jp      z,eerd1         ;if so skip and return
        push    hl              ;save length
        inc     de              ;move to next
        inc     de              ;argument position
        ld      hl,(de)         ;which is address
        push    hl              ;save that too
        inc     de              ;move to first
        inc     de              ;argument position
        ld      hl,(de)         ;which is dataptr
        ex      (sp),hl         ;dptr to stack addr to hl
        ld      b,h             ;save addr
        ld      c,l             ;to bc
        call    ee_cs_en        ;SELECT EEPROM
        ld      a,eerdda        ;OPCODE READ DATA
        call    spitx           ;TRANSMIT OPCODE
        ld      a,b             ;GET ADDRESS HIGH BYTE
        call    spitx           ;TRANSMIT
        ld      a,c             ;GET ADDRESS LOW BYTE
        call    spitx           ;TRANSMIT
        pop     hl              ;get back dataptr
        pop     bc              ;get back length
        call    sprxbf          ;let spi in function finish
        call    ee_cs_dis       ;deselect eeprom chip
eerd1:  ld      hl,1            ;return true
        ret

;-------------------------------------------------------------------------
; extern bool ee_mem_wr(uint8 *pData, uint16 Address, uint16 Length);
;-------------------------------------------------------------------------
_ee_mem_wr:
        ld      de,sp+2         ;get arguments from stack
        ld      hl,(de)         ;last pushed is length
        push    hl              ;save len on stack
        inc     de              ;move to next
        inc     de              ;argument position
        ld      hl,(de)         ;which is address
        push    hl              ;save it on stack
        inc     de              ;move to first
        inc     de              ;argument position
        ld      hl,(de)         ;which is dataptr
        ex      (sp),hl         ;dptr to stack addr to hl
        ex      de,hl           ;addr to de scrap hl
        ld      a,e             ;addr lsb to a
        and     a,eepgsz-1      ;equals addr % pgsize
        ld      b,0             ;copy intermediate
        ld      c,a             ;result to bc 
        ld      hl,eepgsz       ;pglen = pgsize - (addr % pgsize)
        dsub                    ;hl now holds len within page
        ld      b,h             ;copy result
        ld      c,l             ;to bc which is size of
        jp      eewr2           ;first chunk to page boundary 
eewr1:  ld      bc,eepgsz       ;next chunk assume page size
eewr2:  pop     hl              ;get dptr at top of stack
        ex      (sp),hl         ;swap for length
        ld      a,h             ;test for zero
        or      l               ;remaining length
        jp      z,eewr4         ;if so clean up and return
        call    cphlbc          ;compare tot - page
        jp      nc,eewr3        ;jmp if tot >= page
        ld      b,h             ;else remaining is less than
        ld      c,l             ;full page so put len in bc
eewr3:  dsub                    ;sub chunk len from tot
        ex      (sp),hl         ;len to stack dptr to hl
        push    hl              ;correct order dptr on top
        push    bc
        push    de
        call    pollwip         ;let write in progress finish
        pop     de
        pop     bc
        ld      a,h             ;test ok result of
        or      l               ;write in progress
        jp      z,eewr5         ;otherwise return false
        pop     hl              ;get dataptr
        call    ee_write_pg     ;execute write
        push    hl              ;save dataptr
        jp      eewr1           ;continue
eewr4:  pop     hl              ;pop off working value
        ld      hl,1            ;return true when ok
        ret
eewr5:  pop     bc              ;pop off twice
        pop     bc              ;return false (hl already zero)
        ret

;-------------------------------------------------------------------------
;     compare hl - bc
; no carry if hl >= bc
;    carry if hl < bc
cphlbc: ld      a,h             ;compare hl - bc
        cp      b               ;and return
        ret     nz              ;correct c
        ld      a,l             ;and z
        cp      c               ;flags
        ret

;-------------------------------------------------------------------------
; Local arguments: Mem dataptr [HL], EEPROM addr [DE], length [BC]
; Returning Mem dptr and address incremented for next access, length zero
;-------------------------------------------------------------------------
ee_write_pg:
        push    hl              ;save dptr
        push    bc              ;save length
        ld      b,d             ;copy address
        ld      c,e             ;to bc
        call    ee_cs_en        ;SELECT EEPROM
        ld      a,eewren        ;OPCODE WRITE ENABLE
        call    spitx           ;TRANSMIT IT
        call    ee_cs_dis       ;DESELECT
        call    ee_cs_en        ;SELECT AGAIN
        ld      a,eewrda        ;OPCODE WRITE DATA
        call    spitx           ;TRANSMIT IT
        ld      a,b             ;GET ADDRESS HIGH BYTE
        call    spitx           ;TRANSMIT
        ld      a,c             ;GET ADDRESS LOW BYTE
        call    spitx           ;TRANSMIT
        pop     hl              ;get back length
        ld      d,h             ;copy length
        ld      e,l             ;to de temporary
        add     hl,bc           ;add addr (bc) and len
        ex      (sp),hl         ;new addr to stack dptr to hl
        ld      b,d             ;copy length
        ld      c,e             ;to bc
        call    sptxbf          ;let spi out function finish
        call    ee_cs_dis       ;deselect eeprom chip
        pop     de              ;get back new address
        ret

;-------------------------------------------------------------------------
; datasheet says max write time for chip is 5 ms so poll and test for 10 ms
; one loop with spi_in + spi_out takes about 280us add 140us and do 25 loops
;-------------------------------------------------------------------------
pollwip:ld      b,25            ;POLL WRITE IN PROGRESS
pollw1: call    ee_cs_en        ;SELECT EEPROM
        ld      a,eerdsr        ;OPCODE READ STATUS
        call    spitx           ;TRANSMIT OPCODE
        call    spirx           ;READ STATUS
        ld      c,a             ;TMP SAVE STATUS
        call    ee_cs_dis       ;DESELECT
        ld      a,c             ;RESTORE TMP SAVED
        ld      hl,1            ;IF OK RETURN TRUE
        and     eewipb          ;MASK THE BIT
        ret     z               ;ZERO MEANS READY
        call    delay140        ;ELSE ADD SOME DELAY
        dec     b               ;AND COUNT LOOPS
        jp      nz,pollw1       ;MORE LOOPS TRY AGAIN
        ld      hl,0            ;ELSE RETURN HL=0 FALSE
        ret

;-------------------------------------------------------------------------
ee_cs_en:
        ld      a,uenabl+udtr   ;eeprom chip select on DTR line
        out     (puartc),a      ;uart control reg
        ret

;-------------------------------------------------------------------------
ee_cs_dis:
        ld      a,uenabl        ;disable RTS and DTR lines
        out     (puartc),a      ;uart control reg
        ret

;-------------------------------------------------------------------------
delay140:                       ;(2/XTAL)*n*(4+10)=140us -> n=XTAL_kHz/200
        ld      h,CPU_CLK_kHz/200
delay2: dec     h               ;4 clock cycles
        jp      nz,delay2       ;10 clock cycles
        ret                     ;returning zero in h
