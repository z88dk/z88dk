/* MP/M page relocatable program from images linked at 0x100 and 0x200. */

#include "appmake.h"

static char *binname;
static char *outfile;
static char *compare_name;
static char *mapbase;
static int buffer_size;
static char help;

option_t prl_options[] = {
    { 'h', "help",        "Display this help", OPT_BOOL, &help },
    { 'b', "binfile",     "Linked binary file", OPT_STR, &binname },
    { 'o', "output",      "Name of output file", OPT_STR, &outfile },
    { 'p', "compare",     "Same program linked at 0x200", OPT_STR, &compare_name },
    { 'c', "crt0file",    "Basename of the 0x100 map file", OPT_STR, &mapbase },
    {  0,  "buffer-size", "Additional buffer bytes after BSS", OPT_INT, &buffer_size },
    {  0, NULL, NULL, OPT_NONE, NULL }
};

int prl_exec(char *target)
{
    char output[FILENAME_MAX + 1];
    unsigned char header[256] = { 0 };
    unsigned char *image, *bitmap;
    FILE *in, *compare, *out;
    long size, compare_size, bss_head, bss_tail, reserve;
    size_t bitmap_size;
    size_t offset, i, padding;
    int first, second, difference;

    (void)target;
    if (help || !binname || !compare_name || !mapbase)
        return -1;
    if (!strcmp(binname, compare_name))
        exit_log(1, "The comparison file must differ from the 0x100 build\n");

    if (buffer_size < 0 || buffer_size > 65535)
        exit_log(1, "Buffer requirement must fit in 16 bits\n");

    if (strlen(binname) > FILENAME_MAX)
        exit_log(1, "Input filename is too long\n");

    in = fopen(binname, "rb");
    if (!in)
        exit_log(1, "Can't open input file %s\n", binname);
    compare = fopen(compare_name, "rb");
    if (!compare)
        exit_log(1, "Can't open comparison file %s\n", compare_name);
    if (fseek(in, 0, SEEK_END) || (size = ftell(in)) <= 0 || size > 65535 || fseek(in, 0, SEEK_SET))
        exit_log(1, "PRL program size must be between 1 and 65535 bytes\n");
    if (fseek(compare, 0, SEEK_END) || (compare_size = ftell(compare)) != size || fseek(compare, 0, SEEK_SET))
        exit_log(1, "The two builds differ in size\n");

    bss_head = parameter_search(mapbase, ".map", "__BSS_head");
    bss_tail = parameter_search(mapbase, ".map", "__BSS_END_tail");
    if (bss_head < 0x100 || bss_tail < bss_head)
        exit_log(1, "The 0x100 map must contain valid BSS boundaries\n");
    if (size != bss_head - 0x100)
        exit_log(1, "The linked image must end at __BSS_head (use CRT_TRIM_BSS=1)\n");
    reserve = bss_tail - bss_head + buffer_size;
    if (reserve > 65535)
        exit_log(1, "BSS and additional buffer exceed 65535 bytes\n");

    bitmap_size = ((size_t)size + 7) / 8;
    image = malloc((size_t)size ? (size_t)size : 1);
    bitmap = calloc(bitmap_size ? bitmap_size : 1, 1);
    if (!image || !bitmap)
        exit_log(1, "Out of memory\n");
    if (fread(image, 1, (size_t)size, in) != (size_t)size)
        exit_log(1, "Can't read input file\n");
    fclose(in);

    for (offset = 0; offset < (size_t)size; ++offset) {
        first = image[offset];
        second = fgetc(compare);
        if (second == EOF)
            exit_log(1, "Can't read comparison file\n");
        difference = (second - first) & 0xff;
        if (difference == 1)
            bitmap[offset / 8] |= (unsigned char)(0x80 >> (offset % 8));
        else if (difference)
            exit_log(1, "Byte at offset %lu differs by %u, not page relocatable\n",
                     (unsigned long)offset, (unsigned)difference);
    }
    fclose(compare);

    if (outfile) {
        if (strlen(outfile) > FILENAME_MAX)
            exit_log(1, "Output filename is too long\n");
        strcpy(output, outfile);
    } else {
        strcpy(output, binname);
        any_suffix_change(output, ".prl", '.');
    }
    if (!strcmp(output, binname) || !strcmp(output, compare_name))
        exit_log(1, "Output file must differ from input files\n");

    header[1] = (unsigned char)size;
    header[2] = (unsigned char)(size >> 8);
    header[4] = (unsigned char)reserve;
    header[5] = (unsigned char)(reserve >> 8);

    out = fopen(output, "wb");
    if (!out)
        exit_log(1, "Can't open output file %s\n", output);
    padding = (128 - ((sizeof(header) + (size_t)size + bitmap_size) % 128)) % 128;
    if (fwrite(header, 1, sizeof(header), out) != sizeof(header) ||
        fwrite(image, 1, (size_t)size, out) != (size_t)size ||
        fwrite(bitmap, 1, bitmap_size, out) != bitmap_size)
        exit_log(1, "Can't write output file %s\n", output);
    for (i = 0; i < padding; ++i)
        if (fputc(0, out) == EOF)
            exit_log(1, "Can't write output file %s\n", output);
    if (fclose(out) != 0)
        exit_log(1, "Can't write output file %s\n", output);

    free(image);
    free(bitmap);
    return 0;
}
