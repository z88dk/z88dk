;
;       ZX IF1 & Microdrive functions
;
;       Pick a sector with a given sector number
;
;       int if1_load_sector (int drive, int sector, struct M_CHAN buffer);
;       
;       4/5 drive:      1-8 for microdrive number
;       2/3 sector number
;       0/1 buffer
;
;       $Id: if1_load_sector.asm,v 1.3 2016-07-01 22:08:20 dom Exp $
;

		SECTION   code_clib
                PUBLIC    if1_load_sector
                PUBLIC    _if1_load_sector

                EXTERN     if1_rommap
                EXTERN    mdvbuffer

                EXTERN     if1_checkblock
                EXTERN    if1_sect_read

                EXTERN    MAKE_M
                EXTERN    CLOSE_M
                EXTERN    FETCH_H
                EXTERN    MOTOR
                EXTERN    RD_BUFF
                


if1_load_sector:
_if1_load_sector:
		push	ix	;save callers
                ld      ix,4
                add     ix,sp

                ld      a,(ix+4)
                ld      hl,-1
                and     a               ; drive no. = 0 ?
                jp	z,if_load_sector_exit               ; yes, return -1
                dec     a
                cp      8               ; drive no. >8 ?
                jr	nc,if_load_sector_exit              ; yes, return -1
                inc     a

                ld      (driveno),a     ; drive number selected (d_str1)

                ld      a,(ix+2)        ; sector number
                ld      (sector),a

                ld      l,(ix+0)        ; buffer
                ld      h,(ix+1)
                
                ld      (mdvbuffer),hl

                call    if1_rommap



                ld      hl,(driveno)    ; drive number selected
                ld      (5CD6h),hl      ; d_str1

                ld      a,'M'
                ld      (5CD9h),A       ; l_str1 (device type = "M")

                ld      hl,0            ; force to zero (otherwise it hangs)
                ld      (5CDAh),hl      ; n_str1 (lenght of file name)

                call    MAKE_M


; Copy parameters from work buffer to actual channel
                ld      a,(driveno)     ; drive number selected
                ld      (ix+19h),A      ; CHDRIV
                ld      a,(sector)      
                ld      (ix+0Dh),a      ; CHREC
                res     0,(ix+18h)      ; set CHFLAG to "read" mode
 
                xor     a
                ld      (if1_sect_read),a       ; flag for "sector read"

                ld      hl,04FBh
                ld      (5CC9h),hl      ; SECTOR



; *** scelta routine ***

                ld      a,(driveno)     ; drive number selected
                call    MOTOR           ; select drive motor
IF !OLDIF1MOTOR
                jr      nz,error_exit
ENDIF


nxtsector:
                call    FETCH_H         ; fetch header

                ld      a,(ix+29h)      ; HDNUMB: sector number
                cp      (ix+0Dh)        ; CHREC
                jr      nz,nextrec

                ld      de,001Bh
                add     hl,de
                call    RD_BUFF         ; get buffer

                call    if1_checkblock  ; various checks
                cp      4
                jr      z,ok_close

nextrec:
                call    next_sector
                jr      nz,nxtsector

        ;       ld      a,(flags)
        ;       bit     2,a             ; "verify mode" flag
        ;
        ;       jp      z,noverify
        ;
        ;; close, return with "VERIFICATION ERROR" code
        ;       call    CLOSE_M         ; close file
        ;       call    1               ; unpage
        ;       ei
        ;       ld      hl,-2           ; verify error
        ;       ret
        ;noverify:

                ld      a,(if1_sect_read)       ; flag for "sector read"
                or      a
                jr      z,sect_notfound

sectread:
                call    CLOSE_M         ; close file
                call    1               ; unpage
                ei
                
                ld      a,(sector)
                ld      l,a
                ld      h,0             ; Return the sector number
if_load_sector_exit:
		pop	ix		; restore callers
                ret

sect_notfound:
                call    CLOSE_M                 ; close file
error_exit:
                call    1                       ; unpage
                ei
                ld      hl,-1                   ; sector not found
		jr	if_load_sector_exit

; close file, and go back to main
ok_close:
                call    1               ; unpage
                ei
                ld      a,(sector)
                ld      l,a
                ld      h,0             ; Return the sector number
		jr	if_load_sector_exit

; Decrease sector counter and check if we reached zero
next_sector:
                ld      hl,(5CC9h)              ; SECTOR
                dec     hl
                ld      (5CC9h),hl
                ld      a,l
                or      h
                ret

		SECTION bss_clib
;; various flags
;flags:         defb    0

; parameters and variables
driveno:        defb    0
sector:         defb    0
