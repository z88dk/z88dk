/*
 * Extra MSG trampoline for ZSock
 */

#define STDIO_ASM
#include <stdio.h>
#include <net/socket.h>
#include <net/misc.h>
#include "netstdio.h"

#asm
	SECTION code_clib
	PUBLIC	_zsock_trampoline
_zsock_trampoline:

	cp	__STDIO_MSG_GETC
	jr	z,handle_getc
	cp	__STDIO_MSG_PUTC
	jr	z,handle_putc
	cp	__STDIO_MSG_READ
	jr	z,handle_read
	cp	__STDIO_MSG_WRITE
	jr	z,handle_write
	cp	__STDIO_MSG_FLUSH
	jr	z,handle_flush
	cp	__STDIO_MSG_CLOSE
	jr	z,handle_close
	scf	; error
	ret

; ix = fp
; Exit: hl = result
;      carry set as appropriate
handle_getc:
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc+1)
	push	hl
	call	fgetc_net
	pop	bc
	ret

; Entry: ix = fp
;	 bc = character
; Exit: hl = result
handle_putc:
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc+1)
        push    hl
	push	bc	
	call	fputc_net
	pop	bc
        pop     bc
	ret


; ix = fp
; de = buf, 
; bc = length
handle_read:
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc+1)
	push	hl
	push	de
	push	bc
	call	sock_read
	pop	bc	
	pop	bc
	pop	bc
	ret

; ix = fp
; de = buf, 
; bc = length
handle_write:
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc+1)
	push	hl
	push	de
	push	bc
	call	sock_write
	pop	bc	
	pop	bc
	pop	bc
	ret


handle_flush:
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc+1)
	push	ix
	push	hl
	call	sock_flush
	pop	hl
	pop	ix
	ld	hl,1
	ret	c	;flush failed
	dec	hl
	ret	

; Entry:
;	ix = fp
; Exit:
;	carry = error
;	hl = result
handle_close:
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc+1)
	push	ix
	push	hl
	call	sock_close
	call	sock_waitclose
	call	sock_shutdown
	pop	bc
	pop	ix
	ld	hl,0
	and	a
	ret




#endasm


