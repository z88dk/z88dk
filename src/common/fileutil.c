//-----------------------------------------------------------------------------
// file utilities
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "die.h"
#include "fileutil.h"
#include "strpool.h"
#include "strutil.h"
#include "utstring.h"
#include "xassert.h"
#include <ctype.h>
#include <dirent.h>
#include <string.h>

#ifndef WIN32
#include <unistd.h>
#endif

//-----------------------------------------------------------------------------
// pathname manipulation 
//-----------------------------------------------------------------------------
#define isslash(x)	((x) == '/' || (x) == '\\')

static void str_path_canon(UT_string *path)
{
	// remove double slashes and normalize forward slashes
	char *s = utstring_body(path);
	char *d = utstring_body(path);
	while (*s) {
		if (isslash(*s)) {
			*d++ = '/';
			while (*s && isslash(*s))
				s++;
		}
		else {
			while (*s && !isslash(*s))
				*d++ = *s++;
		}
	}
	*d = '\0';

	// skip initial volume, root dir, or parent dir
	char *p = utstring_body(path);
	if (isalpha(p[0]) && p[1] == ':') p += 2;			// win32 volume
	if (*p == '/')
		p++;											// root dir
	else
		while (strncmp(p, "../", 3) == 0)				// ../ at start cannot be removed
			p += 3;
	char *root = p;

	// remove "./" and "xxx/.."
	while (*p) {
		if (*p == '/') {
			p++;
		}
		else if (strncmp(p, "./", 2) == 0) {			// remove ./
			memmove(p, p + 2, strlen(p + 2) + 1);		// copy also null
		}
		else if (strcmp(p, ".") == 0) {					// remove final .
			*p = '\0';
		}
		else {
			char *p1 = p;
			while (*p && *p != '/') 
				p++;
			if (strncmp(p, "/../", 4) == 0) {
				memmove(p1, p + 4, strlen(p + 4) + 1);	// copy also null
				p = root;								// need to check again
			}
			else if (strcmp(p, "/..") == 0) {
				p = p1;
				*p = '\0';
			}
			else {
				;	// p points to the '/' or '\0'
			}
		}
	}

	// remove trailing slashes
	while (p - 1 > root && p[-1] == '/') {
		p--; 
		*p = '\0';
	}
	utstring_len(path) = p - utstring_body(path);

    if (utstring_len(path) == 0)			// dir is now empty
        utstring_printf(path, ".");
}

static const char *path_canon_sep(const char *path, char win32_sep)
{
    UT_string* canon;
    utstring_new(canon);
    utstring_printf(canon, "%s", path);
	str_path_canon(canon);

#ifdef _WIN32
	char *p = utstring_body(canon);
	while ((p = strchr(p, '/')) != NULL)
		*p++ = win32_sep;
#endif

	const char *ret = spool_add(utstring_body(canon));
	utstring_free(canon);
	return ret;
}

const char *path_canon(const char *path)
{
	return path_canon_sep(path, '/');
}

const char *path_os(const char *path)
{
	return path_canon_sep(path, '\\');
}

const char *path_combine(const char *path1, const char *path2)
{
    UT_string* path;
    utstring_new(path);
    utstring_printf(path, "%s/", path1);

	if (isalpha(path2[0]) && path2[1] == ':') {	        // remove ':'
        utstring_printf(path, "%.*s", 1, path2);		// drive letter
        utstring_printf(path, "/");				        // slash
        utstring_printf(path, "%s", path2 + 2);			// rest of path
	}
	else {
        utstring_printf(path, "%s", path2);
	}

	str_path_canon(path);

	const char *ret = spool_add(utstring_body(path));
	utstring_free(path);
	return ret;
}

const char *remove_extension(const char *path1)
{
	return replace_extension(path1, "");
}

const char *replace_extension(const char *path1, const char *new_ext)
{
    UT_string* path;
    utstring_new(path);
    utstring_printf(path, "%s", path1);
	str_path_canon(path);

	// remove extension
	const char *old_ext = path_ext(path1);
	utstring_len(path) -= strlen(old_ext);
	utstring_body(path)[utstring_len(path)] = '\0';

	// append new extension
	if (*new_ext && *new_ext != '.')
        utstring_printf(path, ".");
    utstring_printf(path, "%s", new_ext);

	const char *ret = spool_add(utstring_body(path));
	utstring_free(path);
	return ret;
}

