#include <conio.h>
#include <games.h>
#include <arch/nabu/paddles.h>
#include <font/font.h>
#include <sys/ioctl.h>

#define MODE_TEXT 0

// decode and print joystick byte
void printJoystick(uint8_t b)
{
	char state[6];

	state[0] = '.';
	state[1] = '.';
	state[2] = '.';
	state[3] = '.';
	state[4] = '.';
	state[5] = 0;

	if (b & MOVE_LEFT) {
		state[0] = 'L';
	}
	if (b & MOVE_DOWN) {
		state[1] = 'D';
	}
	if (b & MOVE_RIGHT) {
		state[2] = 'R';
	}
	if (b & MOVE_UP) {
		state[3] = 'U';
	}
	if (b & MOVE_FIRE) {
		state[4] = 'F';
	}
	printf("%s", state);
}

void main() {

	uint8_t mode = MODE_TEXT;
	void *font_ptr = &font_8x8_msx_system;

	console_ioctl(IOCTL_GENCON_SET_MODE, &mode);
	console_ioctl(IOCTL_GENCON_SET_FONT32, &font_ptr);

	// print title
	gotoxy(14, 0);
	printf("Input Tester");

	// print Paddle 1 header
	gotoxy(5, 5);
	printf("Paddle 1: ");

	// print Paddle 2 header
	gotoxy(23, 5);
	printf("Paddle 2: ");

	// print Paddle 3 header
	gotoxy(5, 10);
	printf("Paddle 3: ");

	// print Paddle 4 header
	gotoxy(23, 10);
	printf("Paddle 4: ");

	// print Joystick 1 header
	gotoxy(2, 15);
	printf("Joystick 1: ");

	// print Joystick 2 header
	gotoxy(21, 15);
	printf("Joystick 2: ");

	// print Keyboard header
	gotoxy(14, 20);
	printf("Keyboard: 00");

	while (1) {
		// read paddle 1 value
		uint8_t p1 = paddle(PADDLE_1);
		// read paddle 2 value
		uint8_t p2 = paddle(PADDLE_2);
		// read paddle 3 value
		uint8_t p3 = paddle(PADDLE_3);
		// read paddle 4 value
		uint8_t p4 = paddle(PADDLE_4);

		// read  joystick 1 status
		uint8_t j1 = joystick(1);
		// read  joystick 2 status
		uint8_t j2 = joystick(2);

		uint8_t key = getk();

		// display paddle 1 value
		gotoxy(15, 5);
		printf("%02X", p1);
		// display paddle 2 value
		gotoxy(33, 5);
		printf("%02X", p2);
		// display paddle 3 value
		gotoxy(15, 10);
		printf("%02X", p3);
		// display paddle 4 value
		gotoxy(33, 10);
		printf("%02X", p4);
		// display joystick 1 state
		gotoxy(14, 15);
		printJoystick(j1);
		// display joystick 2 state
		gotoxy(33, 15);
		printJoystick(j2);

		// display last keyboard keycode
		if (key != 0) {
			gotoxy(24, 20);
			printf("%02X", key);
		}
	}
}
