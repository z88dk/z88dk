/*
    nsedit.c
    Simple North Star DOS disk image utility
    By Stefano Bodrato - 2026

       gcc -o nsedit nsedit.c


    Supports:
        89600-byte images  (350 blocks)
        179200-byte images (700 blocks)
        358400-byte images (1400 blocks)


    Commands:
        nsedit dir image.nsi
        nsedit extract image.nsi DOSNAME outfile
        nsedit insert image.nsi infile DOSNAME <GO address>
        nsedit delete image.nsi DOSNAME
        nsedit compress image.nsi


    Common file types:
        0 system file or not specified
        1 executable binary files
        2 BASIC programs
        ? 3 BASIC DATA ?

*/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#define DIR_BLOCKS 4
#define DIR_ENTRIES 64


#pragma pack(push,1)

typedef struct
{
    char     name[8];
    uint16_t start_block;
    uint16_t length;
    uint8_t type;
    uint16_t go_address;
    uint8_t reserved;
} NSDirEntry;

#pragma pack(pop)


// 256 will be later updated, we use it for the initial image checks
int BLOCK_SIZE = 256;


static long image_blocks(FILE *fp)
{
    long size;

    fseek(fp,0,SEEK_END);
    size = ftell(fp);
    rewind(fp);

    return size / BLOCK_SIZE;
}


static void heading_summary(FILE *img)
{
    int img_blk = image_blocks(img);
    
    switch (img_blk) {
    case 350:
        printf ("SSSD - 35 tracks, 256 bytes/sec\n");
        BLOCK_SIZE = 256;
        break;
    case 700:
        printf ("SSDD - 35 tracks, 512 bytes/sec\n");
        BLOCK_SIZE = 512;
        break;
    case 1400:
        printf ("SSDD - 70 tracks, 512 bytes/sec\n");
        BLOCK_SIZE = 512;
        break;
    default:
        printf ("Unknown disk type !\n");
        BLOCK_SIZE = 512;
        break;
    }
    
    printf ("%uK disk image\n", img_blk*BLOCK_SIZE/1024);
}

static int read_directory(FILE *fp, NSDirEntry dir[DIR_ENTRIES])
{
    rewind(fp);

    return fread(
            dir,
            sizeof(NSDirEntry),
            DIR_ENTRIES,
            fp) == DIR_ENTRIES;
}

static int write_directory(FILE *fp, NSDirEntry dir[DIR_ENTRIES])
{
    rewind(fp);

    return fwrite(
            dir,
            sizeof(NSDirEntry),
            DIR_ENTRIES,
            fp) == DIR_ENTRIES;
}

static void entry_name(char out[9], const NSDirEntry *e)
{
    memcpy(out,e->name,8);
    out[8]=0;

    for(int i=7;i>=0;i--)
    {
        if(out[i]==' ')
            out[i]=0;
        else
            break;
    }
}

static int find_entry(
    NSDirEntry dir[DIR_ENTRIES],
    const char *name)
{
    char dosname[8];

    memset(dosname,' ',8);

    for(int i=0;i<8 && name[i];i++)
        dosname[i]=name[i];

    for(int i=1;i<DIR_ENTRIES;i++)
    {
        if(memcmp(dir[i].name,dosname,8)==0)
            return i;
    }

    return -1;
}


static uint16_t first_free_block(NSDirEntry dir[DIR_ENTRIES])
{
    uint16_t max = 4;

    for(int i=1;i<DIR_ENTRIES;i++)
    {
        if(dir[i].name[0]==' ')
            continue;

        uint16_t end =
            dir[i].start_block + dir[i].length;

        if(end > max)
            max = end;
    }

    return max;
}

