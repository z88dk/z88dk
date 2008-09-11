; int __CALLEE__ poll_callee(struct pollfd *fds, uint nfds, uint timeout)
; 06.2008 aralbrec

XLIB poll_callee
XDEF ASMDISP_POLL_CALLEE

LIB fd_common1, l_jpix, stdio_error_einval_mc

INCLUDE "stdio.def"

; struct pollfd {
;    int  fd;
;    char events;
;    char revents;             // bit 7 = POLLNSUP, bit 6 = POLLNVAL, bit 5 = OOB_ERR, bit 4 = ERR
;                              // bit 3 = OOB_WRITE, bit 2 = WRITE, bit 1 = OOB_READ, bit 0 = READ
; };
;
; timeout is ignored in this implementation
; poll always immediately returns after polling all fds

.poll_callee

   pop hl
   pop bc
   pop bc
   ex (sp),hl

.asmentry

   ; enter : hl = struct pollfd *fds
   ;         bc = uint nfds
   ; exit  : hl = number ready fds, carry reset
   ;         hl = -1, carry set if nfds too large
   
   ld a,c                      ; check if nfds > max number of open files
   cp MAXFILES
   jp nc, stdio_error_einval_mc
   
   or a                        ; check if struct pollfd is empty
   jp z, stdio_error_einval_mc
   
   ld b,c                      ; b = nfds
   ld c,0                      ; c = number of ready fds
   
.loop

   push bc                     ; save b = num fds, c = ready fds

   ld c,(hl)                   ; e = fd
   inc hl
   inc hl
   ld a,(hl)
   and $3f
   ld b,a                      ; b = events to test
   inc hl

   push hl                     ; save pollfd.revents
   
   ld l,c
   call fd_common1             ; ix = fdstruct for fd
   jr c, e_ebadf                 ; bad fd number
   
   ld c,STDIO_MSG_POLL
   call l_jpix                 ; return carry if poll is unsupported
   jr c, unsupported

.reenter

   pop hl                      ; hl = pollfd.revents

   ld (hl),b
   inc hl                      ; hl = next struct pollfd
   ld a,b
   
   pop bc                      ; b = num fds, c = ready fds
   
   or a
   jr z, fdnotrdy

   inc c

.fdnotrdy

   djnz loop
   
   ld l,c
   ld h,b                      ; hl = num ready fds
   ret

.e_ebadf

   ld b,$40
   jr reenter

.unsupported

   ld b,$80
   jr reenter

defc ASMDISP_POLL_CALLEE = asmentry - poll_callee