static char *path_dir_slash(UT_string *path)
{
	str_path_canon(path);

	char *p = utstring_body(path);
	if (isalpha(p[0]) && p[1] == ':')
		p += 2;											// win32 volume
	if (*p == '/')
		p++;											// root dir
	char *root = p;

	p = utstring_body(path) + utstring_len(path) - 1;
	while (p > root && *p != '/')
		p--;

	return p;
}

const char *path_dir(const char *path1)
{
    UT_string* path;
    utstring_new(path);
    utstring_printf(path, "%s", path1);

	char *p = path_dir_slash(path);

	*p = '\0';
	utstring_len(path) = p - utstring_body(path);

	if (utstring_len(path) == 0) 			// dir is now empty
        utstring_printf(path, ".");

	const char *ret = spool_add(utstring_body(path));
	utstring_free(path);
	return ret;
}

const char *path_file(const char *path1)
{
    UT_string* path;
    utstring_new(path);
    utstring_printf(path, "%s", path1);

	char *p = path_dir_slash(path);
	if (*p == '/')
		p++;

	const char *ret = spool_add(p);
	utstring_free(path);
	return ret;
}

const char *path_ext(const char *path)
{
	if (isalpha(path[0]) && path[1] == ':') path += 2;	// win32 volume
	if (isslash(*path)) path++;							// root dir

	const char *p = path + strlen(path) - 1;
	while (p > path && *p != '.' && !isslash(p[-1]))
		p--;
	if (*p == '.' && p > path && !isslash(p[-1]))
		return spool_add(p);
	else
		return spool_add("");
}

//-----------------------------------------------------------------------------
// map fileno(FILE*) to filename in this session
//-----------------------------------------------------------------------------
static argv_t *open_files;		// array indexed by fileno(fp)

static void add_open_file(FILE *stream, const char *filename);
static void file_deinit(void);

static void file_init()
{
	static bool inited = false;
	if (!inited) {
		inited = true;
		atexit(file_deinit);
		open_files = argv_new();
		add_open_file(stdin, "<stdin>");
		add_open_file(stdout, "<stdout>");
		add_open_file(stderr, "<stderr>");
	}
}

static void file_deinit(void)
{
	argv_free(open_files);
}

static void add_open_file(FILE *stream, const char *filename)
{
	file_init();
	xassert(stream);
	argv_set(open_files, fileno(stream), filename);
}

static char *get_filename(FILE *fp)
{
	file_init();
	if (!fp)
		return "?";
	else {
		char *filename = argv_get(open_files, fileno(fp));
		return filename ? filename : "?";
	}
}

//-----------------------------------------------------------------------------
// file IO
//-----------------------------------------------------------------------------
FILE *xfopen(const char *filename, const char *mode)
{
	FILE *stream = fopen(filename, mode);
	if (!stream) {
		perror(filename);
		exit(EXIT_FAILURE);
	}
	add_open_file(stream, filename);
	return stream;
}

void xfclose(FILE *stream)
{
	int rv = fclose(stream);
	if (rv != 0)
		die("file '%s' close failed\n", get_filename(stream));
}

void xfclose_remove_empty(FILE *stream)
{
	char *filename = get_filename(stream);

	xfseek(stream, 0, SEEK_END);
	long size = ftell(stream);
	xfclose(stream);

	if (size == 0 && filename != NULL)
		remove(filename);
}

void xfwrite(const void *ptr, size_t size, size_t count, FILE *stream)
{
	size_t num = fwrite(ptr, size, count, stream);
	if (num != count)
		die("failed to write %u bytes to file '%s'\n", size*count, get_filename(stream));
}

void xfwrite_cstr(const char *str, FILE *stream)
{
	xfwrite_bytes(str, strlen(str), stream);
}

void xfwrite_str(UT_string *str, FILE *stream)
{
	xfwrite_bytes(utstring_body(str), utstring_len(str), stream);
}

void xfwrite_bytes(const void *ptr, size_t count, FILE *stream)
{
	xfwrite(ptr, sizeof(byte_t), count, stream);
}

void xfwrite_bcount_bytes(const void *str, size_t count, FILE *stream)
{
	if (count > 255)
		die("string '%.40s...' too long for byte counted string\n", str);
	xfwrite_byte(count & 0xFF, stream);
	xfwrite_bytes(str, count, stream);
}

void xfwrite_bcount_cstr(const char *str, FILE *stream)
{
	xfwrite_bcount_bytes(str, strlen(str), stream);
}

