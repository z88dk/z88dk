/* sym.c */
extern SYMBOL *findstc(char *sname);
extern SYMBOL *findglb(char *sname);
extern SYMBOL *findenum(char *sname);
extern SYMBOL *findloc(char *sname);
extern TAG_SYMBOL *findtag(char *sname);
extern SYMBOL *findmemb(TAG_SYMBOL *tag, char *sname);
extern SYMBOL *addglb(char *sname, enum ident_type id, char typ, int value, enum storage_type storage, int more, int itag);
extern SYMBOL *addloc(char *sname, enum ident_type id, char typ, int more, int itag);
extern SYMBOL *addmemb(char *sname, enum ident_type id, char typ, int value, enum storage_type storage, int more, int itag);
