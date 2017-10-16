/* sym.c */
extern SYMBOL *findstc(char *sname);
extern SYMBOL *findglb(const char *sname);
extern SYMBOL *findenum(char *sname);
extern SYMBOL *findloc(char *sname);
extern SYMBOL *addglb(char *sname, enum ident_type id, char typ, int value, enum storage_type storage);
extern SYMBOL *addloc(char *sname, enum ident_type id, char typ);
