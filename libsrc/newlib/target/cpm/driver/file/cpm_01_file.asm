;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; cpm_01_file — CP/M FCB disk file driver for newlib fcntl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Provides asm_target_open_p1 / asm_target_open_p2 so unprefixed
; open/creat/read/write/lseek/close use BDOS FCB I/O on
; subtype=cpm.  FatFs (f_*) stays a separate stack.
;
; FDSTRUCT layout (base = FDSTRUCT *, JP = base+3):
;
;  base  JP   field
;    0    -   CALL fdriver (3)
;    3    0   JP cpm_01_file (3)
;    6    3   flags
;    7    4   ref_count
;    8    5   mode_byte
;    9    6   ioctl_flags (2)
;   11    8   mutex (6)
;   17   14   cpm_fcb (42)
;   59   56   sector buffer (128)
;  187  184   cached_record (4)  — 0xffffffff = invalid
;  191  188   dirty (1)
;
; p1 data size (after 11-byte header) = 181
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "config_private.inc"

SECTION code_driver

PUBLIC cpm_01_file
PUBLIC asm_target_open_p1
PUBLIC asm_target_open_p2

EXTERN console_01_input_terminal_fdriver
EXTERN STDIO_MSG_READ, STDIO_MSG_WRIT, STDIO_MSG_SEEK
EXTERN STDIO_MSG_FLSH, STDIO_MSG_CLOS, STDIO_MSG_ICTL
EXTERN STDIO_SEEK_SET, STDIO_SEEK_CUR, STDIO_SEEK_END
EXTERN error_enotsup_zc, error_znc
EXTERN asm_cpm_bdos
EXTERN asm_toupper
EXTERN asm_mtx_init
EXTERN asm_memset

; offsets from FDSTRUCT.JP (ix in driver)
defc FD_MODE       = 5
defc FD_FCB        = 14
defc FD_BUF        = 56
defc FD_CACHED     = 184
defc FD_DIRTY      = 188

; offsets within cpm_fcb
defc FCB_RANREC    = 33
defc FCB_RWPTR     = 36
defc FCB_USE       = 40
defc FCB_UID       = 41
defc FCB_SIZE      = 42

defc SECSIZE       = 128
defc EXTRA_SIZE    = 181

defc OF_RDWR_MASK  = 0x03
defc OF_APPEND     = 0x04
defc OF_CREAT      = 0x10
defc OF_TRUNC      = 0x40

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DRIVER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

cpm_01_file:

   cp STDIO_MSG_READ
   jp z, file_read

   cp STDIO_MSG_WRIT
   jp z, file_write

   cp STDIO_MSG_SEEK
   jp z, file_seek

   cp STDIO_MSG_FLSH
   jp z, file_flush

   cp STDIO_MSG_CLOS
   jp z, file_close

   cp STDIO_MSG_ICTL
   jp z, error_znc

   jp error_enotsup_zc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; OPEN p1 / p2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm_target_open_p1:

   ; de = path, bc = oflag, hl = arg
   ld a,d
   or e
   scf
   ret z

   ; save path/oflag in statics (simpler than relying on exx across heap_alloc)
   ld (saved_path),de
   ld (saved_oflag),bc

   ld hl,EXTRA_SIZE
   or a
   ret