void xfwrite_bcount_str(UT_string *str, FILE *stream)
{
	xfwrite_bcount_bytes(utstring_body(str), utstring_len(str), stream);
}

void xfwrite_wcount_bytes(const void *str, size_t count, FILE * stream)
{
	if (count > 0xFFFF)
		die("string '%.40s...' too long for word counted string\n", str);
	xfwrite_word((word_t)count, stream);
	xfwrite_bytes(str, count, stream);
}

void xfwrite_wcount_cstr(const char *str, FILE *stream)
{
	xfwrite_wcount_bytes(str, strlen(str), stream);
}

void xfwrite_wcount_str(UT_string *str, FILE *stream)
{
	xfwrite_wcount_bytes(utstring_body(str), utstring_len(str), stream);
}

void xfwrite_byte(byte_t value, FILE *stream)
{
	xfwrite_bytes(&value, 1, stream);
}

void xfwrite_word(word_t value, FILE *stream)
{
	byte_t word[2];
	word[0] = value & 0xFF; value >>= 8;
	word[1] = value & 0xFF; value >>= 8;
	xfwrite_bytes(word, sizeof(word), stream);
}

void xfwrite_dword(int value, FILE *stream)
{
	byte_t dword[4];
	dword[0] = value & 0xFF; value >>= 8;
	dword[1] = value & 0xFF; value >>= 8;
	dword[2] = value & 0xFF; value >>= 8;
	dword[3] = value & 0xFF; value >>= 8;
	xfwrite_bytes(dword, sizeof(dword), stream);
}

void xfread(void *ptr, size_t size, size_t count, FILE *stream)
{
	size_t num = fread(ptr, size, count, stream);
	if (num != count)
		die("failed to read %u bytes from file '%s'\n", size*count, get_filename(stream));
}

void xfread_str(size_t size, UT_string *str, FILE *stream)
{
	utstring_clear(str);
    utstring_reserve(str, size + 1);       // space for '\0'
	xfread(utstring_body(str), sizeof(char), size, stream);
	utstring_len(str) = size;
	utstring_body(str)[utstring_len(str)] = '\0';
}

void xfread_bytes(void *ptr, size_t count, FILE *stream)
{
	xfread(ptr, sizeof(byte_t), count, stream);
}

void xfread_bcount_str(UT_string *str, FILE *stream)
{
	size_t len = xfread_byte(stream);
	xfread_str(len, str, stream);
}

void xfread_wcount_str(UT_string * str, FILE * stream)
{
	size_t len = xfread_word(stream);
	xfread_str(len, str, stream);
}

byte_t xfread_byte(FILE *stream)
{
	byte_t value;
	xfread(&value, sizeof(byte_t), 1, stream);
	return value;
}

word_t xfread_word(FILE * stream)
{
	byte_t word[2];
	xfread(word, sizeof(byte_t), sizeof(word), stream);
	int value =
		((word[0] << 0) & 0x00FF) |
		((word[1] << 8) & 0xFF00);
	if (value & 0x8000)
		value |= ~0xFFFF;			// sign-extend above bit 15

	return value;
}

int xfread_dword(FILE * stream)
{
	byte_t dword[4];
	xfread(dword, sizeof(byte_t), sizeof(dword), stream);
	int value =
		((dword[0] << 0) & 0x000000FFL) |
		((dword[1] << 8) & 0x0000FF00L) |
		((dword[2] << 16) & 0x00FF0000L) |
		((dword[3] << 24) & 0xFF000000L);
	if (value & 0x80000000L)
		value |= ~0xFFFFFFFFL;		// sign-extend above bit 31

	return value;
}

void xfseek(FILE *stream, long offset, int origin)
{
	if (fseek(stream, offset, origin) != 0)
		die("failed to seek to %ld in file '%s'\n", offset, get_filename(stream));
}

//-----------------------------------------------------------------------------
// file read/write
//-----------------------------------------------------------------------------
void file_spew(const char *filename, const char *text)
{
	file_spew_n(filename, text, strlen(text));
}

void file_spew_n(const char *filename, const char *text, size_t size)
{
	FILE *fp = xfopen(filename, "wb");
	xfwrite(text, 1, size, fp);
	xfclose(fp);
}

void file_spew_str(const char *filename, UT_string *str)
{
	file_spew_n(filename, utstring_body(str), utstring_len(str));
}

