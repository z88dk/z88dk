
#include "ticks.h"
#include <stdio.h>
#include <ctype.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/stat.h>
#ifndef WIN32
#include <unistd.h>                         // For declarations of isatty()
#else
#include <conio.h>
#include <io.h>
#endif

static int user_num = 0;
static int dma_address = 0;

#define NUM_SLOTS 16
static int slots[NUM_SLOTS];

#define GET_FCB() ((d<<8)|e)



static int find_slot()
{
    int  i;

    for ( i = 0; i < NUM_SLOTS; i++ ) {
        if ( slots[i] == -1 ) {
            return i;
        }
    }
    return -1;
}


static int get_random(int fcb)
{
    uint8_t r0, r1, r2;
    int random;
    /*
        * get random record number bytes
        */
    r0 = get_memory_data(fcb + 33);
    r1 = get_memory_data(fcb + 34);
    r2 = get_memory_data(fcb + 35);

    if (r2 > 1 || (r2 == 1 && (r0 || r1))) {
        random = (-1);
    } else {
        random = ((r2 << 16) | ( r1 << 8) | r0) * 128;
    }
    return random;
}


static void set_offset(int fcb, int offset)
{
    *get_memory_addr(fcb+32, MEM_TYPE_DATA) = offset & 0x7f;
    *get_memory_addr(fcb + 12, MEM_TYPE_DATA) = (offset >> 7) & 0x001f;
    *get_memory_addr(fcb + 14, MEM_TYPE_DATA) = offset >> 12;
}


static void get_filename(int fcb, int offset, char filename[15])
{
    int i, filenoffs;
    
    for ( i = offset, filenoffs = 0; i < offset + 8; i++ ) {
        uint8_t c  = get_memory_data(fcb + i ) & 0x7f;
        if ( !isspace(c)) {
            filename[filenoffs++] = tolower(c);
            filename[filenoffs] = 0;
        } else {
            break;
        }
    }
    for ( i = offset + 8; i < offset + 11; i++ ) {
        uint8_t c  = (get_memory_data(fcb + i ) & 0x7f);
        if ( !isspace(c)) {
            if  ( i == offset+8 ) filename[filenoffs++] = '.';
            filename[filenoffs++] = tolower(c);
            filename[filenoffs] = 0;
        }
    }
}


static void bdos_open_file(void)
{
    char filename[15];
    int fcb = GET_FCB();
    int extent;
    int filenoffs = 0;
    int fd = -1, slot;

    a = 255;   // By default we fail

    // Check extent number inf the FCB
    extent = get_memory_data(fcb + 12);
    if ( extent > 31 ) {
        goto fail;
    }

    // S2 = 0
    put_memory(fcb + 14, 0x00);

    get_filename(fcb, 1, filename);


    if ( (fd = open(filename, O_RDWR)) == -1 ) {
        goto fail;
    }

    slot = find_slot();
    slots[slot] = fd;
    fd = -1;

    // Now write the slot number into FCB in AL
    put_memory(fcb + 16, slot & 0xff);

    a = 0x00;

fail:
    if ( fd != -1 ) close(fd);
    l = a;
    h = b = 0;
}

static void bdos_create_file(void)
{
    char filename[15];
    int fcb = GET_FCB();
    int extent;
    int filenoffs = 0;
    int fd = -1, slot;

    a = 255;   // By default we fail

    // Check extent number in the FCB
    extent = get_memory_data(fcb + 12);
    if ( extent > 31 ) {
        goto fail;
    }

    // S2 = 0
    put_memory(fcb + 14, 0x00);

    // Get the filename
    get_filename(fcb, 1, filename);

    if ( (fd = open(filename, O_RDWR|O_CREAT, 0666)) == -1 ) {
        goto fail;
    }

    slot = find_slot();
    slots[slot] = fd;
    fd = -1;

    // Now write the slot number into FCB in AL
    put_memory(fcb + 16, slot & 0xff);

    a = 0x00;

fail:
    if ( fd != -1 ) close(fd);

    l = a;
    h = b = 0;
}

