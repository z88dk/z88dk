
#include "ticks.h"
#include <stdio.h>
#include <ctype.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/stat.h>
#include <time.h>
#include <string.h>
#ifndef WIN32
#include <dirent.h>
#endif
#ifndef WIN32
#include <unistd.h>                         // For declarations of isatty()
#else
#include <conio.h>
#include <io.h>
#define ftruncate(fd, len) _chsize((fd), (len))
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


/* The record the FCB's sequential fields (current record CR, extent EX, S2) are at, and set them to a record: 128 records an extent, 32 extents to S2 */
static int get_record(int fcb)
{
    return ((((get_memory_data(fcb + 14) & 0x3f) << 5) | (get_memory_data(fcb + 12) & 0x1f)) << 7) | (get_memory_data(fcb + 32) & 0x7f);
}

static void set_record(int fcb, int record)
{
    put_memory((uint16_t)(fcb + 32), record & 0x7f);
    put_memory((uint16_t)(fcb + 12), (record >> 7) & 0x001f);
    put_memory((uint16_t)(fcb + 14), (record >> 12) & 0x3f);
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
    l = a;
    h = b = 0;
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

    {
        uint8_t buffer[128];
        int ret = read(fd, buffer, sizeof(buffer));
        int i;
        if ( ret <= 0 ) goto fail;
        for ( i = 0; i < ret; i++ ) put_memory((uint16_t)(dma_address + i), buffer[i]);
    }

    set_record(fcb, posn / 128); // Set sequential offset

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

    {
        uint8_t buffer[128];
        int i;
        for ( i = 0; i < sizeof(buffer); i++ ) buffer[i] = get_memory_data((uint16_t)(dma_address + i));
        if ( write(fd, buffer, sizeof(buffer)) <= 0 ) goto fail;
    }

    set_record(fcb, posn / 128); // Set sequential offset

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


/* Sequential read and write: the record the FCB's CR, EX and S2 say, and on to the next */
static void bdos_read_seq(void)
{
    int fcb = GET_FCB();
    int slot = get_memory_data(fcb + 16), fd;
    int record = get_record(fcb);

    a = 0x01;                                       // End of file
    if ( slot >= NUM_SLOTS || (fd = slots[slot]) == -1 ) {
        a = 0xff;
        goto done;
    }
    if ( lseek(fd, (off_t)record * 128, SEEK_SET) != -1 ) {
        uint8_t buffer[128];
        int ret = read(fd, buffer, sizeof(buffer)), i;

        if ( ret > 0 ) {
            for ( i = 0; i < 128; i++ ) put_memory((uint16_t)(dma_address + i), i < ret ? buffer[i] : 0x1a);
            set_record(fcb, record + 1);
            a = 0x00;
        }
    }
done:
    l = a;
    h = b = 0;
}

static void bdos_write_seq(void)
{
    int fcb = GET_FCB();
    int slot = get_memory_data(fcb + 16), fd;
    int record = get_record(fcb);

    a = 0x02;                                       // No data block
    if ( slot >= NUM_SLOTS || (fd = slots[slot]) == -1 ) {
        a = 0xff;
        goto done;
    }
    if ( lseek(fd, (off_t)record * 128, SEEK_SET) != -1 ) {
        uint8_t buffer[128];
        int i;

        for ( i = 0; i < 128; i++ ) buffer[i] = get_memory_data((uint16_t)(dma_address + i));
        if ( write(fd, buffer, sizeof(buffer)) == sizeof(buffer) ) {
            set_record(fcb, record + 1);
            a = 0x00;
        }
    }
done:
    l = a;
    h = b = 0;
}

/* F_RANDREC (36): the random record fields from the sequential position; F_TRUNCATE (99): the file ends at the random record */
static void bdos_set_random(void)
{
    int fcb = GET_FCB();
    int record = get_record(fcb);

    put_memory((uint16_t)(fcb + 33), record & 0xff);
    put_memory((uint16_t)(fcb + 34), (record >> 8) & 0xff);
    put_memory((uint16_t)(fcb + 35), (record >> 16) & 0xff);
    a = l = 0;
    h = b = 0;
}

static void bdos_truncate(void)
{
    int fcb = GET_FCB();
    int slot = get_memory_data(fcb + 16), fd, posn = get_random(fcb);

    a = 0xff;
    if ( slot < NUM_SLOTS && (fd = slots[slot]) != -1 && posn != -1 && ftruncate(fd, posn) == 0 )
        a = 0;
    l = a;
    h = b = 0;
}

/* Search for first (17) and next (18): the files of the current directory that fit the FCB's name and type ('?' is any character), as directory entries (a user number,
   the name and type in capitals, the record count) in the DMA area, four to a 128 byte record; the result is which of the four */
#define MAX_FOUND 256
static char found[MAX_FOUND][13];
static off_t found_size[MAX_FOUND];
static int num_found, next_found;

static int name_to_fcb(const char *name, char out[11])
{
    const char *dot = strrchr(name, '.');
    int n = dot ? (int)(dot - name) : (int)strlen(name), t = dot ? (int)strlen(dot + 1) : 0, i;

    if ( n == 0 || n > 8 || t > 3 || (name[0] == '.' && !dot) ) return 0;
    memset(out, ' ', 11);
    for ( i = 0; i < n; i++ ) out[i] = toupper((unsigned char)name[i]);
    for ( i = 0; i < t; i++ ) out[8 + i] = toupper((unsigned char)dot[1 + i]);
    return 1;
}

static void search_entry(void)
{
    int i;
    char fcbname[11];

    for ( i = 0; i < 128; i++ ) put_memory((uint16_t)(dma_address + i), 0xe5);
    if ( next_found >= num_found ) {
        a = 0xff;
    } else {
        off_t size = found_size[next_found];
        int records = (int)((size + 127) / 128);

        name_to_fcb(found[next_found], fcbname);
        put_memory((uint16_t)dma_address, user_num);
        for ( i = 0; i < 11; i++ ) put_memory((uint16_t)(dma_address + 1 + i), fcbname[i]);
        for ( i = 12; i < 32; i++ ) put_memory((uint16_t)(dma_address + i), 0);
        put_memory((uint16_t)(dma_address + 12), 0);                        // extent 0
        put_memory((uint16_t)(dma_address + 15), records > 128 ? 128 : records);
        ++next_found;
        a = 0;
    }
    l = a;
    h = b = 0;
}

static void bdos_search_first(void)
{
#ifndef WIN32
    int fcb = GET_FCB();
    char pattern[11], entry[11];
    int i;
    DIR *dir;
    struct dirent *de;

    num_found = next_found = 0;
    for ( i = 0; i < 11; i++ ) pattern[i] = get_memory_data(fcb + 1 + i) & 0x7f;
    if ( (dir = opendir(".")) != NULL ) {
        while ( (de = readdir(dir)) != NULL && num_found < MAX_FOUND ) {
            struct stat sb;

            if ( strlen(de->d_name) > 12 || !name_to_fcb(de->d_name, entry) || stat(de->d_name, &sb) != 0 || !S_ISREG(sb.st_mode) ) continue;
            for ( i = 0; i < 11; i++ )
                if ( pattern[i] != '?' && toupper((unsigned char)pattern[i]) != entry[i] ) break;
            if ( i < 11 ) continue;
            strcpy(found[num_found], de->d_name);
            found_size[num_found++] = sb.st_size;
        }
        closedir(dir);
    }
    search_entry();
#else
    a = l = 0xff;
    h = b = 0;
#endif
}

static void bdos_search_next(void)
{
    search_entry();
}

/* C_READSTR (10): DE is a buffer of its size, the length read and the line */
static void bdos_read_line(void)
{
    int addr = GET_FCB();
    int max = get_memory_data(addr), n = 0, ch;

    while ( (ch = fgetc(stdin)) != EOF && ch != '\n' && ch != '\r' ) {
        if ( n < max ) put_memory((uint16_t)(addr + 2 + n++), ch);
    }
    put_memory((uint16_t)(addr + 1), n);
}

/* T_GET (105): DE is four bytes for the days since 31 December 1977 (two bytes), the hours and the minutes (BCD); A is the seconds (BCD) */
static uint8_t bcd(int n) { return (uint8_t)(((n / 10) << 4) | (n % 10)); }

static void bdos_get_time(void)
{
    int addr = GET_FCB();
    time_t now = time(NULL);
    struct tm tm = *localtime(&now);
    struct tm epoch;
    int days;

    memset(&epoch, 0, sizeof(epoch));
    epoch.tm_year = 77;
    epoch.tm_mon = 11;
    epoch.tm_mday = 31;
    epoch.tm_hour = 12;
    epoch.tm_isdst = -1;
    {
        struct tm noon = tm;

        noon.tm_hour = 12;
        noon.tm_min = noon.tm_sec = 0;
        noon.tm_isdst = -1;
        days = (int)((mktime(&noon) - mktime(&epoch) + 43200) / 86400);
    }
    put_memory((uint16_t)addr, days & 0xff);
    put_memory((uint16_t)(addr + 1), (days >> 8) & 0xff);
    put_memory((uint16_t)(addr + 2), bcd(tm.tm_hour));
    put_memory((uint16_t)(addr + 3), bcd(tm.tm_min));
    a = l = bcd(tm.tm_sec);
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
        /* E=0FFh: input; E=0FEh: status; else: output char in E. */
        if ( e == 0xff ) {
            int val;
            if (isatty(fileno(stdin)))
                val = getch();
            else
                val = getchar();
            if ( val == EOF ) val = 0;
            else if ( val == 10 ) val = 13;
            else if ( val == 13 ) val = 10;
            a = l = val;
        } else if ( e == 0xfe ) {
            int val = kbhit();
            a = l = (val == EOF || val == 0) ? 0 : 0xff;
        } else {
            if ( e != 12 ) {
                fputc(e, stdout);
                fflush(stdout);
            }
        }
        break;
    case 0x09:  // C_WRITESTR
        /* Entered with C=9, DE=address of string terminated by $ */
        {
            int addr = d << 8 | e;
            int tp;
            while ( ( tp = get_memory_inst((uint16_t)addr)) ) {
                if ( tp == '$' ) 
                    break;
                fputc(tp, stdout);
                addr = (addr + 1) & 0xffff;
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
    case 0x0a:  // C_READSTR
        bdos_read_line();
        break;
    case 0x0d:  // DRV_ALLRESET
        /* Entered with C=0Dh: the disk system is reset, the DMA address is back at 0080h. */
        dma_address = 0x80;
        a = l = 0;
        h = b = 0;
        break;
    case 0x11:  // F_SFIRST
        bdos_search_first();
        break;
    case 0x12:  // F_SNEXT
        bdos_search_next();
        break;
    case 0x14: // F_READ
        /* Entered with C=14h, DE=address of FCB. Returns error codes in BA and HL. */
        bdos_read_seq();
        break;
    case 0x15: // F_WRITE
        /* Entered with C=15h, DE=address of FCB. Returns error codes in BA and HL. */
        bdos_write_seq();
        break;
    case 0x18:  // DRV_LOGINVEC
        /* Entered with C=18h. Returns HL=the drives that are logged in: drive A. */
        a = l = 1;
        h = b = 0;
        break;
    case 0x1d:  // DRV_ROVEC
        /* Entered with C=1Dh. Returns HL=the drives that are read only: none. */
        a = l = 0;
        h = b = 0;
        break;
    case 0x1e:  // F_ATTRIB
        /* Entered with C=1Eh, DE=FCB address: the attributes are not kept. */
        a = l = 0;
        h = b = 0;
        break;
    case 0x24:  // F_RANDREC
        bdos_set_random();
        break;
    case 0x25:  // DRV_RESET
        a = l = 0;
        h = b = 0;
        break;
    case 0x28:  // F_WRITEZF: write random with zero fill (the file system's holes are zeros anyway)
        bdos_write_rand();
        break;
    case 0x2c:  // F_MULTISEC (CP/M 3): one record at a time
    case 0x2d:  // F_ERRMODE (CP/M 3)
        a = l = 0;
        h = b = 0;
        break;
    case 0x63:  // F_TRUNCATE (CP/M 3)
        bdos_truncate();
        break;
    case 0x68:  // T_SET (CP/M 3): the clock is the host's
        a = l = 0;
        h = b = 0;
        break;
    case 0x69:  // T_GET (CP/M 3)
        bdos_get_time();
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
    case 0x16: // F_MAKE - create file
        /* Entered with C=16h, DE=address of FCB. Returns error codes in BA and HL. */
        bdos_create_file();
        break;
    case 0x17: // F_RENAME - rename file
        /* Entered with C=17h, DE=address of FCB. Returns error codes in BA and HL. */
        bdos_rename_file();
        break;
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

