/*

	Z88DK base graphics libraries examples
	Colour version
	
	A classic 2 players game, the opponents must trap each other.
	
	Build options:
	-DJOYSTICK_DIALOG	- let the players choose their controllers
	-DPSG -lm			- PSG sound support (e.g. ZON-X on the ZX81, maths library is required)
	
	
	SPEED must be adjusted according to the CPU speed (e.g. must be around 500 on a ZX81)
	
	zcc +trs80 -subtype=eg2000disk -lgfxeg2000 -create-app -DSPEED=1500 -DJOYSTICK_DIALOG -DDEFINE_JOYSTICK_TYPE csnakes.c	
	
*/

#include <games.h>
#include <graphics.h>

#ifdef JOYSTICK_DIALOG
#include <stdio.h>
#endif

#ifdef PSG
#include <psg.h>
#endif

struct snake {
    int joystick;
    int direction;
    int x;
    int y;
    int x_incr;
    int y_incr;
    int c;
};

struct snake p1;
struct snake p2;

int x, y;

void crash(int a, int b)
{
    for (y = 0; y < 30; y++) {
		
        cplot(a + 1, b + 1, y & 3);
        cplot(a - 1, b - 1, y & 3);
        cplot(a - 1, b + 1, y & 3);
        cplot(a + 1, b - 1, y & 3);
		
        for (x = 0; x < SPEED * 2; x++) {
        }
    }
}

int move_snake(struct snake* p)
{

    if (p->direction & MOVE_RIGHT) {
        p->x_incr = 1;
        p->y_incr = 0;
    }
    if (p->direction & MOVE_LEFT) {
        p->x_incr = -1;
        p->y_incr = 0;
    }
    if (p->direction & MOVE_DOWN) {
        p->y_incr = 1;
        p->x_incr = 0;
    }
    if (p->direction & MOVE_UP) {
        p->y_incr = -1;
        p->x_incr = 0;
    }

    p->x += p->x_incr;
    p->y += p->y_incr;

    if (cpoint(p->x, p->y)!=0)
        return (0);
    cplot(p->x, p->y, p->c);

    p->direction = joystick(p->joystick);

    for (x = 0; x < SPEED; x++) {
    };
    return (1);
}

int play_game()
{
    while (1) {
        if (move_snake(&p1) == 0) {
#ifdef PSG
            psg_envelope(envD, psgT(10), chanAll); // set a fading volume envelope on all channels
#endif
            crash(p1->x - p1->x_incr, p1->y - p1->y_incr);
            return (1);
        }

#ifdef PSG
        psg_tone(1, psgT(p1->x + p1->y + 10 * (15 + 2 * p1->x_incr + p1->y_incr)));
#endif

        if (move_snake(&p2) == 0) {
#ifdef PSG
            psg_envelope(envD, psgT(10), chanAll); // set a fading volume envelope on all channels
#endif
            crash(p2->x - p2->x_incr, p2->y - p2->y_incr);
            return (2);
        }

#ifdef PSG
        psg_tone(2, psgT(p2->x + p2->y + 12 * (15 + 2 * p2->x_incr + p2->y_incr)));
#endif
    }
}

main()
{

#ifdef JOYSTICK_DIALOG


    printf("%c\nLeft player controller:\n\n", 12);

    for (x = 0; x != GAME_DEVICES; x++)
        printf("%u - %s\n", x + 1, joystick_type[x]);

    p1.joystick = 0;
    while ((p1.joystick < 1) || (p1.joystick > GAME_DEVICES))
        p1.joystick = getk() - 48;

    while (getk())
        ;

    printf("%c\nRight player controller:\n\n", 12);

    for (x = 0; x != GAME_DEVICES; x++)
        printf("%u - %s\n", x + 1, joystick_type[x]);

    p2.joystick = 0;
    while ((p2.joystick < 1) || (p2.joystick > GAME_DEVICES))
        p2.joystick = getk() - 48;

#else
	
    p1.joystick = 1;
    p2.joystick = 2;

#endif

    while (1) {
        cclg();
		

#ifdef PSG
        psg_init();
        psg_volume(1, 10);
        psg_volume(2, 10);
#endif

        for (x = 0; x <= 127; x++) {
            cplot(x, 0, 2);
            cplot(x, 63, 2);
        }
        for (y = 0; y <= 63; y++) {
            cplot(0, y, 2);
            cplot(127, y, 2);
        }

        p1.x = 127 / 5;
        p1.y = 63 / 5;
        p1.direction = MOVE_LEFT;
        p1.x_incr = -1;
        p1.y_incr = 0;
        p1.c = 1;

        p2.x = 127 - 127 / 5;
        p2.y = 63 - 63 / 5;
        p2.direction = MOVE_RIGHT;
        p2.x_incr = 1;
        p2.y_incr = 0;
		p2.c = 3;
		
        play_game();
    }
}
