#include <stdlib.h>
#include <sms.h>

unsigned char pal1[] = {0x00, 0x01, 0x02, 0x03, 0x10, 0x20, 0x30, 0x2B,
				0x14, 0x24, 0x39, 0x0F, 0x00, 0x15, 0x2A, 0x3F};

unsigned char pal2[] = {0x00, 0x01, 0x02, 0x03, 0x10, 0x20, 0x30, 0x2B,
				0x15, 0x35, 0x1D, 0x3D, 0x00, 0x15, 0x2A, 0x3F};

unsigned int bkg_bottom[] = {0x000F, 0x000F, 0x000F, 0x0010, 0x000F, 0x000F, 0x000F, 0x0010,
                             0x000F, 0x000F, 0x0010, 0x000F, 0x000F, 0x000F, 0x0010, 0x000F,
                             0x000F, 0x0010, 0x000F, 0x000F, 0x000F, 0x0010, 0x000F, 0x000F,
                             0x0010, 0x000F, 0x000F, 0x000F, 0x0010, 0x000F, 0x000F, 0x000F,};

unsigned int bkg_top1[] = {0x0014, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
                           0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
                           0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
                           0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0015,};

unsigned int bkg_top2[] = {0x0011, 0x0013, 0x0013, 0x0012, 0x0013, 0x0013, 0x0013, 0x0012,
                           0x0013, 0x0013, 0x0012, 0x0013, 0x0013, 0x0013, 0x0012, 0x0013,
                           0x0013, 0x0012, 0x0013, 0x0013, 0x0013, 0x0012, 0x0013, 0x0013,
                           0x0012, 0x0013, 0x0013, 0x0013, 0x0012, 0x0013, 0x0013, 0x0011,};

unsigned int lplayer_icons[] = {0x017, 0x019};
unsigned int rplayer_icons[] = {0x018, 0x01A, 0x01B, 0x01C};
unsigned int paddle_icons[] = {0x01D, 0x01E, 0x01F};
unsigned int spin_icons[] = {0x021, 0x020};

extern unsigned char pong_graphics[];

typedef struct {
	int x;
	int y;
	int size;
	int height;
	int controlled_by;
	int base_spr;
	int base_tile;
	int spd_x;
	int spd_y;
	int top_spd;
	int accel;
	int friction;
} paddle_rec;

typedef struct {
	int x;
	int y;
	int base_spr;
	int base_tile;
	int spd_x;
	int spd_y;
	int base_spd;
	int top_spd;
	int spin;
	int spin_friction;
} ball_rec;

typedef struct {
	int top;
	int bottom;
	int left;
	int right;
	int	score0;
	int score1;
	int left_player;
	int right_player;
	int paddle_mode;
	int actual_paddle_count;
	int spin_on;
} playfield_rec;

int sig_shr(int number, int shift) {
	if (number < 0) {
		return -((-number) >> shift);
	} else {
		return number >> shift;
	}
}

int wait_joy1_release() {
	while (read_joypad1()) {
		wait_vblank_noint();
	}
}

void draw_score_digits(int x, int y, int n) {
	unsigned int buffer[2];
	buffer[0] = (n / 10) + 1;
	buffer[1] = (n % 10) + 1;
	set_bkg_map(buffer, x, y, 2, 1);
}

void draw_option_panel(int x, int y, playfield_rec *playfield) {
	unsigned int buffer[4];
	unsigned int *p;
	p = buffer;
	*p = lplayer_icons[playfield->left_player];
	p++;
	*p = rplayer_icons[playfield->right_player];
	p++;
	*p = paddle_icons[playfield->paddle_mode];
	p++;
	*p = spin_icons[playfield->spin_on];
	set_bkg_map(buffer, x, y, 4, 1);
}

void draw_score(playfield_rec *playfield) {
	draw_score_digits(4, 0, playfield->score0);
	draw_score_digits(26, 0, playfield->score1);
	draw_option_panel(14, 0, playfield);
}

void draw_bkg() {
	set_bkg_map(bkg_top1, 0, 0, 32, 1);
	set_bkg_map(bkg_top2, 0, 1, 32, 1);
	set_bkg_map(bkg_bottom, 0, 23, 32, 1);
}

void draw_paddle(paddle_rec *paddle) {
	int x = (paddle->x >> 4);
	int y = (paddle->y >> 4);
	int spr = paddle->base_spr;
	int tile = paddle->base_tile;
	int i;

	set_sprite(spr, x, y, tile);
	y += 8; spr++; tile++;
	for (i = paddle->size; i; i--, y += 8, spr++) {
		set_sprite(spr, x, y, tile);
	}
	tile++;
	set_sprite(spr, x, y, tile);
}