asm_target_open_p2:

   ; hl = FDSTRUCT *
   push hl                     ; FDSTRUCT *

   ; CALL fdriver
   ld (hl),205
   inc hl
   ld de,console_01_input_terminal_fdriver
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl

   ; JP driver
   ld (hl),195
   inc hl
   ld de,cpm_01_file
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl

   ; flags
   ld (hl),0
   inc hl

   ; ref_count = 1 + (oflag.b7)
   ld a,(saved_oflag)
   rlca
   and 1
   inc a
   ld (hl),a
   inc hl

   ; mode_byte
   ld a,(saved_oflag)
   and OF_RDWR_MASK
   ld (hl),a
   inc hl

   ; ioctl = 0
   xor a
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl

   ; mutex
   push hl
   ld c,mtx_plain
   call asm_mtx_init
   pop hl
   ld de,6
   add hl,de                   ; hl = &FCB

   ; zero FCB
   push hl
   ld e,0
   ld bc,FCB_SIZE
   call asm_memset
   pop hl

   ; parse path
   ld de,(saved_path)
   call parse_fcb

   ; FCB.uid = getuid()
   push hl
   ld c,__CPM_SUID
   ld de,0x00ff
   call asm_cpm_bdos
   pop hl
   push hl
   ld de,FCB_UID
   add hl,de
   ld (hl),a
   pop hl

   ld a,(saved_oflag)
   ld b,a                      ; b = oflag

   ; O_TRUNC -> delete first
   bit 6,b
   call nz, bdos_delete

   bit 6,b
   jr nz, do_create

   call bdos_open
   jr nc, opened

   bit 4,b                     ; O_CREAT
   jr z, open_error

do_create:
   call bdos_delete
   call bdos_make
   jr c, open_error

opened:
   ; FCB.use = oflag & 3
   push hl
   ld de,FCB_USE
   add hl,de
   ld a,b
   and OF_RDWR_MASK
   ld (hl),a
   pop hl

   ; invalidate cache at FDSTRUCT (base+187)
   pop de                      ; FDSTRUCT *
   push de
   push ix
   push de
   pop ix
   ld de,3
   add ix,de                   ; ix = &JP for helpers
   call get_cached
   ld a,0xff
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   call get_dirty
   ld (hl),0

   ; O_APPEND
   bit 2,b
   jr z, open_finish

   ld c,STDIO_SEEK_END
   exx
   ld de,0
   ld hl,0
   ld c,STDIO_SEEK_END
   exx
   call file_seek

open_finish:
   pop ix
   pop de                      ; FDSTRUCT *
   ld c,0                      ; FILE type = disk
   or a
   ret

open_error:
   pop hl
   scf
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; BDOS helpers — hl = &FCB throughout, b = oflag preserved
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

bdos_open:
   push bc
   push hl
   call swapuid_set
   pop hl
   push hl
   ex de,hl
   ld c,__CPM_OPN
   call asm_cpm_bdos
   pop hl
   push af
   call swapuid_restore
   pop af
   pop bc
   inc a                       ; 0xff -> 0 means fail
   scf
   ret z
   or a
   ret

bdos_make:
   push bc
   push hl
   call swapuid_set
   pop hl
   push hl
   ex de,hl
   ld c,__CPM_MAKE
   call asm_cpm_bdos
   pop hl
   push af
   call swapuid_restore
   pop af
   pop bc
   inc a
   scf
   ret z
   or a
   ret

bdos_delete:
   push bc
   push hl
   call swapuid_set
   pop hl
   push hl
   ex de,hl
   ld c,__CPM_DEL
   call asm_cpm_bdos
   pop hl
   call swapuid_restore
   pop bc
   or a
   ret

bdos_close:
   push hl
   call swapuid_set
   pop hl
   push hl
   ex de,hl
   ld c,__CPM_CLS
   call asm_cpm_bdos
   pop hl
   jp swapuid_restore

SECTION data_driver

old_uid:
   defb 0

saved_path:
   defw 0
saved_oflag:
   defw 0

SECTION code_driver

; hl = &FCB
swapuid_set:
   push hl
   push de
   push bc
   ld c,__CPM_SUID
   ld de,0x00ff
   call asm_cpm_bdos
   ld (old_uid),a
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   ld de,FCB_UID
   add hl,de
   ld e,(hl)
   ld d,0
   ld c,__CPM_SUID
   call asm_cpm_bdos
   pop bc
   pop de
   pop hl
   ret

