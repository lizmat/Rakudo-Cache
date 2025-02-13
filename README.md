[![Actions Status](https://github.com/lizmat/Rakudo-Cache/actions/workflows/linux.yml/badge.svg)](https://github.com/lizmat/Rakudo-Cache/actions) [![Actions Status](https://github.com/lizmat/Rakudo-Cache/actions/workflows/macos.yml/badge.svg)](https://github.com/lizmat/Rakudo-Cache/actions) [![Actions Status](https://github.com/lizmat/Rakudo-Cache/actions/workflows/windows.yml/badge.svg)](https://github.com/lizmat/Rakudo-Cache/actions)

NAME
====

Rakudo::Cache - maintain a local cache of Rakudo source

SYNOPSIS
========

```raku
use Rakudo::Cache;

my $rc  = Rakudo::Cache.new(:cache($io))
my @huh = $rc.update;
```

DESCRIPTION
===========

The `Rakudo::Cache` distribution provides the logic to create lists of files according to a set of criteria of an installed Rakudo runtime. These lists of files can then be used by applications such as [`App::Rak`](https://raku.land/zef:lizmat/App::Rak) to easily perform targeted searches.

It also provides a `update-rakudo-cache` script for easy updating, which should usually only be after a Rakudo update.

It looks at the files in the "rakudo", "nqp","MoarVM" and "roast" repositories as installed inside the root of a Rakudo distribution. It performs the following heuristics on the files in these repositories:

nqp
---

Any path ending with `.nqp` or containing `/src/Raku/ast`.

doc
---

Any path ending in `.pod`, `.pod6`, `.rakudoc`, `.md`, `.txt`, `.rtf` or containing `/docs/` and being a text file, or any filename ending in just uppercase letters.

### raku

Any path ending with `.rakumod`, `.raku`, `.p6`, or `/t/harness6`.

### perl

Any path ending with `.pl`, `.pm`, or `/t/harness5`.

c
-

Any path ending with `.c`, `.h`, or `.cpp`.

js
--

Any path ending with `.js`.

java
----

Any path ending with `.java`.

shell
-----

Any path ending with `.sh`, `.ps1`, `.bat`, or `.in`.

yaml
----

Any path ending with `.yml`.

SETUP METHODS
=============

new
---

```raku
my $rc  = Rakudo::Cache.new;               # cache at ~/.raku/cache

my $rc  = Rakudo::Cache.new(:cache($io));  # cache at $io
my @huh = $rc.update;
```

The `new` method takes one optional named argument: `:cache`. It specifies the `IO::Path` object where the cache should be located.

If not specified, will default to:

  * the RAKU_RAKUDO_CACHE environment variable

  * the subdirectory .raku/cache in $*HOME

  * the subdirectory .raku/cache in $*TMPDIR

After instantion, the `IO::Path` used can be obtained by the `cache` method.

update
------

```raku
my @huh = $rc.update;
```

The `update` method performs the update and returns a list of paths that could not be categorized using current semantics.

HELPER METHODS
==============

All helper method names start with "rakudo-" and return the `IO::Path` of the associated list of files.

<table class="pod-table">
<thead><tr>
<th>method</th> <th>description</th>
</tr></thead>
<tbody>
<tr> <td>rakudo-c</td> <td>all C programming language related files</td> </tr> <tr> <td>rakudo-doc</td> <td>all documentation files</td> </tr> <tr> <td>rakudo-java</td> <td>all Java programming language related files</td> </tr> <tr> <td>rakudo-js</td> <td>all Javascript programming language related files</td> </tr> <tr> <td>rakudo-nqp</td> <td>all NQP related files</td> </tr> <tr> <td>rakudo-perl</td> <td>all Perl programming language related files</td> </tr> <tr> <td>rakudo-raku</td> <td>all Raku Programming Language related files</td> </tr> <tr> <td>rakudo-shell</td> <td>all shell scripts / batch files</td> </tr> <tr> <td>rakudo-test</td> <td>all testing related files</td> </tr> <tr> <td>rakudo-yaml</td> <td>all files containing YAML of some sort</td> </tr> <tr> <td>rakudo-all</td> <td>all of the above</td> </tr>
</tbody>
</table>

SCRIPTS
=======

    $ update-rakudo-cache
    Found 170 files that couldn't be categorized:
    .../rakudo/.gitattributes
    .../rakudo/.gitignore
    ...

The `update-rakudo-cache` script looks at the source files of the executable, updates the paths in the cache and shows the paths of the files that couldn't be interpreted.

If you feel that a file is in this list that shouldn't be, please [create an issue for it](https://github.com/lizmat/Rakudo-Cache/issues/new).

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/Rakudo-Cache . Comments and Pull Requests are welcome.

If you like this module, or what I'm doing more generally, committing to a [small sponsorship](https://github.com/sponsors/lizmat/) would mean a great deal to me!

COPYRIGHT AND LICENSE
=====================

Copyright 2025 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