void draw_paddles(paddle_rec *paddles, int count) {
	for (; count; count--, paddles++) {
		draw_paddle(paddles);
	}
}

void handle_paddle_joypad(int joy, paddle_rec *paddle) {
	if (joy & JOY_UP) {
		paddle->spd_y -= paddle->accel;
	}
	if (joy & JOY_DOWN) {
		paddle->spd_y += paddle->accel;
	}
}

void handle_paddle_joypad_lr(int joy, paddle_rec *paddle) {
	if (joy & JOY_LEFT) {
		paddle->spd_y -= paddle->accel;
	}
	if (joy & JOY_RIGHT) {
		paddle->spd_y += paddle->accel;
	}
}

void handle_paddle_ai(paddle_rec *paddle, ball_rec *ball) {
	int h = paddle->height >> 1;
	int	y = paddle->y + h;

	if (ball->spd_x < 0) {
		return;
	}

	if (y > ball->y) {
		paddle->spd_y -= paddle->accel;
	} else if (y < ball->y) {
		paddle->spd_y += paddle->accel;
	}
}

void handle_paddle_physics(paddle_rec *paddle, playfield_rec *playfield) {
	paddle->x += paddle->spd_x;
	paddle->y += paddle->spd_y;

	if (paddle->spd_y < -paddle->top_spd) {
		paddle->spd_y = -paddle->top_spd;
	} else if (paddle->spd_y > paddle->top_spd) {
		paddle->spd_y = paddle->top_spd;
	}

/*	if (paddle->x < playfield->left) {
		paddle->x = playfield->left;
		paddle->spd_x = -paddle->spd_x;
	}
	if (paddle->x > playfield->right-8) {
		paddle->x = playfield->right-8;
		paddle->spd_x = -paddle->spd_x;
	} */

	if (paddle->y < playfield->top) {
		paddle->y = playfield->top;
		paddle->spd_y = -paddle->spd_y;
	}
	if (paddle->y > playfield->bottom-paddle->height) {
		paddle->y = playfield->bottom-paddle->height;
		paddle->spd_y = -paddle->spd_y;
	}

/*	if (paddle->spd_x > 0) {
		if (paddle->spd_x > paddle->friction) {
			paddle->spd_x -= paddle->friction;
		} else {
			paddle->spd_x = 0;
		}
	} else {
		if (paddle->spd_x < -paddle->friction) {
			paddle->spd_x += paddle->friction;
		} else {
			paddle->spd_x = 0;
		}
	}*/

	if (paddle->spd_y > 0) {
		if (paddle->spd_y > paddle->friction) {
			paddle->spd_y -= paddle->friction;
		} else {
			paddle->spd_y = 0;
		}
	} else {
		if (paddle->spd_y < -paddle->friction) {
			paddle->spd_y += paddle->friction;
		} else {
			paddle->spd_y = 0;
		}
	}
}

void draw_ball(ball_rec *ball) {
	int x = (ball->x >> 4);
	int y = (ball->y >> 4);
	int spr = ball->base_spr;
	int tile = ball->base_tile;

	set_sprite(spr, x, y, tile);
}

void deploy_ball(ball_rec *ball) {
	ball->x = 128 << 4;
	ball->y = 32 << 4;
	ball->base_spr = 12;
	ball->base_tile = 14;
	if (rand() & 0x01) {
		ball->spd_x = 0x18;
	} else {
		ball->spd_x = -0x18;
	}
	ball->spd_y = (rand() & 0x3F) - 0x20;
	ball->base_spd = 0x20;
	ball->top_spd = 0x60;
	ball->spin = 0;
	ball->spin_friction = 0x01;
}

