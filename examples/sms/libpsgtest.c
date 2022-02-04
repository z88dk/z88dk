#include <sms.h>
#include <psg.h>
#include <psg/PSGlib.h>
#include <stdio.h>

extern unsigned char music[];

static const unsigned char pal0[] =
{ 0x00, 0x3f };

static const unsigned char pal1[] =
{ 0x00, 0x03 };

static const unsigned char *pal[] =
{&pal0[1], &pal1[1]};

void isr(void)
{
    static unsigned char flashDelay = 0;
    static unsigned char palette = 0;

    // Flash the text by swapping palette index 1
    if(flashDelay++ & 0x10)
    {
        flashDelay = 0;
        palette ^= 1;
        load_palette((unsigned char *) pal[palette], 1, 1);
    }

    // Play the next frame of music
    PSGFrame();
}

void main(void)
{
    unsigned char x = 0;

    // Clear the video RAM
    clear_vram();
    // Load the standard font into tile memory starting at tile 0
    load_tiles(standard_font, 0, 255, 1);
    // Set 2 colors for palette 0, black and white
    load_palette(pal0, 0, 2);
    // Enable the screen and refresh interrupts
    set_vdp_reg(VDP_REG_FLAGS1,
            VDP_REG_FLAGS1_BIT7 | VDP_REG_FLAGS1_SCREEN | VDP_REG_FLAGS1_VINT);

    gotoxy(7, 11);
    printf("Now Playing!!!");

    // Initialize the PSG library
    psg_init();
    // Setup our refresh ISR
    add_raster_int(isr);
    // Start the music
    PSGPlay(music);

    while (1)
    {
        // Wait for refresh interrupt
        __asm__("halt");
        // Scroll the screen to the left by 1 pixel
        scroll_bkg(x--, 0);
    }
}