static void bdos_delete_file(void)
{
    char filename[15];
    int fcb = GET_FCB();
    int filenoffs = 0;

    a = 255;   // By default we fail


    // Get the filename
    for ( i = 1, filenoffs = 0; i < 9; i++ ) {
        uint8_t c  = get_memory_data(fcb + i ) & 0x7f;
        if ( !isspace(c)) {
            filename[filenoffs++] = tolower(c);
            filename[filenoffs] = 0;
        } else {
            break;
        }
    }
    for ( i = 9; i < 12; i++ ) {
        uint8_t c  = (get_memory_data(fcb + i ) & 0x7f);
        if ( !isspace(c)) {
            if  ( i == 9 ) filename[filenoffs++] = '.';
            filename[filenoffs++] = tolower(c);
            filename[filenoffs] = 0;
        }
    }
    unlink(filename);

    a = 0x00;

fail:
    l = a;
    h = b = 0;
}


static void bdos_rename_file(void)
{
    char filename1[15];
    char filename2[15];
    int fcb = GET_FCB();

    a = 255;   // By default we fail

    // Get the filenames
    get_filename(fcb, 1, filename1);
    get_filename(fcb, 17, filename2);
    
    if ( rename(filename1, filename2) == 0 ) {
        a = 0x00;
    }

fail:
    l = a;
    h = b = 0;
}


static void bdos_close_file(void)
{
    int fcb = GET_FCB();
    int slot = get_memory(fcb + 16, MEM_TYPE_DATA);
    int fd;

    a = 0xff;  // Failure

    if ( slot != 0xff ) {
        fd = slots[slot];

        if ( fd != -1  ) {
            close(fd);
            a = 0;
            slots[slot] = -1;
        }
    }
}

static void bdos_read_rand(void)
{
    int fcb = GET_FCB();
    int slot, fd;
    int posn;

    a = 0x01; // Failure: Reading unwritten data

    slot = get_memory_data(fcb + 16);

    if ( (fd = slots[slot] ) == -1 ) {
        goto fail;
    }




    posn = get_random(fcb);
    if ( posn == -1 ) {
        a = 0x06; // Out of range
        goto fail;
    }

    //printf("Read from fd %d slot %d posn %d\n",fd,slot,posn);

    if ( lseek(fd, posn, SEEK_SET) == -1 ) goto fail;

    if ( read(fd, get_memory_addr(dma_address, MEM_TYPE_DATA), 128) <= 0 ) goto fail;

    set_offset(fcb, posn); // Set sequential offset

    a = 0x00; // Success

fail:
    l = a;
    h = b = 0;
}

static void bdos_write_rand(void)
{
    int fcb = GET_FCB();
    int slot, fd;
    int posn;

    a = 0x01; // Failure: Reading unwritten data


    slot = get_memory_data(fcb + 16);
    fd = slots[slot];
    if ( fd == -1 ) goto fail;

    posn = get_random(fcb);
    if ( posn == -1  ) {
        a = 0x06; // Out of range
        goto fail;
    }

    //printf("Write to fd %d slot %d posn %d\n",fd,slot,posn);
    if ( lseek(fd, posn, SEEK_SET) == -1 ) goto fail;

    if ( write(fd, get_memory_addr(dma_address, MEM_TYPE_DATA), 128) <= 0 ) goto fail;

    set_offset(fcb, posn); // Set sequential offset

    a = 0x00; // Success

fail:
    l = a;
    h = b = 0;
}

static void bdos_set_dma(void)
{
    int addr = (d << 8)|e;

    dma_address = addr;

    l = a = 0;
    h = b = 0;
}

static void bdos_file_size(void)
{
    int fcb = GET_FCB();
    char filename[15];
    struct stat sb;
    
    a = 0; // Success always for CP/M 2
    
    get_filename(fcb, 1, filename);

    put_memory(fcb + 0x21, 0);
    put_memory(fcb + 0x22, 0);
    put_memory(fcb + 0x23, 0);

    if ( stat(filename, &sb) == 0 ) {
        int size = sb.st_size;
        int numsec;

        numsec = sb.st_size / 128;
        if ( size % 128 ) numsec++;

        put_memory(fcb + 0x21, numsec % 256);
        put_memory(fcb + 0x22, numsec / 256);
        a = 0x00; // Success
    }

fail:
    l = a;
    h = b = 0;
}