UT_string *file_slurp(const char *filename)
{
	FILE *fp = xfopen(filename, "rb");

	xfseek(fp, 0, SEEK_END);
	long size = ftell(fp);
	xassert(size >= 0);
	xfseek(fp, 0, SEEK_SET);

    UT_string* text;
    utstring_new(text);
	xfread_str((size_t)size, text, fp);

	xfclose(fp);

	return text;		// user must free
}

//-----------------------------------------------------------------------------
// directories
//-----------------------------------------------------------------------------
static void find_files_1(argv_t *dirs, const char *dirname, bool recursive, bool find_dirs)
{
	DIR *dir = opendir(dirname);
	if (!dir) {
		perror(dirname);
		exit(EXIT_FAILURE);
	}

	struct dirent *entry;
	while ((entry = readdir(dir)) != NULL) {
		if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
			continue;

		const char *name = path_combine(dirname, entry->d_name);
		if (dir_exists(name)) {
			if (find_dirs)
				argv_push(dirs, name);
			if (recursive)
				find_files_1(dirs, name, recursive, find_dirs);
		}
		else if (file_exists(name)) {
			argv_push(dirs, name);
		}
	}

	if (closedir(dir)) {
		perror(dirname);
		exit(EXIT_FAILURE);
	}
}

argv_t *path_find_all(const char *dirname, bool recursive)
{
	argv_t *dirs = argv_new();
	find_files_1(dirs, dirname, recursive, true);
	return dirs;
}

argv_t *path_find_files(const char *dirname, bool recursive)
{
	argv_t *dirs = argv_new();
	find_files_1(dirs, dirname, recursive, false);
	return dirs;
}

static void path_find_glob_1(argv_t *files, const char *pattern)
{
    UT_string* pad;
    utstring_new(pad);

	pattern = path_canon(pattern);
	const char *wc = strpbrk(pattern, "*?");
	if (!wc) {
		if (file_exists(pattern))
			argv_push(files, pattern);		// no wildcard
	}
	else if (strncmp(wc, "**", 2) == 0) {	// star-star - recursively find all subdirs
		char *child = strchr(wc, '/');		// point to slash after star-star

		if (child) {
            utstring_clear(pad);
            utstring_printf(pad, "%.*s%s", (int)(wc - pattern), pattern, child);       // try without star-star
			path_find_glob_1(files, utstring_body(pad));		// recurse
		}

        utstring_clear(pad);
        utstring_printf(pad, "%.*s", (int)(wc - pattern + 1), pattern);
        if (child)
            utstring_printf(pad, "%.*s", (int)(child - (wc + 2)), wc + 2);      // and up to child
		else
            utstring_printf(pad, "%s", wc + 2);
		
		glob_t glob_files;
		int ret = xglob(utstring_body(pad), GLOB_NOESCAPE, NULL, &glob_files);
		if (ret == GLOB_NOMATCH) {				// no match - ignore
			;
		}
		else if (ret == 0) {
			for (int i = 0; i < glob_files.gl_pathc; i++) {
				char *found = glob_files.gl_pathv[i];
				if (dir_exists(found)) {
                    utstring_clear(pad);
                    utstring_printf(pad, "%s/**", found);
					if (child)
                        utstring_printf(pad, "%s", child);
					path_find_glob_1(files, utstring_body(pad));		// recurse
				}
				else {
                    utstring_clear(pad);
                    utstring_printf(pad, "%s", found);
					if (child)
                        utstring_printf(pad, "%s", child);
					path_find_glob_1(files, utstring_body(pad));		// recurse
				}
			}
		}
		else {
			xassert(0);
		}
		globfree(&glob_files);
	}
	else {									// find one level of subdirs
		char *child = strchr(wc, '/');		// point to slash wild card
        if (child) {
            utstring_clear(pad);
            utstring_printf(pad, "%.*s", (int)(child - pattern), pattern);
        }
		else {
            utstring_clear(pad);
            utstring_printf(pad, "%s", pattern);
		}

		glob_t glob_files;
		int ret = xglob(utstring_body(pad), GLOB_NOESCAPE, NULL, &glob_files);
		if (ret == GLOB_NOMATCH) {				// no match - ignore
			;
		}
		else if (ret == 0) {
			for (int i = 0; i < glob_files.gl_pathc; i++) {
				char *found = glob_files.gl_pathv[i];
                utstring_clear(pad);
                utstring_printf(pad, "%s", found);
				if (child)
                    utstring_printf(pad, "%s", child);
				path_find_glob_1(files, utstring_body(pad));		// recurse
			}
		}
		else {
			xassert(0);
		}
		globfree(&glob_files);
	}

	utstring_free(pad);
}