swapuid_restore:
   push hl
   push de
   push bc
   ld a,(old_uid)
   ld e,a
   ld d,0
   ld c,__CPM_SUID
   call asm_cpm_bdos
   pop bc
   pop de
   pop hl
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; parse_fcb: hl=&FCB, de=path  (optional d:, 8.3 name)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

parse_fcb:
   push hl

   ; skip ws
p_ws:
   ld a,(de)
   cp ' '
   jr z, p_ws1
   cp 9
   jr nz, p_drv
p_ws1:
   inc de
   jr p_ws

p_drv:
   ld (hl),0                   ; default drive
   push de
   inc de
   ld a,(de)
   pop de
   cp ':'
   jr nz, p_name
   ld a,(de)
   call asm_toupper
   sub 'A'-1
   ld (hl),a
   inc de
   inc de

p_name:
   inc hl                      ; &name
   ld b,8
   call p_field
   ; skip to . or NUL
p_skip:
   ld a,(de)
   or a
   jr z, p_ext
   cp '.'
   jr z, p_dot
   inc de
   jr p_skip
p_dot:
   inc de
p_ext:
   ld b,3
   call p_field
   ld (hl),0                   ; extent = 0
   pop hl
   ret

; fill B chars at hl from de; pad spaces
p_field:
   ld a,(de)
   or a
   jr z, p_pad
   cp '.'
   jr z, p_pad
   cp '*'
   jr z, p_wild
   call p_legal
   jr c, p_pad
   call asm_toupper
   ld (hl),a
   inc hl
   inc de
   djnz p_field
p_eat:
   ld a,(de)
   or a
   ret z
   cp '.'
   ret z
   call p_legal
   ret c
   inc de
   jr p_eat

p_wild:
   ld a,'?'
p_wloop:
   ld (hl),a
   inc hl
   djnz p_wloop
   jr p_eat

p_pad:
   ld a,' '
p_ploop:
   ld (hl),a
   inc hl
   djnz p_ploop
   ret

p_legal:
   call asm_toupper
   cp '.'
   scf
   ret z
   cp ':'
   scf
   ret z
   cp 0x7f
   scf
   ret z
   cp '!'
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ix helpers: &FCB, &BUF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

get_fcb:
   push ix
   pop hl
   ld de,FD_FCB
   add hl,de
   ret

get_buf:
   push ix
   pop hl
   ld de,FD_BUF
   add hl,de
   ret

; hl = &cached_record (4 bytes)
get_cached:
   push ix
   pop hl
   ld de,FD_CACHED
   add hl,de
   ret

; hl = &dirty
get_dirty:
   push ix
   pop hl
   ld de,FD_DIRTY
   add hl,de
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; rwptr get/set  (dehl)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

get_rwptr:
   call get_fcb
   ld de,FCB_RWPTR
   add hl,de
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   ld l,c
   ld h,b                      ; dehl = rwptr
   ret

set_rwptr:
   ; dehl = value
   push de
   push hl
   call get_fcb
   ld de,FCB_RWPTR
   add hl,de
   pop bc
   ld (hl),c
   inc hl
   ld (hl),b
   inc hl
   pop bc
   ld (hl),c
   inc hl
   ld (hl),b
   ret

; dehl >>= 7
shr7:
   push bc
   ld b,7
shr7l:
   srl d
   rr e
   rr h
   rr l
   djnz shr7l
   pop bc
   ret

; dehl <<= 7
shl7:
   push bc
   ld b,7
shl7l:
   sla l
   rl h
   rl e
   rl d
   djnz shl7l
   pop bc
   ret

