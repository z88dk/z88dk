# lstdeps.awk -- expand a z80asm @list-file into its source closure,
#                for use as make prerequisites.
#
#   awk -v INC="..:." -f lstdeps.awk crt0_z80.lst
#
# Mirrors Options::expand_list_glob / search_source in src/z80asm/src/options.cpp:
#   - ${VAR} expanded from the environment          (expand_env_vars)
#   - blank, ';' and '#' lines skipped              (comments)
#   - '-' and '+' lines are options, not files      (parse_option)
#   - '@file' recurses                              (expand_list_glob)
#   - a bare name resolves as X then X.asm, each tried in CWD
#     then in the include path                      (search_source)
#   - while a list file is open, its own directory is on the include
#     path, and is popped again afterwards
#
# Emits one source path per line. Entries that only resolve to a
# prebuilt .o (another sublibrary's output) are emitted to stderr with
# an "OBJ " prefix so the caller can decide what to do with them.

# Diagnostics. Written through a pipe rather than to "/dev/stderr", which
# is a gawk/mawk extension that one-true-awk (macOS, *BSD) only honours when
# the OS happens to provide the device node.
function warn(msg) {
    print msg | "cat 1>&2"
    _warned = 1
}

function expandvars(s,   out, pre, name, rest, i) {
    out = ""
    while ((i = index(s, "${")) > 0) {
        pre  = substr(s, 1, i - 1)
        rest = substr(s, i + 2)
        if ((i = index(rest, "}")) == 0) { out = out pre "${"; s = rest; continue }
        name = substr(rest, 1, i - 1)
        s    = substr(rest, i + 1)
        out  = out pre ENVIRON[name]
    }
    return out s
}

# collapse repeated slashes, as z80asm's norm_filename does
function normpath(p) {
    while (p ~ /\/\//) gsub(/\/\//, "/", p)
    return p
}

function dirname(p,   i) {
    i = length(p)
    while (i > 0 && substr(p, i, 1) != "/") i--
    return (i > 0) ? substr(p, 1, i - 1) : "."
}

function exists(p) {
    if (!(p in _stat)) _stat[p] = ((getline _junk < p) >= 0)
    close(p)
    return _stat[p]
}

# try a candidate name against CWD and every include dir; return path or ""
function resolve(name,   i, c) {
    if (exists(name)) return name
    for (i = ninc; i >= 1; i--) {           # innermost include dir first
        c = inc[i] "/" name
        if (exists(c)) return c
    }
    return ""
}

function source_of(name,   p) {
    if ((p = resolve(name))      != "") return p
    if ((p = resolve(name ".asm")) != "") return p
    return ""
}

function walk(lst,   line, c, p, self) {
    if (lst in seen_lst) return              # cycle guard
    seen_lst[lst] = 1
    lsts[++nlsts] = lst                      # the .lst files are inputs too

    self = dirname(lst)
    inc[++ninc] = self                       # push list file's own dir

    while ((getline line < lst) > 0) {
        gsub(/\r/, "", line)
        line = normpath(expandvars(line))
        sub(/^[ \t]+/, "", line); sub(/[ \t]+$/, "", line)
        if (line == "")                      continue
        if (line ~ /^[;#]/)                  continue
        if (line ~ /^[-+]/)                  continue      # option, not a file
        if (line ~ /[*?]/)  { warn("GLOB " line); continue }

        if (substr(line, 1, 1) == "@") {
            c = substr(line, 2)
            sub(/^[ \t]+/, "", c)
            p = resolve(c)
            if (p == "") { warn("MISSING-LST " c); continue }
            walk(p)
            continue
        }

        p = source_of(line)
        if (p != "")                    { if (ONLY_LSTS == "") print p }
        else if (resolve(line ".o") != "") warn("OBJ " line)
        else                              warn("MISSING " line)
    }
    close(lst)

    ninc--                                   # pop
}

BEGIN {
    ninc = 0
    if (INC != "") { n = split(INC, a, ":"); for (i = 1; i <= n; i++) if (a[i] != "") inc[++ninc] = a[i] }
    for (i = 1; i < ARGC; i++) walk(ARGV[i])
    if (EMIT_LSTS != "") for (i = 1; i <= nlsts; i++) print lsts[i]
    if (_warned) close("cat 1>&2")
    exit 0
}