void hook_cpm(void)
{
    switch (c) {
    case 0x01:  // C_READ
        /* Entered with C=1. Returns A=L=character.
           Wait for a character from the keyboard; then echo it to the screen and return it. */
       a = l = fgetc(stdin);
       break;
    case 0x02:  // C_WRITE
        /* Entered with C=2, E=ASCII character. */
        if ( e != 12 ) {
            fputc(e, stdout);
            fflush(stdout);
        }
        break;
    case 0x06:  // C_RAWIO
        /* E=0FF Return a character without echoing if one is waiting; zero if none is available. */
        if ( e == 0xff ) {
            int val;
            if (isatty(fileno(stdin)))
                val = getch();          // read one character at a time if connected to a tty
            else
                val = getchar();        // read in cooked mode if redirected from a file
            if ( val == EOF ) val = 0;
            else if ( val == 10 ) val = 13;
            else if ( val == 13 ) val = 10;
            a = l = val;
        }
        break;
    case 0x09:  // C_WRITESTR
        /* Entered with C=9, DE=address of string terminated by $ */
        {
            int addr = d << 8 | e;
            int tp;
            while ( ( tp = *get_memory_addr(addr, MEM_TYPE_INST)) ) {
                if ( tp == '$' ) 
                    break;
                fputc(tp, stdout);
                addr++;
            }
            fflush(stdout);
        }
        break;
    case 0x0b:  // C_STAT
        /* Entered with C=0Bh. Returns A=L=status.
           Returns A=0 if no characters are waiting, nonzero if a character is waiting. */
        {
            int val;
            if ( (val = kbhit()) == EOF )
                val = 0;
            a = l = val;
        }
        break;
    case 0x0c:  // S_BDOSVER
        /* Entered with C=0Ch. Returns B=H=system type, A=L=version number. */
        b = h = 0;
        a = l = 0x22;
        break;
    case 0x0e:  // DRV_SET
        /* Entered with C=0Eh, E=drive number. Returns L=A=0 or 0FFh. */
        if ( e == 0 )
            a = l = 0;  // Current drive is a
        else
            a = l = 0xff; // Selecting an unavailable drive.
        break;
    case 0x0f: // F_OPEN
        /* Entered with C=0Fh, DE=FCB address. Returns error codes in BA and HL. */
        bdos_open_file();
        break;
    case 0x10: // F_CLOSE
        /* Entered with C=10h, DE=FCB address. Returns error codes in BA and HL. */
        bdos_close_file();
        break;
    case 0x13: // F_DELETE
        bdos_delete_file();
        break;
    // case 0x14: // F_READ
    //     /* Entered with C=14h, DE=address of FCB. Returns error codes in BA and HL. */
    //     bdos_read();
    //     break;
    // case 0x15: // F_WRITE
    //     /* Entered with C=15h, DE=address of FCB. Returns error codes in BA and HL. */
    //     bdos_write();
    //     break;
    case 0x16: // F_MAKE - create file
        /* Entered with C=16h, DE=address of FCB. Returns error codes in BA and HL. */
        bdos_create_file();
        break;
    case 0x17: // F_RENAME - rename file
        /* Entered with C=17h, DE=address of FCB. Returns error codes in BA and HL. */
        bdos_rename_file();
    case 0x19:  // DRV_GET
        /* Entered with C=19h, E=drive number. Returns L=A=0 or 0FFh. */
        if ( e == 0 )
            a = l = 0;  // Current drive is a
        else
            a = l = 0xff; // Selecting an unavailable drive.
        break;
    case 0x1a:  // F_DMAOFF
        /* Entered with C=1Ah, DE=address. */
        bdos_set_dma();
        break;
    case 0x20:  // F_USERNUM
        /* Entered with C=20h, E=number. If E=0FFh, returns number in A. */
        if ( e == 0xff )
            a = l = user_num;
        else
            if ( e >= 0 && e < 16 )
                user_num = e;
        break;
    case 0x21: // F_READRAND
        /* Entered with C=21h, DE=FCB address. Returns error codes in BA and HL. */
        bdos_read_rand();
        break;
    case 0x22: // F_WRITERAND
        /* Entered with C=21h, DE=FCB address. Returns error codes in BA and HL. */
        bdos_write_rand();
        break;
    case 0x23: // F_SIZE
        /* Entered with C=23h, DE=FCB address. Returns error codes in BA and HL. */
        bdos_file_size();
        break;
    default:
        fprintf(stderr,"Unsupported BDOS call %d\n",c);
        break;
    }
}



void hook_cpm_init(hook_command *cmds)
{
    int  i;

    for (i = 0; i < NUM_SLOTS; i++ ) {
        slots[i] = -1;
    }
}

