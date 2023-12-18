#ifndef ARCH_NABU_PADDLES_H
#define ARCH_NABU_PADDLES_H

#include <stdint.h>
#include <sys/compiler.h>


#define PADDLE_1   1
#define PADDLE_2   2
#define PADDLE_3   3
#define PADDLE_4   4
#define PADDLE_5   5
#define PADDLE_6   6
#define PADDLE_7   7
#define PADDLE_8   8

/* Paddle function */
extern uint8_t __LIB__  paddle(uint8_t game_device) __z88dk_fastcall;

#endif