static void list_directory(FILE *fp)
{
    NSDirEntry dir[DIR_ENTRIES];

    if(!read_directory(fp,dir))
    {
        fprintf(stderr,"Directory read error\n");
        return;
    }

    //long used = used_blocks(dir);

    uint32_t used = 0;
    uint32_t used_dd = 0;
    uint32_t bytes_len = 0;

    for(int i=1;i<DIR_ENTRIES;i++)
    {
        if (dir[i].name[0] == ' ')
            continue;

        // Getting rid of BLOCK_SIZE, we try to keep this stuff dynamic
        if (dir[i].type & 0x80) {
            bytes_len += dir[i].length*512;
            used_dd += dir[i].length;
        } else {
            used += dir[i].length;
            bytes_len += dir[i].length*256;
        }
    }

    long total_bytes = image_blocks(fp) * BLOCK_SIZE;
    long free_bytes = total_bytes - DIR_BLOCKS * BLOCK_SIZE - bytes_len;

    printf("\n('*' = Double Density)\n");

    printf(
        "\n"
        "NAME       START  LEN  TYPE GO\n"
        "------------------------------\n");

    for(int i=0;i<DIR_ENTRIES;i++)
    {
        if(dir[i].name[0]==' ')
            continue;

        char name[9];

        entry_name(name,&dir[i]);

        uint8_t meta0 = dir[i].go_address & 0xff;
        uint8_t meta1 = dir[i].go_address >> 8;
        uint8_t meta2 = dir[i].reserved;

        if ((dir[i].type & 0x7f) == 0)
        {
            if ((i==0) && (dir[i].start_block==0))
                printf(
                    "%-8s     0         [DIR]  %02Xh,%02Xh,%02Xh\n---------------------------\n",
                    name,
                    meta0,
                    meta1,
                    meta2);
            else
            if (dir[i].start_block==4) {
                printf(
                    "%-8s     4   %4u  [BOOT] %02Xh,%02Xh,%02Xh\n---------------------------\n",
                    name,
                    dir[i].length,
                    meta0,
                    meta1,
                    meta2);
            } else {
                printf(
                    "%-8s %5u  %4u   %c%2u    %02Xh,%02Xh,%02Xh\n",
                    name,
                    dir[i].start_block,
                    dir[i].length,
                    (dir[i].type & 0x80) ? '*' : ' ',
                    dir[i].type & 0x7f,
                    meta0,
                    meta1,
                    meta2);
            }
        }
        else
        {
            if (dir[i].start_block==4) {
                printf(
                    "%-8s     4   %4u  [CPM]  %02Xh,%02Xh,%02Xh\n---------------------------\n",
                    name,
                    dir[i].length,
                    meta0,
                    meta1,
                    meta2);
            } else {
                printf(
                    "%-8s %5u  %4u   %c%2u  %04Xh\n",
                    name,
                    dir[i].start_block,
                    dir[i].length,
                    (dir[i].type & 0x80) ? '*' : ' ',
                    dir[i].type & 0x7f,
                    dir[i].go_address);
            }
        }
    }
    printf("\n\nUsed blocks : %u SD + %u DD, %u bytes", used, used_dd, bytes_len);
    printf("\n%u bytes free.\n", free_bytes);

}

static int extract_file(
    FILE *img,
    NSDirEntry *e,
    const char *outfile)
{
    FILE *out;

    uint8_t buffer[BLOCK_SIZE];

    long offset;
    long size;

    out=fopen(outfile,"wb");

    if(!out)
        return 0;

    offset=(long)e->start_block * BLOCK_SIZE;

    size=(long)e->length * BLOCK_SIZE;

    fseek(img,offset,SEEK_SET);

    while(size>0)
    {
        size_t n =
            size > BLOCK_SIZE ?
            BLOCK_SIZE :
            size;

        fread(buffer,1,n,img);
        fwrite(buffer,1,n,out);

        size -= n;
    }

    fclose(out);

    return 1;
}

static int delete_file(
    FILE *img,
    NSDirEntry dir[DIR_ENTRIES],
    int idx)
{
    memset(dir[idx].name,' ',8);

    return write_directory(img,dir);
}


// The inserted file is always a binary file