; dehl++
inc_dehl:
   inc l
   ret nz
   inc h
   ret nz
   inc e
   ret nz
   inc d
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; cache: ensure buffer holds record in dehl
; exit: carry set on hard error; NC with buffer valid
;       (read fail for missing sector fills 0x1a when Cy_fill set)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; A=0 for read-strict (EOF -> Cy), A=1 for write-fill
cache_get:
   ld (cache_mode),a

   ; already cached?
   push de
   push hl
   call get_cached
   pop bc                      ; rec lo
   ld a,(hl)
   cp c
   jr nz, cg_miss1
   inc hl
   ld a,(hl)
   cp b
   jr nz, cg_miss1
   inc hl
   pop de                      ; rec hi
   ld a,(hl)
   cp e
   jr nz, cg_miss2
   inc hl
   ld a,(hl)
   cp d
   jr nz, cg_miss2
   or a
   ret

cg_miss1:
   pop de
cg_miss2:
   ld (save_rec),bc
   ld (save_rec+2),de

   call get_dirty
   ld a,(hl)
   or a
   call nz, flush_raw
   ret c

   call get_fcb
   push hl
   call swapuid_set
   pop hl
   push hl

   ; ranrec = record
   ld bc,FCB_RANREC
   add hl,bc
   ld a,(save_rec)
   ld (hl),a
   inc hl
   ld a,(save_rec+1)
   ld (hl),a
   inc hl
   ld a,(save_rec+2)
   ld (hl),a

   call get_buf
   ex de,hl
   ld c,__CPM_SDMA
   call asm_cpm_bdos

   pop hl
   push hl
   ex de,hl
   ld c,__CPM_RRAN
   call asm_cpm_bdos
   pop hl
   push af
   call swapuid_restore
   pop af
   or a
   jr z, cg_ok

   ; read failed
   ld a,(cache_mode)
   or a
   scf
   ret z                       ; strict read -> EOF/error

   ; fill for write
   call get_buf
   push hl
   ld e,0x1a
   ld bc,SECSIZE
   call asm_memset
   pop hl

cg_ok:
   call get_cached
   ld a,(save_rec)
   ld (hl),a
   inc hl
   ld a,(save_rec+1)
   ld (hl),a
   inc hl
   ld a,(save_rec+2)
   ld (hl),a
   inc hl
   ld a,(save_rec+3)
   ld (hl),a
   call get_dirty
   ld (hl),0
   or a
   ret

SECTION bss_driver

save_rec:
   defs 4
cache_mode:
   defb 0
seek_tmp:
   defs 4

SECTION code_driver

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; flush
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

file_flush:
   call flush_raw
   jp nc, error_znc
   scf
   ret

; exit: Cy on error
flush_raw:
   call get_dirty
   ld a,(hl)
   or a
   ret z

   call get_fcb
   push hl
   call swapuid_set
   pop hl
   push hl

   ld de,FCB_RANREC
   add hl,de
   push hl
   call get_cached
   ld a,(hl)
   ld c,a
   inc hl
   ld a,(hl)
   ld b,a
   inc hl
   ld a,(hl)
   pop hl
   ld (hl),c
   inc hl
   ld (hl),b
   inc hl
   ld (hl),a

   call get_buf
   ex de,hl
   ld c,__CPM_SDMA
   call asm_cpm_bdos

   pop hl
   push hl
   ex de,hl
   ld c,__CPM_WRAN
   call asm_cpm_bdos
   pop hl
   push af
   call swapuid_restore
   pop af
   or a
   scf
   ret nz
   call get_dirty
   ld (hl),0
   or a
   ret

file_close:
   call flush_raw
   call get_fcb
   call bdos_close
   jp error_znc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; READ  DE'=buf BC'=n HL=n  -> BC=read
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

file_read:
   exx
   ld hl,0                     ; count

rd_loop:
   ld a,b
   or c
   jr z, rd_done

   push bc
   push de
   push hl
   call read_byte              ; a=byte, Cy=eof
   pop hl
   pop de
   pop bc
   jr c, rd_eof

   ld (de),a
   inc de
   inc hl
   dec bc
   jr rd_loop

rd_eof:
   ld a,h
   or l
   jr nz, rd_done
   ; true EOF with 0 bytes
   exx
   ld bc,0
   ld hl,-1
   scf
   ret

