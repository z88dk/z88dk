; ===============================================================
; FILE *cpm_device_file(const char *name)
;
; Map logical CP/M device name (e.g. "LPT:") to a stdio FILE*.
; Case-insensitive; optional trailing colon. Returns 0 if unknown
; or stream not instantiated (e.g. TTY without tty* CRT).
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_cpm_device_file

EXTERN _stdin, _stdout
EXTERN _stdrdr, _stdpun, _stdlst
; _ttyin/_ttyout/_ttyerr are CRT-optional; TTY: falls back to stdout here

asm_cpm_device_file:

   ; enter : hl = const char *name
   ; exit  : hl = FILE * or 0
   ; uses  : af, bc, de, hl

   ld a,h
   or l
   ret z

   call skip_ws
   ld de,name_buf
   call copy_token        ; name_buf = up to 4 chars, uppercased, no colon

   ld hl,name_buf
   ld de,tok_crt
   call streq4
   jr z, ret_stdout

   ld hl,name_buf
   ld de,tok_tty
   call streq4
   jr z, ret_ttyout

   ld hl,name_buf
   ld de,tok_lpt
   call streq4
   jr z, ret_stdlst

   ld hl,name_buf
   ld de,tok_ptp
   call streq4
   jr z, ret_stdpun

   ld hl,name_buf
   ld de,tok_ptr
   call streq4
   jr z, ret_stdrdr

   ld hl,name_buf
   ld de,tok_uc1
   call streq4
   jr z, ret_stdout

   ld hl,name_buf
   ld de,tok_ul1
   call streq4
   jr z, ret_stdlst

   ld hl,name_buf
   ld de,tok_up1
   call streq4
   jr z, ret_stdpun

   ld hl,name_buf
   ld de,tok_up2
   call streq4
   jr z, ret_stdpun

   ld hl,name_buf
   ld de,tok_ur1
   call streq4
   jr z, ret_stdrdr

   ld hl,name_buf
   ld de,tok_ur2
   call streq4
   jr z, ret_stdrdr

   ; BAT has no single FILE*
   ld hl,0
   ret

ret_stdout:
   ld hl,(_stdout)
   ret

ret_stdlst:
   ld hl,(_stdlst)
   ret

ret_stdpun:
   ld hl,(_stdpun)
   ret

ret_stdrdr:
   ld hl,(_stdrdr)
   ret

ret_ttyout:
   ; Default +cpm CRT does not instantiate tty*; map TTY: to console out.
   ld hl,(_stdout)
   ret

; ---- helpers ----

skip_ws:
   ld a,(hl)
   cp ' '
   ret nz
   inc hl
   jr skip_ws

copy_token:
   ; de = dest (4 bytes zeroed first)
   push de
   xor a
   ld (de),a
   inc de
   ld (de),a
   inc de
   ld (de),a
   inc de
   ld (de),a
   pop de
   ld b,4
ct_loop:
   ld a,(hl)
   or a
   ret z
   cp ':'
   ret z
   cp ' '
   ret z
   ; toupper a
   cp 'a'
   jr c, ct_store
   cp 'z'+1
   jr nc, ct_store
   sub 32
ct_store:
   ld (de),a
   inc de
   inc hl
   djnz ct_loop
   ret

streq4:
   ; hl = s1, de = s2 (both 4-byte zero-padded)
   ld b,4
sq:
   ld a,(de)
   cp (hl)
   ret nz
   inc hl
   inc de
   djnz sq
   xor a                       ; Z set
   ret

SECTION data_arch

name_buf:
   defs 4

tok_crt: defm "CRT"
         defb 0
tok_tty: defm "TTY"
         defb 0
tok_lpt: defm "LPT"
         defb 0
tok_ptp: defm "PTP"
         defb 0
tok_ptr: defm "PTR"
         defb 0
tok_uc1: defm "UC1"
         defb 0
tok_ul1: defm "UL1"
         defb 0
tok_up1: defm "UP1"
         defb 0
tok_up2: defm "UP2"
         defb 0
tok_ur1: defm "UR1"
         defb 0
tok_ur2: defm "UR2"
         defb 0
