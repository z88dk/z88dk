
#include <ATJ2085_Ports.h>
#include <drivers/rtc.h>
#include <drivers/rs232.h>

unsigned int rtc_timerticks = 0;

void RTC_ISR( void ) {
#asm
	in	a, (RTC_IRQSTATUS_REG)
	bit	2, a
	jp	nz, rtcisr_alarm
	bit	1, a
	jp	nz, rtcisr_timer
	bit	0, a
	jp	nz, rtcisr_2hz

rtcisr_alarm:
	; Nothing to do with this interrupt yet!
	jp	rtcisr_end

rtcisr_timer:
	ld	hl,(_rtc_timerticks)
	inc	hl
    	ld	(_rtc_timerticks),hl
	; increment rtc_timerticks
;	call	RS232_isr
	jp	rtcisr_end

rtcisr_2hz:
;	bit	4, l
;	jr	z, rtcisr_2hz_clearint
;
;rtcisr_2hz_stopint:
;	; Enable the Xtal Oscillator
;	in	a, (RTC_IRQSTATUS_REG)
;	or	a, RTC_IRQSTATUS_CLK_SOURCE
;	out     (RTC_IRQSTATUS_REG),a
;
;	; Disable the 2Hz interrupt and enable the timer interrupt
;	ld      a, RTC_CONTROL_TIMER_ENABLE
;	out     (RTC_CONTROL_REG),a
;
;rtcisr_2hz_clearint:
;	ld	a, RTC_IRQSTATUS_2HZ_IRQ
;
rtcisr_end:
;	; Reset the IRQ

	in	a,(RTC_IRQSTATUS_REG)
	out	(RTC_IRQSTATUS_REG),a
#endasm
}
