# l_push_di / l_pop_ei must return with DE, HL, IX and IY unchanged.
# AF may change. The 8085 bodies also change BC. An unknown opcode fails.
function hex4(s,    i, c, n, d) {
    n = 0
    for (i = 1; i <= 4; i++) {
        c = substr(s, i, 1)
        if (c >= "0" && c <= "9") d = index("0123456789", c) - 1
        else d = index("abcdef", c) + 9
        n = n * 16 + d
    }
    return n
}
function reset_parse(    i) {
    ncode = 0
    nlab = 0
    npend = 0
    delete code
    delete labaddr
    delete labname
    delete isentry
    delete addr_i
    delete nextaddr
    delete labaddr_byname
    delete pend
}
function finish_file(    i, a, st, seen, nstart) {
    if (ncode == 0) return
    nstart = 0
    for (i = 0; i < nlab; i++) {
        a = labaddr[i]
        if (!isentry[i]) continue
        if (seen[a]++) continue
        nstart++
        st = sim(a, labname[i])
        if (st != "") {
            printf "%s: %s\n", srcname, st > "/dev/stderr"
            exit 1
        }
    }
    if (nstart == 0) {
        printf "%s: no push_di or pop_ei entry\n", srcname > "/dev/stderr"
        exit 1
    }
}
function mem_key(    i, n, keys, j, tmp, s) {
    n = 0
    for (i in mem) keys[++n] = i + 0
    for (i = 1; i <= n; i++)
        for (j = i + 1; j <= n; j++)
            if (keys[j] < keys[i]) { tmp = keys[i]; keys[i] = keys[j]; keys[j] = tmp }
    s = ""
    for (i = 1; i <= n; i++)
        s = s keys[i] "=" mem[keys[i]] ";"
    return s
}
function save_state() {
    return hl SUBSEP de SUBSEP ix SUBSEP iy SUBSEP af SUBSEP sp SUBSEP mem_key()
}
function load_mem(s,    n, i, p, eq, k, v) {
    delete mem
    n = split(s, p, ";")
    for (i = 1; i <= n; i++) {
        if (p[i] == "") continue
        eq = index(p[i], "=")
        k = substr(p[i], 1, eq - 1) + 0
        v = substr(p[i], eq + 1)
        mem[k] = v
    }
}
function load_state(s,    p) {
    split(s, p, SUBSEP)
    hl = p[1]; de = p[2]; ix = p[3]; iy = p[4]; af = p[5]; sp = p[6] + 0
    load_mem(p[7])
}
function push_val(v) { sp -= 2; mem[sp] = v }
function pop_val(    v) {
    v = (sp in mem) ? mem[sp] : "?"
    delete mem[sp]
    sp += 2
    return v
}
function swap_top(    t) {
    t = (sp in mem) ? mem[sp] : "?"
    mem[sp] = hl
    hl = t
}
function bad(why) { return why }
function sim(entry, ename,    qh, qt, steps, s, pc, ins, tgt, nxt, k, v, vis) {
    qh = 0; qt = 0
    hl = "H"; de = "D"; ix = "X"; iy = "Y"; af = "F"; sp = 0
    delete mem
    mem[0] = "R"
    # pop_ei is entered with the status word under the return address.
    if (ename ~ /pop_ei$/ && code[entry] == "ex(sp),hl")
        mem[2] = "S"
    queue[qt++] = entry SUBSEP save_state()
    steps = 0
    while (qh < qt) {
        if (++steps > 4000) return ename ": state explosion"
        s = queue[qh++]
        pc = substr(s, 1, index(s, SUBSEP) - 1) + 0
        load_state(substr(s, index(s, SUBSEP) + 1))
        k = pc SUBSEP hl SUBSEP de SUBSEP ix SUBSEP iy SUBSEP af SUBSEP sp SUBSEP mem_key()
        if (vis[k]++) continue
        if (!(pc in code)) return ename ": missing address " pc
        ins = code[pc]
        nxt = nextaddr[pc]
        if (ins == "ret" || ins == "reti" || ins == "retn") {
            if (hl != "H" || de != "D" || ix != "X" || iy != "Y")
                return ename ": " ins " leaves hl=" hl " de=" de " ix=" ix " iy=" iy
            continue
        }
        if (ins == "rim" || ins == "scf" || ins == "ccf") {
            af = "?"
            if (nxt < 0) return ename ": fall off after " ins
            queue[qt++] = nxt SUBSEP save_state()
            continue
        }
        if (ins == "di" || ins == "ei" || ins == "nop" || ins == "ipres" ||
            ins ~ /^ipset/) {
            if (nxt < 0) return ename ": fall off after " ins
            queue[qt++] = nxt SUBSEP save_state()
            continue
        }
        if (ins == "decsp") { sp -= 1
            if (nxt < 0) return ename ": fall off after dec sp"
            queue[qt++] = nxt SUBSEP save_state(); continue }
        if (ins == "incsp") { sp += 1
            if (nxt < 0) return ename ": fall off after inc sp"
            queue[qt++] = nxt SUBSEP save_state(); continue }
        if (ins == "ex(sp),hl") { swap_top()
            if (nxt < 0) return ename ": fall off after ex (sp),hl"
            queue[qt++] = nxt SUBSEP save_state(); continue }
        if (ins == "exde,hl") { t = de; de = hl; hl = t
            if (nxt < 0) return ename ": fall off after ex de,hl"
            queue[qt++] = nxt SUBSEP save_state(); continue }
        if (ins == "pushhl") { push_val(hl); queue[qt++] = nxt SUBSEP save_state(); continue }
        if (ins == "pushde") { push_val(de); queue[qt++] = nxt SUBSEP save_state(); continue }
        if (ins == "pushix") { push_val(ix); queue[qt++] = nxt SUBSEP save_state(); continue }
        if (ins == "pushiy") { push_val(iy); queue[qt++] = nxt SUBSEP save_state(); continue }
        if (ins == "pushaf") { push_val(af); queue[qt++] = nxt SUBSEP save_state(); continue }
        if (ins == "pushbc") { push_val("B"); queue[qt++] = nxt SUBSEP save_state(); continue }
        if (ins == "pophl") { hl = pop_val(); queue[qt++] = nxt SUBSEP save_state(); continue }
        if (ins == "popde") { de = pop_val(); queue[qt++] = nxt SUBSEP save_state(); continue }
        if (ins == "popix") { ix = pop_val(); queue[qt++] = nxt SUBSEP save_state(); continue }
        if (ins == "popiy") { iy = pop_val(); queue[qt++] = nxt SUBSEP save_state(); continue }
        if (ins == "popaf") { af = pop_val(); queue[qt++] = nxt SUBSEP save_state(); continue }
        if (ins == "popbc") { pop_val(); queue[qt++] = nxt SUBSEP save_state(); continue }
        if (ins ~ /^ldhl,/) { hl = "?"; queue[qt++] = nxt SUBSEP save_state(); continue }
        if (ins ~ /^ldde,/) { de = "?"; queue[qt++] = nxt SUBSEP save_state(); continue }
        if (ins ~ /^ldix,/) { ix = "?"; queue[qt++] = nxt SUBSEP save_state(); continue }
        if (ins ~ /^ldiy,/) { iy = "?"; queue[qt++] = nxt SUBSEP save_state(); continue }
        if (ins ~ /^ldh,/ || ins ~ /^ldl,/ || ins ~ /^ldixh,/ || ins ~ /^ldixl,/ ||
            ins ~ /^ldiyh,/ || ins ~ /^ldiyl,/) {
            if (ins ~ /^ldh,/ || ins ~ /^ldl,/) hl = "?"
            if (ins ~ /^ldix/) ix = "?"
            if (ins ~ /^ldiy/) iy = "?"
            queue[qt++] = nxt SUBSEP save_state(); continue
        }
        if (ins ~ /^ldd,/ || ins ~ /^lde,/) { de = "?"; queue[qt++] = nxt SUBSEP save_state(); continue }
        if (ins ~ /^lda,/ || ins == "rim" || ins == "scf" || ins == "ccf") {
            af = "?"
            queue[qt++] = nxt SUBSEP save_state(); continue
        }
        if (ins ~ /^ldb,/ || ins ~ /^ldc,/ || ins ~ /^ld\(/) {
            queue[qt++] = nxt SUBSEP save_state(); continue
        }
        if (ins ~ /^inc(hl|de|ix|iy)$/ || ins ~ /^dec(hl|de|ix|iy)$/ ||
            ins ~ /^addhl,/ || ins ~ /^adchl,/ || ins ~ /^sbchl,/ ||
            ins ~ /^addix,/ || ins ~ /^addiy,/) {
            if (ins ~ /hl/) hl = "?"
            if (ins ~ /de/) de = "?"
            if (ins ~ /ix/) ix = "?"
            if (ins ~ /iy/) iy = "?"
            queue[qt++] = nxt SUBSEP save_state(); continue
        }
        if (ins ~ /^(and|or|xor|cp|sub|add|adc|sbc)/) {
            af = "?"
            queue[qt++] = nxt SUBSEP save_state(); continue
        }
        if (ins ~ /^j(p|r)(z|nz|c|nc|pe|po|m|p),/) {
            tgt = substr(ins, index(ins, ",") + 1)
            if (!(tgt in labaddr_byname)) return ename ": unknown label " tgt " in " ins
            queue[qt++] = nextaddr[pc] SUBSEP save_state()
            queue[qt++] = labaddr_byname[tgt] SUBSEP save_state()
            continue
        }
        if (ins ~ /^j(p|r)/) {
            tgt = substr(ins, 3)
            if (!(tgt in labaddr_byname)) return ename ": unknown label " tgt " in " ins
            queue[qt++] = labaddr_byname[tgt] SUBSEP save_state()
            continue
        }
        return ename ": unknown opcode " code[pc]
    }
    return ""
}
BEGIN { reset_parse(); curfile = "" }
FNR == 1 && curfile != "" { finish_file(); reset_parse() }
{
    curfile = FILENAME
    srcname = FILENAME
    line = tolower($0)
    sub(/;.*/, "", line)
    if (line ~ /^[ ]*[0-9]+[ ]+[a-z_.][a-z0-9_]*:[ ]*$/) {
        sub(/^[ ]*[0-9]+[ ]+/, "", line)
        sub(/:.*/, "", line)
        pend[npend++] = line
        next
    }
    if (line ~ /^[ ]*[0-9]+[ ]+[0-9a-f][0-9a-f][0-9a-f][0-9a-f][ ]+[0-9a-f][0-9a-f]/) {
        sub(/^[ ]*[0-9]+[ ]+/, "", line)
        addr = hex4(substr(line, 1, 4))
        sub(/^[0-9a-f][0-9a-f][0-9a-f][0-9a-f][ ]+[0-9a-f]+[ ]+/, "", line)
        gsub(/^[ ]+|[ ]+$/, "", line)
        gsub(/[ ]+/, "", line)
        code[addr] = line
        addr_i[ncode] = addr
        if (ncode > 0) nextaddr[addr_i[ncode - 1]] = addr
        nextaddr[addr] = -1
        ncode++
        for (i = 0; i < npend; i++) {
            labname[nlab] = pend[i]
            labaddr[nlab] = addr
            labaddr_byname[pend[i]] = addr
            isentry[nlab] = (pend[i] ~ /(push_di|pop_ei|pop_ei_jp)$/)
            nlab++
        }
        npend = 0
    }
}
END { finish_file() }
