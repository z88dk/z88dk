#include <arch/aquarius.h>
#include <arch/aqplus.h>

#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>
#include <stdlib.h>

#include <games.h>


//#define PERFMON

#define JOYSTICK_NUM 3

// Structure to keep track of position and direction of ball sprites
struct ball {
    uint16_t x;
    uint8_t  y;
    uint16_t dx;
    uint8_t  dy;
};
struct ball balls[16];

void video_wait_line(uint8_t linenr) {			
    IO_VIRQLINE = linenr;
    IO_IRQSTAT  = 2;
    while ((IO_IRQSTAT & 2) == 0) {
    }
}

#define video_wait_eof() video_wait_line(216)

void sprite_move(uint8_t sprite_idx, uint16_t x, uint8_t y) {
    IO_VSPRSEL = sprite_idx;
    IO_VSPRX_L = x & 0xFF;
    IO_VSPRX_H = x >> 8;
    IO_VSPRY   = y;
}

void sprite_init(uint8_t sprite_idx, uint16_t attr_idx) {
    IO_VSPRSEL  = sprite_idx;
    IO_VSPRIDX  = attr_idx & 0xFF;
    IO_VSPRATTR = attr_idx >> 8;
}

// Each ball consist of 4 8x8 sprites
//static inline void setup_ball_sprites(uint8_t ball_idx) {
void setup_ball_sprites(uint8_t ball_idx) {
    uint8_t base = ball_idx * 4;
    sprite_init(base++, 0x8000 | (128 + 227));
    sprite_init(base++, 0x8000 | (128 + 228));
    sprite_init(base++, 0x8000 | (128 + 243));
    sprite_init(base, 0x8000 | (128 + 244));
}

// Update position of the 4 8x8 sprites take make up a ball
//static inline void update_ball_sprites(uint8_t ball_idx) {
void update_ball_sprites(uint8_t ball_idx) {
    struct ball *ballp = &balls[ball_idx];
    uint16_t     x     = ballp->x;
    uint16_t     x8    = ballp->x + 8;
    uint8_t      y     = ballp->y;
    uint8_t      y8    = ballp->y + 8;

    uint8_t base = ball_idx * 4;
    sprite_move(base++, x, y);
    sprite_move(base++, x8, y);
    sprite_move(base++, x, y8);
    sprite_move(base, x8, y8);
}

// Position Sonic character sprite on give position
//static inline void sonic_sprite(uint8_t frame, int x, int y) {
void sonic_sprite(uint8_t frame, int x, int y) {
    uint8_t  base   = 32;
    uint16_t spridx = 128 + 256 + (uint16_t)frame * 16;
    for (uint8_t j = 0; j < 2; j++) {
        int tx = x;
        for (uint8_t i = 0; i < 3; i++) {
            sprite_init(base, 0x8800 | spridx);
            sprite_move(base, tx, y);
            base++;
            spridx += 2;
            tx += 8;
        }
        y += 16;
    }
}

//static uint8_t get_joystick(void) {
uint8_t get_joystick(void) {
#ifndef JOYSTICK_NUM
    IO_PSG1ADDR = 14;
    return IO_PSG1DATA;
#else
	uint8_t joy = joystick( JOYSTICK_NUM );								
	if ( joy & MOVE_LEFT ) {											
		joy = (1 << 1);
    } else if ( joy & MOVE_RIGHT ) {
		joy = (1 << 3);
    } else if ( joy & MOVE_DOWN ) {
		joy = (1 << 2);
    } else if ( joy & MOVE_UP ) {
		joy = (1 << 0);
	}
	return joy;
#endif
}

//static bool init(void) {
bool init(void) {

    // Map video RAM (page 20) to $C000 (bank 3)
    IO_BANK3 = 20;

    uint8_t palette[32];

    // Load in tile data and palette
    puts("Loading tile data...\n");
    int8_t fd = open("assets/tiledata.bin", 0, O_RDONLY);
    if (fd < 0) {
        return false;
    }
    read( fd, (void *)0xC000, 0x4000 );
    read( fd, palette, 32 );
    close( fd );

    // Set palette
    for (uint8_t i = 0; i < 32; i++) {
        IO_VPALSEL  = i;
        IO_VPALDATA = palette[i];
    }
    return true;
}