argv_t *path_find_glob(const char *pattern)
{
	argv_t *files = argv_new();
	path_find_glob_1(files, pattern);
	return files;
}

void path_mkdir(const char *path)
{
	path = path_canon(path);
	if (!dir_exists(path)) {
		const char *parent = path_dir(path);
		path_mkdir(parent);

        // #2422 Parallel build issues
        // ignore error if directory exists
        int retval;
#ifdef _WIN32
        retval = _mkdir(path_os(path));
#else
        retval = mkdir(path_os(path), 0777);
#endif
        if (retval != 0 && !dir_exists(path)) {
            perror(path);
            exit(EXIT_FAILURE);
        }
	}
}

void path_rmdir(const char *path)
{
	path = path_canon(path);
	if (dir_exists(path)) {
		// delete all children
		argv_t *files = path_find_all(path, false);
		for (char **p = argv_front(files); *p; p++) {
			if (file_exists(*p))
				xremove(*p);
			else if (dir_exists(*p))
				path_rmdir(*p);
		}
		argv_free(files);

		xrmdir(path);
	}
}

//-----------------------------------------------------------------------------
// file checks
//-----------------------------------------------------------------------------
bool file_exists(const char *filename)
{
	struct stat sb;
	if ((stat(filename, &sb) == 0) && (sb.st_mode & S_IFREG))
		return true;
	else
		return false;
}

bool dir_exists(const char *dirname)
{
	struct stat sb;
	if ((stat(dirname, &sb) == 0) && (sb.st_mode & S_IFDIR))
		return true;
	else
		return false;
}

long file_size(const char *filename)
{
	struct stat sb;
	if ((stat(filename, &sb) == 0) && (sb.st_mode & S_IFREG))
		return sb.st_size;
	else
		return -1;
}

//-----------------------------------------------------------------------------
// file search
//-----------------------------------------------------------------------------
const char *path_search(const char *filename, argv_t *dir_list)
{
	// if no directory list or file exists, return filename
	if (!dir_list || argv_len(dir_list) == 0 || file_exists(filename))
		return path_canon(filename);

	// search in dir list
	for (char **p = argv_front(dir_list); *p; p++) {
		const char *f = path_combine(*p, filename);
		if (file_exists(f))
			return f;
	}

	// not found, return original file name
	return path_canon(filename);
}

bool is_little_endian(void) {
    uint32_t endian = 0x12345678;
    if (*(byte_t*)&endian == 0x78)
        return true;
    else
        return false;
}

int parse_le_int32(const byte_t* mem) {
    int value = 0;
    if (is_little_endian()) {
        // little endian architecture
        value = *(int*)mem;
    }
    else {
        // big endian architecture
        value =
            ((mem[0] << 0) & 0x000000FFL) |
            ((mem[1] << 8) & 0x0000FF00L) |
            ((mem[2] << 16) & 0x00FF0000L) |
            ((mem[3] << 24) & 0xFF000000L);
        if (value & 0x80000000L)
            value |= ~0xFFFFFFFFL;		// sign-extend above bit 31
    }
    return value;
}

void write_le_int32(byte_t* mem, int value) {
    if (is_little_endian()) {
        // little endian architecture
        *(int*)mem = value;
    }
    else {
        // big endian architecture
        mem[0] = (value >> 0) & 0x000000FFL;
        mem[1] = (value >> 8) & 0x000000FFL;
        mem[2] = (value >> 16) & 0x000000FFL;
        mem[3] = (value >> 24) & 0x000000FFL;
    }
}

int check_retval(int retval, const char* file, const char* source_file, int line_num)
{
    if (retval) {
        perror(file);
        exit(EXIT_FAILURE);
    }
    return retval;
}

int xglob(const char* pattern, int flags,
    int(*errfunc)(const char* epath, int eerrno), glob_t* pglob)
{
    int ret = glob(pattern, flags, errfunc, pglob);

#ifdef DEBUG
    printf("GLOB(%s)=", pattern);
    for (int i = 0; i < pglob->gl_pathc; i++) {
        char* found = pglob->gl_pathv[i];
        printf("%s ", found);
    }
    printf("\n");
#endif

    if (ret != GLOB_NOMATCH && ret != 0)
        die("glob pattern '%s': %s\n",
            pattern,
            (ret == GLOB_ABORTED ? "filesystem problem" :
                ret == GLOB_NOSPACE ? "no dynamic memory" :
                "unknown problem"));
    return ret;
}

