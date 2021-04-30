;
;       ZX IF1 & Microdrive functions
;
;       Pick a sector with a given sector number
;
;       int if1_next_file (int drive, struct M_CHAN buffer);
;
;       On exit, the functions gives the current sector number
;
;
;       $Id: if1_next_file.asm $
;

		SECTION   code_clib
                PUBLIC    if1_next_file
                PUBLIC    _if1_next_file

                EXTERN     if1_rommap
                EXTERN    mdvbuffer

                EXTERN    if1_checkblock
                EXTERN    if1_sect_ready
                EXTERN    mdv_seek_count

                EXTERN    MAKE_M
                EXTERN    CLOSE_M
                EXTERN    FETCH_H
                EXTERN    MOTOR
                EXTERN    RD_BUFF
                


if1_next_file:
_if1_next_file:
		push	ix	;save callers
                ld      ix,4
                add     ix,sp

                ld      a,(ix+2)
                ld      hl,-1
                and     a               ; drive no. = 0 ?
                jp      z,if_next_file_exit               ; yes, return -1
                cp      9               ; drive no. >8 ?
                jr      nc,if_next_file_exit              ; yes, return -1

                ld      (driveno),a     ; drive number selected (d_str1)

                ;ld      a,(ix+2)        ; sector number
                ;ld      (sector),a

                ld      l,(ix+0)        ; buffer
                ld      h,(ix+1)
                
                ld      (mdvbuffer),hl

                call    if1_rommap


                ;ld      hl,(driveno)    ; drive number selected
                ;ld      (5CD6h),hl      ; d_str1
                ld      a,(driveno)    ; drive number selected
                ld      (5CD6h),a      ; d_str1

                ld      a,'M'
                ld      (5CD9h),A       ; l_str1 (device type = "M")

                ld      hl,0            ; force to zero (otherwise it hangs)
                ld      (5CDAh),hl      ; n_str1 (lenght of file name)

                call    MAKE_M


; Copy parameters from work buffer to actual channel
                ld      a,(driveno)     ; drive number selected
                ld      (ix+19h),A      ; CHDRIV
                ;ld      a,(sector)      
                ;ld      (ix+0Dh),a      ; CHREC
                res     0,(ix+18h)      ; set CHFLAG to "read" mode
 
                xor     a
                ld      (if1_sect_ready),a       ; flag for "sector read"

                ;ld      hl,255*5		; set sector counter
				ld      hl,(mdv_seek_count)		; set sector counter (retries slightly reduced)
                ld      (5CC9h),hl      ; SECTOR



                ld      a,(driveno)     ; drive number selected
                call    MOTOR           ; select drive motor
IF !OLDIF1MOTOR
                jr      nz,error_exit
ENDIF



nxtsector:
                call    FETCH_H         ; fetch header

                ;ld      a,(ix+29h)      ; HDNUMB: sector number
                ;cp      (ix+0Dh)        ; CHREC
                ;jr      nz,nextrec

                ld      de,001Bh
                add     hl,de
                call    RD_BUFF         ; get buffer

                ld      a,(ix+43h)      ; flags
				and		2				; EOF?
                jr      z,nextrec

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

                ld      a,(if1_sect_ready)       ; flag for "sector read"
                or      a
                jr      z,sect_notfound

sectread:
                ld      a,(ix+29h)      ; save the current sector number
                ld      (sector),a
				
                call    CLOSE_M         ; close file
                call    1               ; unpage
                ei
                
                ld      a,(sector)
                ld      l,a
                ld      h,0             ; Return the sector number
if_next_file_exit:
		pop	ix		; restore callers
                ret

sect_notfound:
                call    CLOSE_M                 ; close file
error_exit:
                call    1                       ; unpage
                ei
                ld      hl,-1                   ; sector not found
		jr	if_next_file_exit

; close file, and go back to main
ok_close:
                ld      a,(ix+29h)      ; save the current sector number
                ld      (sector),a
				
                call    CLOSE_M         ; close file
		call    1               ; unpage
                ei
                ld      a,(sector)
                ld      l,a
                ld      h,0             ; Return the sector number
		jr	if_next_file_exit

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