int main(void) {
    puts("Tiledemo\n");
    if (!init()) {
        puts("error\n");
        return 1;
    }

    // Init balls at random positions
    for (uint8_t i = 0; i < 8; i++) {
        struct ball *ballp = &balls[i];

        ballp->x  = rand() % (320 - 16);
        ballp->y  = rand() % (200 - 16);
        ballp->dx = rand() % 5 - 2;
        ballp->dy = rand() % 5 - 2;
        if (ballp->dx == 0)
            ballp->dx = 1;
        if (ballp->dy == 0)
            ballp->dy = 1;

        setup_ball_sprites(i);
        update_ball_sprites(i);
    }

    {
        uint8_t *tram = (uint8_t *)0x3000;
        uint8_t *cram = (uint8_t *)0x3400;

        // Clear screen
        for (int i = 0; i < 1000; i++) {
            tram[i] = ' ';
            cram[i] = 0x90;
        }

        // Put some text at top of screen
        const char *str = "  Score:xxxxx    Lives:x    Time:xxx";
        const char *ps  = str;
        uint8_t    *pd  = tram + 1;
        while (*ps) {
            *(pd++) = *(ps++);
        }
    }

    // Manually patch the tilemap; give the palm tree priority, so sonic and the balls go behind it
    {
        uint16_t *tilemap = (uint16_t *)0xC000;
        for (int j = 0; j < 5; j++) {
            for (int i = 0; i < 5; i++) {
                tilemap[64 * (8 + j) + (7 + i)] |= 0x4000;
            }
        }
        for (int j = 0; j < 5; j++) {
            tilemap[64 * (13 + j) + 9] |= 0x4000;
        }
    }

    // Set video mode
    IO_VCTRL = VCTRL_MODE_TILE | VCTRL_SPR_EN | VCTRL_TEXT_EN | VCTRL_TEXT_PRIO;

#ifdef PERFMON
    IO_VPALSEL     = 0;
    uint8_t col0_l = IO_VPALDATA;
    IO_VPALSEL     = 1;
    uint8_t col0_h = IO_VPALDATA;
#endif

    uint16_t scroll_x   = 0;
    uint8_t  anim_frame = 0;
    uint8_t  anim_delay = 0;
    int      sonic_x    = 160 - 12;
    int      sonic_y    = 90;

    while (1) {
        video_wait_eof();

#ifdef PERFMON
        // Background: blue
        IO_VPALSEL  = 0;
        IO_VPALDATA = col0_l;
        IO_VPALSEL  = 1;
        IO_VPALDATA = col0_h;
#endif

        // Scroll tile map horizontally
        scroll_x++;
        IO_VSCRX_L = scroll_x & 0xFF;
        IO_VSCRX_H = scroll_x >> 8;

        // Update Sonic sprite
        sonic_sprite(anim_frame, sonic_x, sonic_y);

        // Update Sonic animation
        anim_delay++;
        if (anim_delay >= 5) {
            anim_delay = 0;
            anim_frame++;
            if (anim_frame >= 6) {
                anim_frame = 0;
            }
        }

        // Move balls
        for (uint8_t i = 0; i < 8; i++) {
            struct ball *ballp = &balls[i];

            // Move ball in horizontal direction. If it hits the screen edge, reverse direction.
            ballp->x += ballp->dx;
            if (ballp->x >= 320 - 16)
                ballp->dx = -ballp->dx;

            // Move ball in vertical direction. If it hits the screen edge, reverse direction.
            ballp->y += ballp->dy;
            if (ballp->y >= 200 - 16)
                ballp->dy = -ballp->dy;

            // Update ball sprite
            update_ball_sprites(i);
        }

        // Use joystick to move sonic
        {
            uint8_t joyval = ~get_joystick();
            if (joyval & (1 << 0))
                sonic_y++;
            if (joyval & (1 << 1))
                sonic_x++;
            if (joyval & (1 << 2))
                sonic_y--;
            if (joyval & (1 << 3))
                sonic_x--;
        }

#ifdef PERFMON
        // Background: black
        IO_VPALSEL  = 0;
        IO_VPALDATA = 0;
        IO_VPALSEL  = 1;
        IO_VPALDATA = 0;
#endif
    }

    // return 0;
}
