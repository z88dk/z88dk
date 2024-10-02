#include <interrupt.h>
#include <intrinsic.h>
#include <stdio.h>
#include <conio.h>
#include <sys/ioctl.h>
#include <arch/aquarius.h>

#define BORDER(a) *((unsigned char *)0x37ff) = (a)

isr_t ISR(void)
{
    M_PRESERVE_MAIN;

    unsigned char vline = IO_VLINE; // Read the VLINE value
    unsigned int VCTRL = IO_VCTRL;

    if (VCTRL & 0x40)
    {
        // 80x25 mode so enable 2nd text page
        // to access to color RAM
        IO_VCTRL = VCTRL | 0x80;
    }

    if (vline < 50)
    {
        BORDER(1);
        IO_VIRQLINE = 50;
    }
    else if (vline < 100)
    {
        BORDER(2);
        IO_VIRQLINE = 100;
    }
    else if (vline < 150)
    {
        BORDER(3);
        IO_VIRQLINE = 150;
    }
    else if (vline < 200)
    {
        BORDER(4);
        IO_VIRQLINE = 200;
    }
    else if (vline < 250)
    {
        BORDER(5);
        IO_VIRQLINE = 250;
    }
    else
    {
        BORDER(0);
        IO_VIRQLINE = 0;
    }

    // Restore original value
    IO_VCTRL = VCTRL;

    // Clear the VLINE interrupt
    IO_IRQSTAT = 0x02;

    M_RESTORE_MAIN;
}

void displayInfo(unsigned char width)
{
    printf("%cInterrupt example in %dx25 text mode\n", 12, width);
    for (char a = 1; a < 24; a++)
        printf("Row %d\n", a);
    printf("Press ENTER to scroll");

    // Wait for a key to be pressed
    getch();

    printf("\nPress ENTER again.");

    getch();
}
void main(void)
{
    int val = VCTRL_TEXT_EN | VCTRL_REMAP_BC | VCRTL_80COL_EN;

    // Setup im1 interrupts
    im1_init();

    // Install user ISR
    add_raster_int(ISR);

    // Enable the VLINE interrupt at line 0
    IO_VIRQLINE = 0;
    IO_IRQMASK |= IRQ_VLINE;

    displayInfo(40);

    console_ioctl(IOCTL_GENCON_SET_MODE, &val);

    displayInfo(80);

    // Back to 40x25 mode
    val = VCTRL_TEXT_EN | VCTRL_REMAP_BC;
    console_ioctl(IOCTL_GENCON_SET_MODE, &val);

    // Set border back to black
    BORDER(0);
}