void handle_ball_physics(ball_rec *ball, playfield_rec *playfield, paddle_rec paddles[], int paddle_count) {
	int i;
	int collided;
	paddle_rec *paddle;

	ball->x += ball->spd_x;
	ball->y += ball->spd_y;

	ball->spd_y -= sig_shr(ball->spin, 3);
	if (ball->spin > 0) {
		if (ball->spin > ball->spin_friction) {
			ball->spin -= ball->spin_friction;
		} else {
			ball->spin = 0;
		}
	} else {
		if (ball->spin < -ball->spin_friction) {
			ball->spin += ball->spin_friction;
		} else {
			ball->spin = 0;
		}
	}

	if (ball->spd_x < 0) {
		if (ball->spd_x < -ball->top_spd) {
			ball->spd_x = -ball->top_spd;
		}
	} else {
		if (ball->spd_x > ball->top_spd) {
			ball->spd_x = ball->top_spd;
		}
	}

	if (ball->x < playfield->left) {
		ball->x = playfield->left;
		ball->spd_x = -ball->spd_x;
		playfield->score0++;
		deploy_ball(ball);
		draw_score(playfield);
	}
	if (ball->x > playfield->right-8) {
		ball->x = playfield->right-8;
		ball->spd_x = -ball->spd_x;
		playfield->score1++;
		deploy_ball(ball);
		draw_score(playfield);
	}

	if (ball->spd_y < 0) {
		if (ball->spd_y < -ball->top_spd) {
			ball->spd_y = -ball->top_spd;
		}
	} else {
		if (ball->spd_y > ball->top_spd) {
			ball->spd_y = ball->top_spd;
		}
	}

	if (ball->y < playfield->top) {
		ball->y = playfield->top;
		ball->spd_y = -ball->spd_y;
	}
	if (ball->y > playfield->bottom-0x80) {
		ball->y = playfield->bottom-0x80;
		ball->spd_y = -ball->spd_y;
	}

	for (i = paddle_count, paddle = paddles; i; i--, paddle++) {
		if ((ball->y > paddle->y - 0x80) && (ball->y < paddle->y + paddle->height)) {
			collided = 0;
			if (ball->spd_x < 0) {
				if ((ball->x < paddle->x + 0x80) && (ball->x > paddle->x)) {
					ball->x = paddle->x + 0x80;
					ball->spd_x = -ball->spd_x;
					ball->spd_x += 0x02;
					ball->spin = paddle->spd_y/* + sig_shr(paddle->spd_y, 1)*/;
					collided = 1;
				}
			} else {
				if ((ball->x < paddle->x) && (ball->x > paddle->x - 0x80)) {
					ball->x = paddle->x - 0x80;
					ball->spd_x = -ball->spd_x;
					ball->spd_x -= 0x02;
					ball->spin = paddle->spd_y/* + sig_shr(paddle->spd_y, 1)*/;
					collided = 1;
				}
			}
			if (collided) {
				if (ball->y < paddle->y) {
					ball->spd_y -= 0x60;
				} else if (ball->y > paddle->y + paddle->height - 0x80) {
					ball->spd_y += 0x60;
				}

				if (!playfield->spin_on) {
					ball->spin = 0;
				}
			}
		}
	}
}

void setup_paddles(paddle_rec *paddles, playfield_rec *playfield) {
	paddle_rec *paddle;
	int x, xinc;
	int i;
	int half_paddle_count;
	int base_spr = 0;
	int base_tile = 11;
	int paddle_size = 2;
	int max_speed = 0x60;
	int controlled_by = 0;

	playfield->actual_paddle_count = 2;
	if (playfield->paddle_mode == 1) {
		playfield->actual_paddle_count = 4;
	}
	if (playfield->left_player == 1) {
		playfield->actual_paddle_count <<= 1;
	}
	half_paddle_count = playfield->actual_paddle_count >> 1;

	if (playfield->paddle_mode == 2) {
		paddle_size = 3;
	}

	for (i = 0, paddle = paddles; i != playfield->actual_paddle_count; i++, paddle++) {
		paddle->y = 80 << 4;
		paddle->size = paddle_size;
		paddle->height = (paddle->size + 2) << 7;
		paddle->base_spr = base_spr;
		paddle->base_tile = base_tile;
		paddle->spd_x = 0;
		paddle->spd_y = 0;
		paddle->top_spd = max_speed;
		paddle->accel = 0x0E;
		paddle->friction = 0x06;

		base_spr += paddle_size+2;
	}

	xinc = 32;
	if (half_paddle_count > 2) {
		xinc = 16;
	}
	xinc <<= 4;

	x = 8 << 4;
	controlled_by = 0;
	for (i = 0, paddle = paddles; i != half_paddle_count; i++, paddle++) {
		paddle->x = x;
		paddle->controlled_by = controlled_by;

		x += xinc;
		if (playfield->left_player == 1) {
			controlled_by++;
		} else {
			controlled_by = (controlled_by + 2) 0x03;
		}
	}

	controlled_by = 4;
	switch (playfield->right_player) {
		case 0:
			controlled_by = 1;
		break;

		case 1:
			max_speed = 0x40;
		break;

		case 2:
			max_speed = 0x80;
		break;
	}

	x = 240 << 4;
	for (i = 0; i != half_paddle_count; i++, paddle++) {
		paddle->x = x;
		paddle->controlled_by = controlled_by;
		paddle->top_spd = max_speed;

		x -= xinc;
		if (playfield->left_player == 0) {
			controlled_by = (controlled_by + 2) 0x03;
		}
	}
}

