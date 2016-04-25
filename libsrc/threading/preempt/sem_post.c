/*
 *  z88dk z80 multi-task library
 *
 * $Id: sem_post.c,v 1.3 2016-04-25 17:09:41 dom Exp $
 */

#include <threading/semaphore.h>

int sem_post(sem_t *sem)
{
#asm
	di
	pop	hl
	pop	de
	push	de
	push	hl
	push	ix

	push	de
	pop	ix
	ld	l,(ix+semaphore_value)
	ld	h,(ix+semaphore_value + 1)
	inc	hl		; TODO: overflow
	ld	(ix+semaphore_value),l
	ld	(ix+semaphore_value + 1),h
	ld	a,h
	or	l
	jr	nz,sem_out
; Weve reach 0, lets wake up one of the threads
	ld	a,(ix + semaphore_waiters_num)
	and	a
	jr	z,sem_out		; No waiters
	dec	(ix + semaphore_waiters_num)
	ld	e,(ix + semaphore_waiters)
	ld	d,(ix + semaphore_waiters + 1)
	push	de		; This is the first waiting thread
	push	ix
	pop	hl		; Copy the queue down
	ld	de,semaphore_waiters + 2
	add	hl,de
	ld	d,h
	ld	e,l
	dec	de
	dec	de
	ld	bc,#(MAX_THREADS * 2) - 2
	ldir
	pop	ix		; Now we have the thread to wake up ready
	res	0,(ix+ thread_flags)	; Wake the thread
.sem_out
	ld	hl,0
	ei
        pop     ix
#endasm
}
