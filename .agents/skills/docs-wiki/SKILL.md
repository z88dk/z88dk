---
name: docs-wiki
description: >
  Edit the z88dk human wiki (z88dk/z88dk.wiki). Use when revising wiki pages,
  classic vs newlib platform pages, or issue #3040. STE prose via
  style-ste-writing. A change index is read once per pass. A commit or PR
  subject is only a filter: read the patch before you write a wiki sentence.
  Not for library asm, compiler work, or benchmark tick rules
  (methodology-measure).
---

# Wiki — human pages

The wiki is for people who build a program for a machine. Agent rules stay in skills. A wiki page is not a second skill file.

## Where the pages live

| Item | Location |
|------|----------|
| Live wiki | `https://github.com/z88dk/z88dk.wiki` (`git clone https://github.com/z88dk/z88dk.wiki.git`) |
| This skill | `.agents/skills/docs-wiki/` |
| Change index | `.agents/skills/docs-wiki/references/change-index.md` |
| Benchmark number rules | **`methodology-measure`** (Wiki pages). Do not copy them here |

Do not commit wiki page bodies into the z88dk product repo. Do not stage `wiki-*.md`. When the wiki and the tree disagree, the tree wins. Correct the wiki.

## Prose

Correct and write wiki prose with **`style-ste-writing`**, mode **STE-flavored**.

- Apply STE to the sentences you change.
- Do not restyle a whole page when one fact is wrong.
- British spelling. One name for one thing (`+zx`, classic, newlib).

## Keep the current page

Keep every current human section. Correct the sentences that are no longer true.

- Leave the section in place. Replace the wrong sentence.
- Do not drop a section because it looks old, informal, or incomplete.
- If a fact belongs on the other library world's page, copy it there first. On this page, replace it with one comment link (below). Do not throw the fact away.

Agent scaffolding is not a human section. The next heading says what to take off the page.

## Change index (once per pass)

Build the index before you edit pages. Later page work reads the index. It does not reread the commit list.

The subject line is a filter. The patch is the fact. A subject that names one machine often edits other targets, and it can describe a change the diff does not make.

1. List new commits on `z88dk/z88dk` and `z88dk/z88dk.wiki` since the date in the index. List open pull requests. Start issues from [issue #3040](https://github.com/z88dk/z88dk/issues/3040).
2. Open a commit or pull request when the subject or title names a target, a `+name`, a machine, a CLIB, or a behaviour the wiki states (maths flag, file I/O, packaging, console). Also open it when the paths touch `lib/config/*.cfg`, `libsrc/target/`, `libsrc/newlib/target/`, `include/arch/`, or a wiki `Platform*` page.
3. Leave it closed when the subject and the paths are outside that set (a test-only fix, a host debugger, formatting). Write one index line that says why it was skipped.
4. Parse the patch before you write the row:
   - `git show --stat <commit>`, then the hunks. On a merge, use the first-parent diff (`git diff <commit>^1 <commit>`).
   - On a pull request, read the changed files. The title does not limit which of those files you read.
   - On a wiki commit, list every page the diff touches. Do not stop at the machine named in the subject.
5. Write the row from the hunks. One sentence: the flag, library name, default, or output file a person would see. If the subject and the hunk disagree, keep the hunk. If the hunk does not say what the subject claims, do not put that claim on the wiki.
6. Name the wiki page and the section to correct. Keep that section. An unmerged pull request is not shipped behaviour. Record it, and do not write it onto the wiki until it is merged.
7. One row per page per change, in `references/change-index.md`. A later edit of that page reads those rows, then the tree file the hunk names (`lib/config/<target>.cfg`, the header, `changelog.txt`). It does not reread the commit, and it does not trust the subject.
8. After the wiki edit, mark the row checked and note the wiki commit.
9. A newer commit adds rows. It does not restart the scan.

## Classic and newlib are separate pages

[Issue #3040](https://github.com/z88dk/z88dk/issues/3040): a classic target page documents the classic library. A newlib page documents newlib. The pages do not share a body.

| Page kind | Examples | Subject |
|-----------|----------|---------|
| Classic target | `Platform---CPM`, `Platform---Sinclair-ZX-Spectrum` | Classic library for that machine |
| Newlib | `Newlib-Overview`, and a newlib page when one target needs more than a row | Newlib for that machine |

The only cross-link is one comment link: one sentence, the other page's name, and the link. No comparison table. No second compile recipe. No second card.

```markdown
Newlib for this machine: [Newlib overview](Newlib-Overview).
```

A target whose default CLIB is newlib (`+rc2014`, `+zxn`, `+hbios`, `+yaz180`, `+scz180`, `+z80`, `+z180`) uses the newlib page as its main page. Classic for that machine is the same one-sentence link, the other way, when a classic page exists.

Cfg paths and "do not mix this target with that target" lists stay in the target skill (`target-cpm`, `target-zx`, `target-zxn`, …).

## Tables a person can use

A table helps a person choose. Rows are the choice (machine, subtype, library, output file). Columns are that choice and the result the person sees (a `.com`, a `.tap`, a disc image, a library they can call).

Put cfg internals in the target skill, not in the wiki table. That includes CRT object paths, `-I` / `-isystem` lines, `lib/clibs/...` directory names, and headings such as "From `cpm.cfg`".

A subtype table may stay when each row says what the person gets (tape, snapshot, disc, ROM).

## What does not belong on a page

| Take off the wiki page | Put it here |
|------------------------|-------------|
| `<!-- draft:verified -->`, `<!-- draft:imported -->`, `prev:` notes | Change index, if you still need the status |
| "Not the other target" tables and "do not" lists aimed at agents | Target skill. The wiki keeps one sentence and a link |
| Reference cards copied from `lib/config/*.cfg` | Target skill |
| Smoke logs ("OK on this tree", link failed on a probe) | Change index. Keep one user-facing sentence if the fact still matters |
| Notes about the wiki rewrite itself | This skill or the change index |

## Edit one page

1. Read the change-index rows for this page.
2. Read the live page. List the human sections you will keep.
3. Check the tree file named in the index row. The row is the parsed patch. Confirm the tree still matches it.
4. Correct stale sentences in place. Use the patch sentence, not the commit subject.
5. Move the other library world off this page. Leave one comment link.
6. Run the **`style-ste-writing`** self-lint on the sentences you wrote.
7. Update the index row.

## Related

- **`style-ste-writing`** — prose form
- **`methodology-measure`** — benchmark numbers on `Benchmarks` and `Classic--Maths-Libraries`
- **`library-classic`**, **`library-newlib`** — library worlds
- **`target-cpm`**, **`target-zx`**, **`target-zxn`**, **`target-rc2014`**, **`target-sms`** — cfg cards for agents
