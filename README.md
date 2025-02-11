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

It looks at the files in the "rakudo", "nqp" and "MoarVM" repositories as installed inside the root of a Rakudo distribution. It performs the following heuristics on the files in these repositories:

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

method | description -------------|------------ rakudo-c | all C programming language related files rakudo-doc | all documentation files rakudo-java | all Java programming language related files rakudo-js | all Javascript programming language related files rakudo-nqp | all NQP related files rakudo-perl | all Perl programming language related files rakudo-raku | all Raku Programming Language related files rakudo-shell | all shell scripts / batch files rakudo-test | all testing related files rakudo-yaml | all files containing YAML of some sort rakudo-all | all of the above

SCRIPTS
=======

    $ update-rakudo-cache
    Found 145 files that couldn't be categorized:
    /Users/liz/Github/rakudo/.gitattributes
    /Users/liz/Github/rakudo/.gitignore
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

