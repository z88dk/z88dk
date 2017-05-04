	; This code is run when we come from rcm_boot.asm

	jr run_command
	
	

cmd_vector:
	defw start_user_prog ; command=0
	defw do_flash        ; command=1
	defw transfer2ram    ; command=2

num_prog_bytes:
	defw 0 ; Set by ix from download utility, then is flashed and 
	       ; used by transfer2ram
	
run_command:
	; Getting here we should not use the serial download any more
	; so we patch a direct jump from adress __start_prog+3
	ld a,0c3h ; jp mnemonic
	ld (__start_prog+3),a

	ld a,(command)
	ld hl,cmd_vector
	add a,a
	ld e,a
	ld d,0
	add hl,de
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	jp (hl)
	

	; We need this to be relocatable (i.e. only use jr) and not use any stack
blinkled:
	ld c,10
	ld hl,60000
blinkled_n:       ; Jumping here means chl should contain speed (default 10, 60000)

	ld a,84h ;
    	defb 0d3h; ioi ;
        ld (24h),a ;
again2:
	ld b,c
loop:
	ld d,h
	ld e,l
loop2:
	dec de
	ld a,d
	or e
	jr nz,loop2
	
	djnz loop

    	ld a,0ffh  ; leds off ;
    	defb 0d3h; ioi ;
    	ld (030h),a ;

	ld b,c
loopa:
	ld d,h
	ld e,l
loopa2:
	dec de
	ld a,d
	or e
	jr nz,loopa2
	
	djnz loopa

    	ld a,00h  ; leds on ;
    	defb 0d3h; ioi ;
    	ld (030h),a ;

	jr again2

do_flash:
	; Set the command to 2 (transfer2ram), next time
	; we will start from flash at addr zero...
	ld a,2
	ld (command),a

	; This value will get flashed in
	ld (num_prog_bytes),ix

	push ix
	call erase
	call waittoggle
	pop ix
	
	ld a,80h
	ld hl,0
	push ix
	pop de
	ld bc,0
	call flashbytes

	ld hl,frv
	call outstr

	; Here we try to prevent a program from running from ram so we can
	; be (reasonably) sure that we are running from flash
	; this will make any1 starting from addr zero make a "jp 0"
	ld a,0c3h;
	ld (0),a
	ld hl,0;
	ld (1),hl

	ld c,1
	ld hl,10
	jp blinkled_n
	
freeze: jr freeze

transfer2ram:
	; This routine should set all registers to same values as in
	; serial download, move all code from flash to ram
	; Then it should start program from RAM. It needs to 
	; set xpr so we can jump to extra segment, and then we can move
	; the "floor" so address zero goes from flash to ram.

	; We have no stack here ** remember **

	; Fix decent clockspeed
	ld a,08h
	defb 0d3h; ioi
	ld (00h),a

	; Set xpc so flash addr zero is mirrored in E000h (extended segment)
	ld a,-14
	defb 0edh, 067h ; ld xpc,a
	
	ld hl,jump2ext
	ld de,0e000h
	add hl,de
	jp (hl) ; This jump just makes the code "continue" at jump2ext

jump2ext:
	; We should now "be" in extended segment at E000h (just by magic ;-)

	; Now we can take all the "pokes" from __prefix to __postfix (including
	; the insane baudrate divisor 42 ;-) and put the into I/O


	; Code now needs to be relocatable!!
	ld hl,__prefix
loopio:
	ld a,(hl)
	ld d,a  ; Save for later bit 7 testing
	and 7fh  ; mask MSB indicating I/O in table (80h)
	ld b,a  ; Load into high byte..
	inc hl
	ld c,(hl) ; Low address of I/O byte to poke into c
	inc hl
	ld a,(hl)
	inc hl
	
	bit 7,d
	jr z, skipioprefix  ; Is this a memory write?

	defb 0d3h ; ioi
skipioprefix:
	ld (bc),a

	ld de,__postfix

	ld a,h
	sub d
	jr nz, loopio ; If these are not the same loop some more

	ld a,l
	sub e
	jr nz, loopio

	ld a,(__patch_baudrate)       ; This is saved when we receive it from host
	defb 0d3h ; ioi
	ld (0a9h),a 			; TAT4R baud divisor

	ld sp,8000;
	
	; Now the RAM should be mapped to address zero
	jp back2ram0 ; This is an absolute jump so it has beed assembled to ram0
back2ram0:
	
	; We are now back into the ram bottom and need not be relocatable!!
	; Set flash up in extended segment
	; Set xpc so flash addr zero (physical address 80000) 
	; is mirrored in E000h (extended segment)
	ld a,72h   ; 80(000)-0E(000) = 72(000) = start of flash
	defb 0edh, 067h ; ld xpc,a

	ld de,0
	ld hl,0e000h
	ld bc,8192
	ldir

	; This is awfully lazy but makes sure we move flash <=32k down to ram 0-32k
	; We assume here that we can trash the stack (going downward from 8000)
	ld a,74h   ; flash +8k
	defb 0edh, 067h ; ld xpc,a
	ld de,8192
	ld hl,0e000h
	ld bc,8192
	ldir

	ld a,76h   ; flash +8k
	defb 0edh, 067h ; ld xpc,a
	ld de,2*8192
	ld hl,0e000h
	ld bc,8192
	ldir

	ld a,78h   ; flash +8k
	defb 0edh, 067h ; ld xpc,a
	ld de,3*8192
	ld hl,0e000h
	ld bc,8192
	ldir
	
	
	
	ld a,0
	ld (command),a

	jp 0 ;

dbg_skip2here:
	ld c,1
	ld hl,60000
	; Remember here that we do not have a stack (yet) since we 
	; run in flash!!
	jp blinkled_n

transfstr: defm "This is the transfer 2 ram function",0


_s_ostr: defw 0
	; Send pointer to null terminated string in hl
_OUTSTR:
	ld a,(hl)
	cp 0
	ret z	
	call __sendchar
	inc hl
	jr _OUTSTR

	include "rcmx000_flutil.asm"
start_user_prog:
