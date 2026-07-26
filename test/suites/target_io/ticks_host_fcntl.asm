; Host file I/O via z88dk-ticks SYSCALL (ED FE).
; Backend for target_io/fcntl_host.c when a target has no host-visible
; disk under ticks (e.g. RC2014 basic — real CF/IDE is not emulated).
;
; Calling convention: sccz80/newlib __stdc (left-to-right):
;   first arg pushed first, so the *last* arg is at sp+2 on entry.
; Works on Z80 and 8085 (no IX).

SECTION code_compiler

PUBLIC host_open, _host_open
PUBLIC host_close, _host_close
PUBLIC host_read, _host_read
PUBLIC host_write, _host_write
PUBLIC host_lseek, _host_lseek
PUBLIC host_creat, _host_creat

defc    CMD_OPENF      = 4
defc    CMD_CLOSEF     = 5
defc    CMD_WRITEBLOCK = 8
defc    CMD_READBLOCK  = 9
defc    CMD_SEEK       = 10

; int host_open(const char *name, int flags, int mode)
; stdc stack: ret, mode, flags, name
host_open:
_host_open:
    ld      hl, 2
    add     hl, sp
    ld      c, (hl)         ; mode lo
    inc     hl
    ld      b, (hl)         ; mode hi
    inc     hl
    ld      e, (hl)         ; flags lo
    inc     hl
    ld      d, (hl)         ; flags hi
    inc     hl
    ld      a, (hl)         ; name lo
    inc     hl
    ld      h, (hl)         ; name hi
    ld      l, a
    ld      a, CMD_OPENF
    call    HOST_SYSCALL
    ret

; int host_creat(const char *name, int mode)
; open(name, O_WRONLY|O_CREAT|O_TRUNC, mode)  flags = 1|1024|512 = 1537
; stdc stack: ret, mode, name
host_creat:
_host_creat:
    ld      hl, 2
    add     hl, sp
    ld      c, (hl)         ; mode lo
    inc     hl
    ld      b, (hl)         ; mode hi
    inc     hl
    ld      a, (hl)         ; name lo
    inc     hl
    ld      h, (hl)
    ld      l, a
    ld      de, 1537        ; O_WRONLY|O_CREAT|O_TRUNC
    ld      a, CMD_OPENF
    call    HOST_SYSCALL
    ret

; int host_close(int fd)
; stdc stack: ret, fd
host_close:
_host_close:
    pop     de              ; ret
    pop     bc              ; fd in c
    push    bc
    push    de
    ld      b, c
    ld      a, CMD_CLOSEF
    call    HOST_SYSCALL
    ret

; ssize_t host_read(int fd, void *buf, size_t len)
; stdc stack: ret, len, buf, fd
; SYSCALL: b=handle, de=addr, hl=length
host_read:
_host_read:
    ld      hl, 2
    add     hl, sp
    ld      e, (hl)         ; len lo → will move to hl later
    inc     hl
    ld      d, (hl)         ; len hi
    inc     hl
    push    de              ; save len
    ld      e, (hl)         ; buf lo
    inc     hl
    ld      d, (hl)         ; buf hi
    inc     hl
    ld      c, (hl)         ; fd lo
    pop     hl              ; length
    ld      b, c            ; handle
    ld      a, CMD_READBLOCK
    call    HOST_SYSCALL
    ret

; ssize_t host_write(int fd, void *buf, size_t len)
; stdc stack: ret, len, buf, fd
host_write:
_host_write:
    ld      hl, 2
    add     hl, sp
    ld      e, (hl)         ; len lo
    inc     hl
    ld      d, (hl)         ; len hi
    inc     hl
    push    de              ; save len
    ld      e, (hl)         ; buf lo
    inc     hl
    ld      d, (hl)         ; buf hi
    inc     hl
    ld      c, (hl)         ; fd lo
    pop     hl              ; length
    ld      b, c            ; handle
    ld      a, CMD_WRITEBLOCK
    call    HOST_SYSCALL
    ret

; long host_lseek(int fd, long posn, int whence)
; stdc stack: ret, whence, posn(4), fd
; SYSCALL: b=handle, c=whence, dehl=offset (de=high16, hl=low16)
host_lseek:
_host_lseek:
    ld      hl, 2
    add     hl, sp
    ld      c, (hl)         ; whence
    inc     hl
    inc     hl
    ld      e, (hl)         ; posn 0-7
    inc     hl
    ld      d, (hl)         ; posn 8-15
    inc     hl
    push    de              ; low16
    ld      e, (hl)         ; posn 16-23
    inc     hl
    ld      d, (hl)         ; posn 24-31
    inc     hl
    ld      b, (hl)         ; fd lo → handle
    pop     hl              ; low16 of offset
    ; de = high16, hl = low16, b = handle, c = whence
    ld      a, CMD_SEEK
    call    HOST_SYSCALL
    ; result: dehl position (sccz80 long)
    ret

HOST_SYSCALL:
    defb    $ED, $FE
    ret
