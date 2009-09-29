/*
 *  z88dk z80 multi-task library
 *
 *  $Id: roundrobin_scheduler.c,v 1.2 2009-09-29 22:20:21 dom Exp $
 *
 *  A simple roundrobin scheduler
 */

#include <threading/preempt.h>

scheduler_t *roundrobin_scheduler()
{
#asm
	ld	hl,roundrobin
#endasm
}

     
#asm

	LIB	get_task

; Jump table for the roundrobin scheduler
.roundrobin
        jp      roundrobin_task_schedule
        jp      roundrobin_task_init
        jp      roundrobin_schedule_init
        
        
; Initialise threadbase for the roundrobin scheduler
.roundrobin_schedule_init
        xor     a                       ; Start from task 0
        ret

; Initialise a roundrobin task
;
; Entry:        ix = task
;                a = task number
.roundrobin_task_init
        ld      a,(ix + thread_priority)
        ld      (ix + thread_extra),a
        ret




; Entry:        ix = current task
; Exit:         ix = new task to run        
.roundrobin_task_schedule
        ld      a,(ix + thread_pid)
        ld      c,a
.roundrobin_loop
        inc     a
        and     MAX_THREADS - 1
        cp      c
        jp      z,roundrobin_noneready          ; We have looped round, nothing ready to run
        call    get_task                        ; Get the task table for the thread
        bit     7,(ix + thread_flags)	        ; No task there
        jr      z,roundrobin_loop
        bit     0,(ix + thread_flags)           ; Check if sleeping
        jr      nz,roundrobin_loop               ; It was sleeping
        dec     (ix + thread_extra)             ; Decrement the counter
        jp      nz,roundrobin_loop              ; Not ready to run yet
        ld      a,(ix + thread_priority)        ; Reset the run counter
        ld      (ix + thread_extra),a
        ret                                     ; Exit with a ready task
.roundrobin_noneready
        xor     a                             ; Task zero is the standard task i.e. main() so runs whenever
        call    get_task
        ld      a,(ix + thread_priority)        ; Reset the run counter
        ld      (ix + thread_extra),a
        ret
#endasm
        
