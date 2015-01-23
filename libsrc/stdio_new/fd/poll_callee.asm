; int __CALLEE__ poll_callee(struct pollfd *fds, uint nfds, uint timeout)
; 06.2008 aralbrec

PUBLIC poll_callee
PUBLIC ASMDISP_POLL_CALLEE

EXTERN stdio_fdcommon1, l_jpix, stdio_error_einval_mc

INCLUDE "../stdio.def"

; struct pollfd {
;    int  fd;
;    char events;
;    char revents;             // bit 7 = POLLNVAL/POLLNSUP, bit 6 = POLLHUP, bit 5 = POLLERR_OOB, bit 4 = POLLERR
;                              // bit 3 = POLLOUT_OOB, bit 2 = POLLOUT, bit 1 = POLLIN_OOB, bit 0 = POLLIN
; };
;
; timeout is ignored in this implementation
; poll always immediately returns after polling all fds once

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
   cp STDIO_NUMFD
   jp nc, stdio_error_einval_mc
   
   or a                        ; check if struct pollfd is empty
   jp z, stdio_error_einval_mc
   
   ld b,c                      ; b = nfds
   ld c,0                      ; c = number of ready fds
   
.loop

   push bc                     ; save b = num fds, c = ready fds

   ld b,(hl)                   ; b = fd
   inc hl
   inc hl
   ld a,(hl)
   or $f0
   ld c,a                      ; c = events to test
   inc hl

   push hl                     ; save pollfd.revents
   
   ld l,b
   call stdio_fdcommon1        ; ix = fdstruct for fd
   jr c, e_ebadf               ; bad fd number
   
   ld a,STDIO_MSG_POLL
   call l_jpix                 ; return carry if poll is unsupported
   jr c, unsupported

.reenter

   pop hl                      ; hl = pollfd.revents

   ld (hl),c
   inc hl                      ; hl = next struct pollfd
   ld a,c
   
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

   bit 7,b                     ; if fd < 0 must return 0 in revents
   ld c,0
   jr nz, reenter
   
.unsupported

   ld c,$80
   jp reenter

defc ASMDISP_POLL_CALLEE = # asmentry - poll_callee
