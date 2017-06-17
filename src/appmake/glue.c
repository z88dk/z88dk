/*
*      Join output binaries together into a single monolithic one
*
*      Section names containing "BANK_XX" where "XX" is a hex number 00-FF
*      are assumed to be part of memory bank XX.
*
*      Section names containing "align_dd" where "dd" is a decimal number
*      are assumed to be sections aliged to dd.  These sections' org
*      addresses will be check for proper alignment.
*      
*      aralbrec - June 2017
*/

#include "appmake.h"

static char              help = 0;
static char             *binname = NULL;
static char             *crtfile = NULL;
static int               romfill = 255;
static char              ihex = 0;
static char              clean = 0;


/* Options that are available for this module */
option_t glue_options[] = {
    { 'h', "help",      "Display this help",                 OPT_BOOL,  &help },
    { 'b', "binfile",   "Basename of binary output files (required)",   OPT_STR,   &binname },
    { 'c', "crt0file",  "crt0 used to link binaries (required)",        OPT_STR,   &crtfile },
    { 'f', "filler",    "Filler byte (default: 0xFF)",       OPT_INT,   &romfill },
    {  0,  "ihex",      "Generate an iHEX file",             OPT_BOOL,  &ihex },
    {  0,  "clean",     "Remove binary files when finished", OPT_BOOL,  &clean },
    {  0,  NULL,        NULL,                                OPT_NONE,  NULL }
};


/*
* Execution starts here
*/


struct binary_blob {
    char *filename;
    char *section_name;
    int   org;
    int   size;
};

struct {
    int   num;
    struct binary_blob *array;
} memory_banks[257];

struct aligned_blob {
    char *section_name;
    int   alignment;
    int   org;
    int   size;
};

struct {
    int num;
    struct aligned_blob *array;
} aligned_sections;

int compare_bank(const struct binary_blob *a, const struct binary_blob *b)
{
    return a->org - b->org;
}

int compare_aligned(const struct aligned_blob *a, const struct aligned_blob *b)
{
    return strcmp(a->section_name, b->section_name);
}

