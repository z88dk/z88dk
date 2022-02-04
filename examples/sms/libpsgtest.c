#include <sms.h>
#include <psg.h>
#include <psg/PSGlib.h>
#include <stdio.h>

static const unsigned char pal0[] =
{ 0x00, 0x3f };

void isr(void)
{
    // Play the next frame of music
    PSGFrame();
}

void main(void)
{
    int x = 0;

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
    PSGPlay(&music);

    while (1)
    {
        // Wait for refresh interrupt
        __asm__("halt");
        // Scroll the screen to the left by 1 pixel
        scroll_bkg(x--, 0);
    }
}

#asm
        section rodata_user

        ; Music borrowed from http://shiru.untergrund.net/music.shtml
        ; and converted to PSG with https://www.smspower.org/forums/16925-PSGToolAVGMToPSGConvertor
_music:
        binary "my_mission.psg"
#endasm

