/* main.c */
extern void ccabort(void);



extern void dumplits(int size, int pr_label, int queueptr, int queuelab, unsigned char *queue);
extern int dumpzero(int size, int count);
extern void openin(void);
extern void newfile(void);
extern void doinclude(void);
extern void endinclude(void);
extern void closeout(void);
extern void *mymalloc(size_t);
extern void ParseArgs(char *arg);
extern void WriteDefined(char *sname, int value);

extern int c_notaltreg;
extern int c_makeshare;
extern int c_useshared;
extern int c_shared_file;