static int insert_file(
    FILE *img,
    const char *hostfile,
    const char *dosname,
    uint16_t goaddr)
{
    NSDirEntry dir[DIR_ENTRIES];

    FILE *in;

    long max_blocks;

    uint16_t start;
    uint16_t blocks;

    int slot=-1;

    if(!read_directory(img,dir))
        return 0;

    if(find_entry(dir,dosname)>=0)
    {
        fprintf(stderr,"File already exists\n");
        return 0;
    }

    for(int i=1;i<DIR_ENTRIES;i++)
    {
        if(dir[i].name[0]==' ')
        {
            slot=i;
            break;
        }
    }

    if(slot<0)
    {
        fprintf(stderr,"Directory full\n");
        return 0;
    }

    in=fopen(hostfile,"rb");

    if(!in)
        return 0;

    fseek(in,0,SEEK_END);

    long filesize=ftell(in);

    rewind(in);

    blocks=(uint16_t)((filesize+(BLOCK_SIZE-1))/BLOCK_SIZE);

    start=first_free_block(dir);

    max_blocks=(long)image_blocks(img);

    if((long)start + blocks >= max_blocks)
    {
        fclose(in);
        fprintf(stderr,"Disk full\n");
        return 0;
    }

    fseek(
        img,
        (long)start * BLOCK_SIZE,
        SEEK_SET);

    uint8_t buffer[BLOCK_SIZE];

    while(!feof(in))
    {
        size_t n=
            fread(buffer,1,BLOCK_SIZE,in);

        if(n==0)
            break;

        if(n<BLOCK_SIZE)
            memset(buffer+n,0,BLOCK_SIZE-n);

        fwrite(buffer,1,BLOCK_SIZE,img);
    }

    fclose(in);

    memset(&dir[slot],0,sizeof(NSDirEntry));

    memset(dir[slot].name,' ',8);

    for(int i=0;i<8 && dosname[i];i++)
        dir[slot].name[i]=dosname[i];

    dir[slot].start_block=start;
    dir[slot].length=blocks;
    if (BLOCK_SIZE == 512)
        dir[slot].type=129;
    else
        dir[slot].type=1;
    dir[slot].go_address=goaddr;

    if(!write_directory(img,dir))
        return 0;

    return 1;
}


static int move_blocks(
    FILE *img,
    uint16_t src,
    uint16_t dst,
    uint16_t count)
{
    uint8_t buffer[BLOCK_SIZE];

    for(uint16_t i=0;i<count;i++)
    {
        fseek(img,
              (long)(src+i)*BLOCK_SIZE,
              SEEK_SET);

        if(fread(buffer,1,BLOCK_SIZE,img)!=BLOCK_SIZE)
            return 0;

        fseek(img,
              (long)(dst+i)*BLOCK_SIZE,
              SEEK_SET);

        if(fwrite(buffer,1,BLOCK_SIZE,img)!=BLOCK_SIZE)
            return 0;
    }

    return 1;
}

int compress_image(FILE *img)
{
    NSDirEntry dir[DIR_ENTRIES];

    long total_blocks;
    uint8_t *image;
    long image_size;

    if (!read_directory(img, dir))
        return 0;

    uint16_t next_block = 4;

    for (int i = 1; i < DIR_ENTRIES; i++)
    {
        if (dir[i].name[0] == ' ')
            continue;

        if (dir[i].start_block == 4)
        {
            next_block = dir[i].start_block +
                         dir[i].length;
            break;
        }
    }

    if (!read_directory(img, dir))
        return 0;

    total_blocks = image_blocks(img);
    image_size = total_blocks * BLOCK_SIZE;

    image = malloc(image_size);

    if (!image)
    {
        fprintf(stderr, "Out of memory\n");
        return 0;
    }

    rewind(img);

    if (fread(image, 1, image_size, img) != (size_t)image_size)
    {
        free(image);
        return 0;
    }

    uint8_t *new_image = calloc(1, image_size);

    if (!new_image)
    {
        free(image);
        return 0;
    }

    /* preserve directory area */
   // memcpy(new_image,
   //        image,
   //        DIR_BLOCKS * BLOCK_SIZE);
   memcpy(new_image, image, image_size);

    for (int i = 1; i < DIR_ENTRIES; i++)
    {
        if (dir[i].name[0] == ' ')
            continue;

        if (dir[i].start_block <= 4)
            continue;

        uint16_t old_start =
            dir[i].start_block;

        uint16_t len =
            dir[i].length;

        long old_offset =
            (long)old_start * BLOCK_SIZE;

        long new_offset =
            (long)next_block * BLOCK_SIZE;

        long bytes =
            (long)len * BLOCK_SIZE;

        if ((new_offset + bytes) > image_size)
        {
            free(image);
            free(new_image);
            return 0;
        }

        memmove(new_image + new_offset,
                image + old_offset,
                bytes);

        dir[i].start_block = next_block;

        next_block += len;
    }

    /* write updated directory into memory image */
    memcpy(new_image,
           dir,
           sizeof(dir));

    rewind(img);

    if (fwrite(new_image,
               1,
               image_size,
               img) != (size_t)image_size)
    {
        free(image);
        free(new_image);
        return 0;
    }

    fflush(img);

    free(image);
    free(new_image);

    return 1;
}