void select_options(paddle_rec *paddles, playfield_rec *playfield) {
	int done;
	int joy1;
	int incr, lim;
	int col = 0;
	int blink = 0;

	done = 0;
	while(!done) {
		joy1 = read_joypad1();
		incr = 0;
		if (joy1 & (JOY_FIREA | JOY_FIREB)) {
			done = 1;
		} else if (joy1 & JOY_LEFT) {
			col--;
		} else if (joy1 & JOY_RIGHT) {
			col++;
		} else if (joy1 & JOY_UP) {
			incr = 1;
		} else if (joy1 & JOY_DOWN) {
			incr = -1;
		}

		if (incr != 0) {
			switch (col) {
				case 0:
					playfield->left_player += incr;
					playfield->left_player &= 0x01;
				break;

				case 1:
					playfield->right_player += incr;
					playfield->right_player &= 0x03;
				break;

				case 2:
					playfield->paddle_mode += incr;
					if (playfield->paddle_mode < 0) {
						playfield->paddle_mode = 2;
					} else if (playfield->paddle_mode > 2) {
						playfield->paddle_mode = 0;
					}
				break;

				case 3:
					playfield->spin_on += incr;
					playfield->spin_on &= 0x01;
				break;
			}
			draw_score(playfield);
			setup_paddles(paddles, playfield);
			draw_paddles(paddles, playfield.actual_paddle_count);
		}

		col &= 0x03;

		wait_vblank_noint();
		if (blink & 0x10) {
			set_sprite(63, 0, -16, 1);
		} else {
			set_sprite(63, (col + 14) << 3, 0, 0x16);
		}

		if (joy1) {
			wait_joy1_release();
		}

		blink++;
	}
	set_sprite(63, 0, -16, 1);
}

void main() {
	int joy1, joy2;
	int i;
	playfield_rec playfield;
	paddle_rec paddles[8], *paddle;
	ball_rec ball;

	playfield.top = 16 << 4;
	playfield.bottom = 184 << 4;
	playfield.left = 0 << 4;
	playfield.right = 255 << 4;
	playfield.score0 = 0;
	playfield.score1 = 0;
	playfield.left_player = 0;
	playfield.right_player = 2;
	playfield.paddle_mode = 0;
	playfield.actual_paddle_count = 1;
	playfield.spin_on = 1;

	setup_paddles(paddles, &playfield);

	set_vdp_reg(VDP_REG_FLAGS1, VDP_REG_FLAGS1_SCREEN);
	load_tiles(pong_graphics, 1, 64, 4);
	load_palette(pal1, 0, 16);
	load_palette(pal2, 16, 16);

	for (i = 0; i != 64; i++) {
		set_sprite(i, 0, -16, 0);
	}

	while (1) {
		draw_bkg();
		draw_score(&playfield);
		draw_paddles(paddles, playfield.actual_paddle_count);

		select_options(paddles, &playfield);

		deploy_ball(&ball);
		for (;;) {
/*			joy1 = read_joypad1();
			handle_paddle_joypad(joy1, paddle);
			handle_paddle_physics(paddle, &playfield);

			paddle++;
			joy2 = read_joypad2();
	//		handle_paddle_joypad(joy2, paddle);
			handle_paddle_ai(paddle, &ball);
			handle_paddle_physics(paddle, &playfield);*/
			joy1 = read_joypad1();
			joy2 = read_joypad2();

			for (i = 0, paddle = paddles; i != playfield.actual_paddle_count; i++, paddle++) {
				switch (paddle->controlled_by) {
					case 0:
						handle_paddle_joypad(joy1, paddle);
					break;

					case 1:
						handle_paddle_joypad(joy2, paddle);
					break;

					case 2:
						handle_paddle_joypad_lr(joy1, paddle);
					break;

					case 3:
						handle_paddle_joypad_lr(joy2, paddle);
					break;

					default:
						handle_paddle_ai(paddle, &ball);
				}
			}

			handle_ball_physics(&ball, &playfield, paddles, playfield.actual_paddle_count);

			for (i = 0, paddle = paddles; i != playfield.actual_paddle_count; i++, paddle++) {
				handle_paddle_physics(paddle, &playfield);
			}

			wait_vblank_noint();
			draw_paddles(paddles, playfield.actual_paddle_count);
/*			for (i = 0, paddle = paddles; i != playfield.actual_paddle_count; i++, paddle++) {
				draw_paddle(paddle);
			}*/
			draw_ball(&ball);
		}
	}
}