rd_done:
   push hl
   exx
   pop bc
   or a
   ret

read_byte:
   call get_rwptr              ; dehl = pos
   ld a,l
   and 0x7f
   push af                     ; offset
   call shr7                   ; dehl = record
   xor a                       ; strict read
   call cache_get
   pop bc                      ; b=?, offset was in a on stack as af
   ; fix: offset in stack as af - pop af
   ; already popped as bc - c has flags, b has a? pop af gives a=offset
   ; I did push af / pop bc — a in c? No: push af pushes A then F, pop bc gets B=A, C=F
   ld a,b                      ; offset
   ret c

   call get_buf
   ld e,a
   ld d,0
   add hl,de
   ld a,(hl)

   push af
   call get_rwptr
   call inc_dehl
   call set_rwptr
   pop af
   or a
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; WRITE  HL'=buf BC'=n HL=n  -> HL=written
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

file_write:
   exx
   ld de,0                     ; count

wr_loop:
   ld a,b
   or c
   jr z, wr_done

   ld a,(hl)
   push bc
   push de
   push hl
   call write_byte
   pop hl
   pop de
   pop bc
   jr c, wr_fail

   inc hl
   inc de
   dec bc
   jr wr_loop

wr_fail:
   ld a,d
   or e
   jr nz, wr_done
   scf
   push de
   exx
   pop hl
   ret

wr_done:
   push de
   exx
   pop hl
   or a
   ret

write_byte:
   ; a = byte
   ld c,a                      ; c = data (must survive get_rwptr)
   push bc                     ; save data in C
   call get_rwptr              ; destroys bc
   pop bc                      ; restore data in C
   ld a,l
   and 0x7f
   ld b,a                      ; b = sector offset
   push bc                     ; b=off, c=byte
   call shr7
   ld a,1                      ; write-fill mode
   call cache_get
   pop bc
   ret c

   call get_buf
   ld e,b
   ld d,0
   add hl,de
   ld (hl),c
   call get_dirty
   ld (hl),1

   call get_rwptr
   call inc_dehl
   call set_rwptr
   or a
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SEEK  C=whence  DEHL'=offset  -> DEHL=newpos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

file_seek:
   ; c = whence — must survive flush_raw (which uses bc)
   push bc
   call flush_raw
   pop bc

   ld a,c
   cp STDIO_SEEK_SET
   jr z, sk_set
   cp STDIO_SEEK_CUR
   jr z, sk_cur
   cp STDIO_SEEK_END
   jr z, sk_end
   scf
   ret

sk_set:
   exx
   call set_rwptr
   call get_rwptr
   or a
   ret

sk_cur:
   call get_rwptr
   ld (seek_tmp),hl
   ld (seek_tmp+2),de
   exx
   ; dehl = offset (signed for CUR — treat as unsigned add for pilot)
   ld bc,(seek_tmp)
   add hl,bc
   ex de,hl
   ld bc,(seek_tmp+2)
   adc hl,bc
   ex de,hl
   call set_rwptr
   call get_rwptr
   or a
   ret

sk_end:
   call get_fcb
   push hl
   call swapuid_set
   pop hl
   push hl
   ex de,hl
   ld c,__CPM_CFS
   call asm_cpm_bdos
   pop hl
   call swapuid_restore

   call get_fcb
   ld de,FCB_RANREC
   add hl,de
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   ld l,e
   ld h,d
   ld e,a
   ld d,0                      ; dehl = record count
   call shl7                   ; * 128 = file size
   ld (seek_tmp),hl
   ld (seek_tmp+2),de

   exx
   ; add offset
   ld bc,(seek_tmp)
   add hl,bc
   ex de,hl
   ld bc,(seek_tmp+2)
   adc hl,bc
   ex de,hl
   call set_rwptr
   call get_rwptr
   or a
   ret
