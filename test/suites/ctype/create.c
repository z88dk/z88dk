/* Tool to create test files for the is* functions (uses host tools) */


#include <stdio.h>
#include <ctype.h>




void build_file(char *name, int (*func)(int))
{
    char    file[FILENAME_MAX+1];
    char    ident[20];
    char    fname[100];
    FILE   *fp;
    int     i,res;


    snprintf(file,sizeof(file),"test_%s.c",name);
    fp = fopen(file,"w");
    if ( fp != NULL ) {
        fprintf(fp,"\n#include \"ctype_test.h\"\n");
        for ( i = 0; i < 256; i++ ) {
            snprintf(ident, sizeof(ident),"0x%02x",i);
            snprintf(fname, sizeof(fname),"%s_%s",name,ident);
            if ( isprint(i) && i != '"' && i != '\\' ) {
                snprintf(ident,sizeof(ident),"%c",i);
            }
            fprintf(fp,"void t_%s()\n{\n", fname);
            res = func(i) ? 1 : 0;
            fprintf(fp,"    Assert(%s(%d) %s,\"%s should be %d for %s\");\n",name, i, res == 0 ? " == 0 " : "", name, res, ident);
            fprintf(fp,"}\n\n");

        }

        fprintf(fp,"\n\n");
        fprintf(fp,"int test_%s()\n{\n",name);
        fprintf(fp,"    suite_setup(\"%s\");\n",name);

        for ( i = 0; i < 256; i++ ) {
            snprintf(ident, sizeof(ident),"0x%02x",i);
            fprintf(fp,"    suite_add_test(t_%s_%s);\n", name, ident);
        }

        fprintf(fp,"     return suite_run();\n}\n");
        fclose(fp);
    }
}



int main(int argc, char *argv)
{
    build_file("isalnum",isalnum);
    build_file("isalpha",isalpha);
    build_file("isupper", isupper);
    build_file("islower", islower);
    build_file("isdigit", isdigit);
    build_file("isxdigit", isxdigit);
    build_file("isspace", isspace);
    build_file("ispunct", ispunct);
    build_file("isprint", isprint);
    build_file("iscntrl", iscntrl);
    build_file("isgraph", isgraph);
    build_file("isascii", isascii);
}
