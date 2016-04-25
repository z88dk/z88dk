/*
 *  z88dk z80 multi-task library
 *
 * $Id: sem_post.c,v 1.5 2016-04-25 20:17:04 dom Exp $
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
;	bit 	7,h		;greater than or equal to 0
;	jr	nz,sem_out
;	ld	a,h
;	or	l
;	jr	z,sem_out
	; Wake up a waiter since we have incremented the semaphore
	ld	a,(ix + semaphore_waiters_num)
	and	a
	jr	z,sem_out		; No waiters
	push	ix
	pop	hl
	ld	de,#semaphore_waiters
	add	hl,de
	ld	b,(ix+semaphore_waiters_num)
	ld	(ix+semaphore_waiters_num),0
.wake_loop
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	push	de
	pop	ix
	res	0,(ix+ thread_flags)	; Wake the thread
	djnz	wake_loop
.sem_out
	ld	hl,0
	ei
        pop     ix
#endasm
}
