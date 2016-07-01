;
;       ZX IF1 & Microdrive functions
;
;       Pick a sector with a given file name and record number
;
;       int if1_load_record (int drive, char *filename, int record, struct M_CHAN buffer);
;       
;       6/7 drive:      1-8 for microdrive number
;       4/5 filename:   file name or blank
;       2/3 record:     record number
;       0/1 buffer
;
;       $Id: if1_load_record.asm,v 1.3 2016-07-01 22:08:20 dom Exp $
;
		SECTION   code_clib
                PUBLIC    if1_load_record
                PUBLIC    _if1_load_record

                EXTERN     if1_rommap
                EXTERN    mdvbuffer

                EXTERN     if1_checkblock
                EXTERN    if1_sect_read

                EXTERN     if1_setname

                EXTERN    MAKE_M
                EXTERN    CLOSE_M
                EXTERN    FETCH_H
                EXTERN    MOTOR
                EXTERN    RD_BUFF
                


if1_load_record:
_if1_load_record:
		push	ix		;save callers
                ld      ix,4
                add     ix,sp

                ld      a,(ix+6)
                ld      hl,-1
                and     a               ; drive no. = 0 ?
                jp	z,if_load_record_exit               ; yes, return -1
                dec     a
                cp      8               ; drive no. >8 ?
                jp	nc,if_load_record_exit              ; yes, return -1
                inc     a

                ld      (driveno),a     ; drive number selected (d_str1)

                ld      e,(ix+4)        ; file name
                ld      d,(ix+5)
                ld      hl,filename
                push    de
                push    hl              ; location
                call    if1_setname
                pop     bc
                pop     de
                ld      (fnlen),hl

                ld      a,(ix+2)        ; record number
                ld      (record),a

                ld      l,(ix+0)        ; buffer
                ld      h,(ix+1)
                
                ld      (mdvbuffer),hl

                call    if1_rommap


                ld      hl,(driveno)    ; drive number selected
                ld      (5CD6h),hl      ; d_str1

                ld      a,'M'
                ld      (5CD9h),A       ; l_str1 (device type = "M")

; Probably it will also work by forcing fnlen to zero 
; and not setting the pointer to filename

                ld      hl,(fnlen)      ; length of file name
                ld      (5CDAh),hl      ; n_str1 (lenght of file name)

                ld      hl,filename     ; addr of file name
                ld      (5CDCh),hl      ; pointer to filename

;IF !OLDIF1MOTOR
;               ld      a,(driveno)
;                call    MOTOR           ; select drive motor
;                jp      nz,error_exit
;ENDIF
                call    MAKE_M


copyname:
        ; copy file name from temp string to current channel
                push    ix
                pop     hl
                ld      de,0Eh          ; point to filename in channel
                add     hl,de
                ex      de,hl
                ld      hl,filename
                ld      bc,10
                ldir


; Copy parameters from work buffer to actual channel
                ld      a,(driveno)     ; drive number selected
                ld      (ix+19h),A      ; CHDRIV
                ld      a,(record)      
                ld      (ix+0Dh),a      ; CHREC
                res     0,(ix+18h)      ; set CHFLAG to "read" mode
 
                xor     a
                ld      (if1_sect_read),a       ; flag for "sector read"

                ld      hl,04FBh
                ld      (5CC9h),hl      ; SECTOR

                ld      a,(driveno)     ; drive number selected
                call    MOTOR           ; select drive motor
IF !OLDIF1MOTOR
                jr      nz,error_exit
ENDIF

do_read:
                call    FETCH_H         ; fetch header

                ld      de,001Bh
                add     hl,de
                call    RD_BUFF         ; get buffer

                ld      a,(ix+43h)      ; RECFLG
                or      (ix+46h)        ; 2nd byte of RECLEN
                and     2
                jr      z,nxt_sect

                ld      a,(ix+44h)      ; RECNUM
                cp      (ix+0Dh)        ; CHREC
                jr      nz,nxt_sect
                
                push    ix
                pop     hl
                ld      de,0Eh          ; CHNAME: point to filename in channel
                add     hl,de

                push    hl
                
                ld      de,39h          ; 47h = RECNAM
                add     hl,de
                pop     de              ; DE now points to CHNAME

                ld      b,10            ; compare RECNAM and CHNAME
ckn_loop:       ld      a,(de)
                cp      (hl)
                jr      nz,nxt_sect
                inc     de
                inc     hl
                djnz    ckn_loop
                
                call    if1_checkblock  ; various checks
                cp      4
                jr      z,sectread
nxt_sect:
                call    next_sector     ; Decrease sector counter and check if we reached zero
                jr      nz,do_read

                ld      a,(if1_sect_read)       ; flag for "sector read"
                or      a
                jr      z,sect_notfound


sectread:
                ld      a,(ix+29h)      ; save the current sector number
                ld      (record),a
                
                call    CLOSE_M         ; close file
                call    1               ; unpage
                ei
                
                ld      a,(record)
                ld      h,0
                ld      l,a             ; sector read OK
if_load_record_exit:
		pop	ix		;restore callers
                ret

sect_notfound:
                call    CLOSE_M         ; close file
error_exit:
                call    1               ; unpage
                ei
;               xor     a
;               ld      (if1_sect_read),a       ; flag for "sector read"
                ld      hl,-1           ; sector not found
		jr	if_load_record_exit

; Decrease sector counter and check if we reached zero
next_sector:
                ld      hl,(5CC9h)              ; SECTOR
                dec     hl
                ld      (5CC9h),hl
                ld      a,l
                or      h
                ret

		SECTION bss_clib
; parameters and variables
driveno:        defb    0
record:         defb    0
fnlen:          defw    0
filename:       defs    10