static void usage(void)
{
    printf(
        "North Star DOS utility\n\n"

        "Usage:\n"
        "  nsedit dir image.nsi\n"
        "  nsedit extract image.nsi DOSNAME outfile\n"
        "  nsedit insert image.nsi infile DOSNAME GOADDRESS\n"
        "  nsedit compress image.nsi\n"
        "  nsedit delete image.nsi DOSNAME\n");
}


int main(int argc,char *argv[])
{
    FILE *img;

    NSDirEntry dir[DIR_ENTRIES];

    if(argc < 3)
    {
        usage();
        return 1;
    }

    if(strcmp(argv[1],"dir")==0)
    {
        img=fopen(argv[2],"rb");

        if(!img)
        {
            perror(argv[2]);
            return 1;
        }
        
        heading_summary(img);
        list_directory(img);
        fclose(img);

        return 0;
    }

    if(strcmp(argv[1],"extract")==0)
    {
        if(argc!=5)
        {
            usage();
            return 1;
        }

        img=fopen(argv[2],"rb");

        if(!img)
        {
            perror(argv[2]);
            return 1;
        }

        heading_summary(img);
        read_directory(img,dir);

        int idx=find_entry(dir,argv[3]);

        if(idx<0)
        {
            fprintf(stderr,"File not found\n");
            fclose(img);
            return 1;
        }

        if(!extract_file(
                img,
                &dir[idx],
                argv[4]))
        {
            fprintf(stderr,"Extract failed\n");
        } else  printf ("Extract OK\n");

        fclose(img);

        return 0;
    }

    if(strcmp(argv[1],"insert")==0)
    {
        if(argc!=5 && argc!=6)
        {
            usage();
            return 1;
        }

        uint16_t goaddr = 0;

        if(argc == 6)
        {
            char *end;

            goaddr = (uint16_t)strtoul(
                            argv[5],
                            &end,
                            16);

            if(*end)
            {
                fprintf(stderr,
                        "Invalid GO address\n");
                return 1;
            }
        } else {
                fprintf(stderr,
                        "WARNING - Setting GO address to 0\n");
        }

        img=fopen(argv[2],"r+b");

        if(!img)
        {
            perror(argv[2]);
            return 1;
        }

        heading_summary(img);
        compress_image(img);
        if(!insert_file(
                img,
                argv[3],
                argv[4],
                goaddr))
        {
            fprintf(stderr,"Insert failed\n");
        } else  printf ("Insert OK\n");

        fclose(img);

        return 0;
    }

    if(strcmp(argv[1],"compress")==0)
    {
        if(argc!=3)
        {
            usage();
            return 1;
        }
  
        img=fopen(argv[2],"r+b");
  
        if(!img)
        {
            perror(argv[2]);
            return 1;
        }
  
        heading_summary(img);
        if(!compress_image(img))
        {
            fprintf(stderr,
                    "Compression failed\n");
        } else  printf ("Compression OK\n");
  
        fclose(img);
  
        return 0;
    }


    if(strcmp(argv[1],"delete")==0)
    {
        if(argc!=4)
        {
            usage();
            return 1;
        }

        img=fopen(argv[2],"r+b");

        if(!img)
        {
            perror(argv[2]);
            return 1;
        }

        heading_summary(img);
        read_directory(img,dir);

        int idx=find_entry(dir,argv[3]);

        if(idx<0)
        {
            fprintf(stderr,"File not found\n");
            fclose(img);
            return 1;
        }

        if(!delete_file(img,dir,idx))
        {
            fprintf(stderr,"Delete failed\n");
        } else  printf ("Delete OK\n");

        fclose(img);

        return 0;
    }

    usage();

    return 1;
}
