/* sym.c */
extern int hash(char *sname);
extern SYMBOL *findstc(char *sname);
extern SYMBOL *findglb(char *sname);
extern SYMBOL *findenum(char *sname);
extern SYMBOL *findloc(char *sname);
extern TAG_SYMBOL *findtag(char *sname);
extern SYMBOL *findmemb(TAG_SYMBOL *tag, char *sname);
extern SYMBOL *addglb(char *sname, char id, char typ, int value, int storage, int more, int itag);
extern SYMBOL *addloc(char *sname, char id, char typ, int more, int itag);
extern SYMBOL *addmemb(char *sname, char id, char typ, int value, int storage, int more, int itag);
extern void addsym(SYMBOL *ptr, char *sname, char id, char typ, int storage, int more, int itag);
