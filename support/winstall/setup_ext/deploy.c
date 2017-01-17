#include <stdio.h>
#include <unistd.h>
#include <malloc.h>
#include <windows.h>

void sendinfo(void);

const int N_FILES = 44;
const char TOKEN = '~';
char * fileNames[] = {
    "abc80.cfg",
    "aceansi.cfg",
    "aquansi.cfg",
    "aquarius.cfg",
    "c128ansi.cfg",
    "cpc.cfg",
    "cpcansi.cfg",
    "cpm.cfg",
    "embedded.cfg",
    "m5.cfg",
    "msx.cfg",
    "mz.cfg",
    "mzansi.cfg",
    "nasansi.cfg",
    "nascom.cfg",
    "nc.cfg",
    "ozansi.cfg",
    "pps.cfg",
    "ppsansi.cfg",
    "rex.cfg",
    "rexlib.cfg",
    "sam.cfg",
    "samansi.cfg",
    "svi.cfg",
    "ti82.cfg",
    "ti82ansi.cfg",
    "ti83.cfg",
    "ti83ansi.cfg",
    "ti85.cfg",
    "ti85ansi.cfg",
    "ti86.cfg",
    "ti86ansi.cfg",
    "ti8x.cfg",
    "ti8xansi.cfg",
    "vz.cfg",
    "vzansi.cfg",
    "z88.cfg",
    "z88ansi.cfg",
    "z88net.cfg",
    "zcc.cfg",
    "zx.cfg",
    "zx81.cfg",
    "zx81ansi.cfg",
    "zxansi.cfg"
};

int main(int argc, char  * argv[]) {

    int i = 0;
    FILE *fin ,*fout;
    char ch;
    char *destdirname;
    char *destfilename;

    if (argc != 2) {
        printf("\nImproper command: specify the installation directory.\n");
        sleep(7000);
        exit(-1);
    }
    printf("\nInstalling in \"%s\"...\n\n", argv[1]);

    destdirname = calloc(MAX_PATH + 1, sizeof(char));
    GetShortPathName(argv[1], destdirname, MAX_PATH);
    for (i = 0; i < N_FILES; i++) {
        destfilename = calloc(MAX_PATH + 1, sizeof(char));
        strncpy(destfilename, destdirname, MAX_PATH);
        strcat(destfilename, "\\LIB\\CONFIG\\");
        strcat(destfilename, fileNames[i]);
        if ((fin = fopen(fileNames[i], "r")) == NULL) {
            printf("\nError opening file %s\n", fileNames[i]);
            sendinfo();
            exit(2);
        }
        if ((fout = fopen(destfilename, "w")) == NULL) {
            printf("\nError creating file %s\n", destfilename);
            sendinfo();
            exit(3);
        }

        printf("\tprocessing \"%s\"\n", fileNames[i]);
        while ((ch = getc(fin)) != EOF) {
            if (ch == TOKEN) {
                fputs(destdirname, fout);
            } else {
                putc(ch, fout);
            }
        }

        fclose(fin);
        fclose(fout);
        free(destfilename);
    }
    printf("\n...done!\n\n", argv[1]);
    return 0;
}

void sendinfo(void) {
    printf("\nPlease send info about this error to mzaniboni@hotmail.com\n");
    printf("Thanks :-)\n");
    sleep(10000);
}
