#include <errno.h>
#include <stdio.h>
#include <arch/zxn.h>
#include <arch/zxn/esxdos.h>

static uint32_t filelen(unsigned char fh)
{
    struct esx_stat es;
    if (esx_f_fstat(fh, (struct esx_stat *)&es)) 
    {
        return 0;
    }
    return es.size;
}

static const char hex[17] = "0123456789ABCDEF";

void hexout2(char d)
{
    putchar(hex[(d >> 4) & 0xf]);
    putchar(hex[(d) & 0xf]);
}

void hexout32(uint32_t d)
{
    putchar(hex[(d >> 28) & 0xf]);
    putchar(hex[(d >> 24) & 0xf]);
    putchar(hex[(d >> 20) & 0xf]);
    putchar(hex[(d >> 16) & 0xf]);
    putchar(hex[(d >> 12) & 0xf]);
    putchar(hex[(d >> 8) & 0xf]);
    putchar(hex[(d >> 4) & 0xf]);
    putchar(hex[(d) & 0xf]);
}

// "puts" adds newline which we don't want
void myputs(char *s)
{
    while (*s)
    {
        putchar(*s);
        s++;
    }
}

int main(int argc, char *argv[])
{
    uint32_t len = 0;
    uint32_t p = 0; 
    unsigned char i;
    unsigned char f = 0;
    unsigned char b[16];
    zx_cls(PAPER_WHITE);
    if (argc < 2)
    {
        myputs("Hexdump usage:\nGive a filename to dump\n");
        return 0;
    }
    
    errno = 0;
    f = esx_f_open(argv[1], ESX_MODE_READ);
    if (errno != 0)
    {
        myputs("Unable to open ");
        myputs(argv[1]);        
        myputs("\n\n");
        return 0;
    }
    len = filelen(f);
    
    myputs("Hex dump of ");
    myputs(argv[1]);
    myputs(" - ");
    hexout32(len);
    myputs(" bytes\n");

    // 1234567890123456789012345678901234567890123456789012345678901234
    // 00000000  00010203 04050607  08090A0B 0C0D0E0F  0123456789ABCDEF
    
    while (p < len)
    {
        // Clear the buffer to spaces so the last line doesn't bug
        for (i = 0; i < 16; i++)
        {
            b[i] = ' ';
        }
        esx_f_read(f, b, 16);
        hexout32(p);
        putchar(' ');
        putchar(' ');
        for (i = 0; i < 4; i++, p++) 
        {
            if (p <= len)
            {
                hexout2(b[i]);
            }
            else
            {
                putchar(' ');
                putchar(' ');
            }
        }
        putchar(' ');
        for (i = 4; i < 8; i++, p++) 
        {
            if (p <= len)
            {
                hexout2(b[i]);
            }
            else
            {
                putchar(' ');
                putchar(' ');
            }
        }
        putchar(' ');
        putchar(' ');
        for (i = 8; i < 12; i++, p++) 
        {
            if (p <= len)
            {
                hexout2(b[i]);
            }
            else
            {
                putchar(' ');
                putchar(' ');
            }
        }
        putchar(' ');
        for (i = 12; i < 16; i++, p++) 
        {
            if (p <= len)
            {
                hexout2(b[i]);
            }
            else
            {
                putchar(' ');
                putchar(' ');
            }
        }
        putchar(' ');
        putchar(' ');
        for (i = 0; i < 16; i++) 
        {            
            if (b[i] >= ' ' && b[i] <= 127)
            {
                putchar(b[i]);
            }
            else
            {
                putchar('.');
            }
        }
    }
    
    // enough newlines to make sure speccy doesn't wipe our bottom rows
    myputs("\n\n\n\n");
    esx_f_close(f);    
    return 0;
}