int glue_exec(char *target)
{
    int i, j, k, bank;
    char *p;
    FILE *fin, *fout;
    char buffer[LINEMAX + 1];
    char filename[FILENAME_MAX * 2 + 1];
    char symbol_name[LINEMAX];
    long symbol_value;
    struct stat st_file;

    if (help) return -1;
    if ((crtfile == NULL) || (binname == NULL)) return -1;

    strcpy(filename, crtfile);
    suffix_change(filename, ".map");

    // formally initialize state even though not strictly necessary

    memset(memory_banks, 0, sizeof(memory_banks));
    memset(&aligned_sections, 0, sizeof(aligned_sections));

    // iterate over map file

    if ((fin = fopen(filename, "r")) == NULL)
        exit_log(1, "Error: cannot open map file %s\n", filename);

    while (fgets(buffer, LINEMAX, fin) != NULL)
    {
        if (sscanf(buffer, "%s = $%lx", symbol_name, &symbol_value) == 2)
        {
            // symbol and value have been read

            i = strlen(symbol_name);
            if ((i > 7) && (strncmp(symbol_name, "__", 2) == 0) && ((strcmp(symbol_name + i - 5, "_head") == 0) || (strcmp(symbol_name + i - 5, "_size") == 0)))
            {
                // section found, check if there's a corresponding binary file

                symbol_name[i - 5] = 0;
                sprintf(filename, "%s_%s.bin", binname, &symbol_name[2]);

                if ((strcmp(symbol_name + i - 4, "head") == 0) && (stat(filename, &st_file) >= 0))
                {
                    // found a section binary, find out which memory bank it belongs to

                    bank = 256;
                    if (p = strstr(symbol_name, "BANK_"))
                        if (sscanf(p, "BANK_%x", &bank) != 1)
                            bank = -1;

                    if ((bank < 0) || (bank > 256))
                    {
                        bank = 256;
                        fprintf(stderr, "Warning: section %s is being placed in the main bank\n", &symbol_name[2]);
                    }

                    // add binary info to corresponding memory bank list

                    j = memory_banks[bank].num++;
                    memory_banks[bank].array = realloc(memory_banks[bank].array, (j + 1) * sizeof(struct binary_blob));

                    if (memory_banks[bank].array == NULL)
                        exit_log(1, "Error: out of memory\n");

                    memory_banks[bank].array[j].filename = strdup(filename);
                    memory_banks[bank].array[j].org = symbol_value;
                    memory_banks[bank].array[j].size = st_file.st_size;
                    memory_banks[bank].array[j].section_name = strdup(&symbol_name[2]);

                    if ((memory_banks[bank].array[j].filename == NULL) || (memory_banks[bank].array[j].section_name == NULL))
                        exit_log(1, "Error: out of memory\n");
                }

                // record aligned section

                if ((p = strstr(symbol_name, "align_")) && (sscanf(p, "align_%u", &j) == 1))
                {
                    // look for existing entry for aligned section

                    for (k = 0; k < aligned_sections.num; ++k)
                        if (strcmp(aligned_sections.array[k].section_name, &symbol_name[2]) == 0)
                            break;

                    // if no existing entry, make a new one

                    if (k >= aligned_sections.num)
                    {
                        k = aligned_sections.num++;
                        aligned_sections.array = realloc(aligned_sections.array, (k + 1) * sizeof(struct aligned_blob));

                        if (aligned_sections.array == NULL)
                            exit_log(1, "Error: out of memory\n");

                        aligned_sections.array[k].section_name = strdup(&symbol_name[2]);
                        aligned_sections.array[k].alignment = j;
                        aligned_sections.array[k].org = -1;
                        aligned_sections.array[k].size = 0;

                        if (aligned_sections.array[k].section_name == NULL)
                            exit_log(1, "Error: out of memory\n");
                    }

                    if (strcmp(symbol_name + i - 4, "head") == 0)
                        aligned_sections.array[k].org = symbol_value;
                    else
                        aligned_sections.array[k].size = symbol_value;
                }
            }
        }
        else
        {
            for (p = buffer; isspace(*p); ++p);

            if (*p)
                fprintf(stderr, "Warning: unable to parse line from map file\n\t%s\n", buffer);
        }
    }

    fclose(fin);

    // sort the memory banks and look for overlaps

    for (i = 0; i < sizeof(memory_banks) / sizeof(*memory_banks); ++i)
    {
        if (memory_banks[i].num > 0)
        {
            qsort(memory_banks[i].array, memory_banks[i].num, sizeof(struct binary_blob), compare_bank);

            k = 0;
            for (j = 0; j < memory_banks[i].num; ++j)
            {
                if ((memory_banks[i].array[j].org + memory_banks[i].array[j].size) > 0xffff)
                {
                    fprintf(stderr, "Error: section %s overruns 64k memory space [0x%04x,0x%04x]\n", memory_banks[i].array[j].section_name, memory_banks[i].array[j].org, memory_banks[i].array[j].org + memory_banks[i].array[j].size - 1);
                    k = 1;
                    break;
                }

                if (j > 0)
                {
                    if (memory_banks[i].array[j].org < (memory_banks[i].array[j - 1].org + memory_banks[i].array[j - 1].size))
                    {
                        fprintf(stderr, "Error: section %s overlaps section %s by %d bytes\n", memory_banks[i].array[j - 1].section_name, memory_banks[i].array[j].section_name, memory_banks[i].array[j - 1].org + memory_banks[i].array[j - 1].size - memory_banks[i].array[j].org);
                        k = 1;
                    }
                }
            }
        }
    }

    // look for alignment errors

    if (aligned_sections.num > 0)
    {
        qsort(aligned_sections.array, aligned_sections.num, sizeof(struct aligned_blob), compare_aligned);

        for (i = 0; i < aligned_sections.num; ++i)
        {
            if ((aligned_sections.array[i].size > 0) && (aligned_sections.array[i].org & (aligned_sections.array[i].alignment - 1)))
                fprintf(stderr, "Warning: section %s at address 0x%04x is not properly aligned\n", aligned_sections.array[i].section_name, aligned_sections.array[i].org);
        }
    }

    if (k) exit_log(1, "Aborting... errors in one or more binaries\n");

    // generate output binaries

    for (i = 0; i < sizeof(memory_banks) / sizeof(*memory_banks); ++i)
    {
        if (memory_banks[i].num > 0)
        {
            sprintf(filename, (i == 256) ? "%s__.bin" : "%s__%02x.bin", binname, i);

            if ((fout = fopen(filename, "wb")) == NULL)
                fprintf(stderr, "Error: cannot create file %s, skipping\n", filename);
            else
            {
                printf("Creating %s (org 0x%04x)\n", filename, memory_banks[i].array[0].org);

                for (j = 0; j < memory_banks[i].num; ++j)
                {
                    if ((fin = fopen(memory_banks[i].array[j].filename, "rb")) == NULL)
                    {
                        fprintf(stderr, "Error: removing %s, cannot read input file %s\n", filename, memory_banks[i].array[j].filename);
                        fclose(fout);
                        fout = NULL;
                        remove(filename);
                        break;
                    }
                    else
                    {
                        // pad

                        if (j > 0)
                        {
                            k = memory_banks[i].array[j].org - memory_banks[i].array[j - 1].org - memory_banks[i].array[j - 1].size;
                            while (k-- > 0)
                                fputc(romfill, fout);
                        }

                        // write

                        while ((k = fgetc(fin)) != EOF)
                            fputc(k, fout);

                        fclose(fin);
                    }
                }

                if (fout != NULL)
                {
                    fclose(fout);

                    if (ihex)
                    {
                        fin = fopen(filename, "rb");
                        suffix_change(filename, ".ihx");

                        if (fin == NULL)
                            fprintf(stderr, "Unable to create ihx file %s\n", filename);
                        else
                        {
                            if ((fout = fopen(filename, "wb")) == NULL)
                            {
                                fclose(fin);
                                fprintf(stderr, "Unable to create ihx file %s\n", filename);
                            }
                            else
                            {
                                bin2hex(fin, fout, memory_banks[i].array[0].org);
                                fclose(fin);
                                fclose(fout);
                            }
                        }
                    }
                }
            }
        }
    }

    // clean

    free(aligned_sections.array);

    for (i = 0; i < sizeof(memory_banks) / sizeof(*memory_banks); ++i)
    {
        if (clean)
        {
            for (j = 0; j < memory_banks[i].num; ++j)
                remove(memory_banks[i].array[j].filename);
        }

        free(memory_banks[i].array);
    }

    return 0;
}
