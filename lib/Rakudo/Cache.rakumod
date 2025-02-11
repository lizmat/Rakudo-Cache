use Git::Files:ver<0.0.9+>:auth<zef:lizmat>;
use path-utils:ver<0.0.21+>:auth<zef:lizmat> <path-is-text>;

# Default location of cache
my $default-cache := (%*ENV<RAKU_RAKUDO_CACHE> andthen .IO)
  // ($*HOME // $*TMPDIR).add(".raku").add("cache");

class Rakudo::Cache:ver<0.0.1>:auth<zef:lizmat> {
    has IO::Path $.cache is built(:bind) = $default-cache;

    method rakudo-all(Rakudo::Cache:D:)   { $!cache.add("rakudo-all")   }
    method rakudo-c(Rakudo::Cache:D:)     { $!cache.add("rakudo-c")     }
    method rakudo-doc(Rakudo::Cache:D:)   { $!cache.add("rakudo-doc")   }
    method rakudo-java(Rakudo::Cache:D:)  { $!cache.add("rakudo-java")  }
    method rakudo-js(Rakudo::Cache:D:)    { $!cache.add("rakudo-js")    }
    method rakudo-nqp(Rakudo::Cache:D:)   { $!cache.add("rakudo-nqp")   }
    method rakudo-perl(Rakudo::Cache:D:)  { $!cache.add("rakudo-perl")  }
    method rakudo-raku(Rakudo::Cache:D:)  { $!cache.add("rakudo-raku")  }
    method rakudo-shell(Rakudo::Cache:D:) { $!cache.add("rakudo-shell") }
    method rakudo-test(Rakudo::Cache:D:)  { $!cache.add("rakudo-test")  }
    method rakudo-yaml(Rakudo::Cache:D:)  { $!cache.add("rakudo-yaml")  }

    method update(Rakudo::Cache:D:
      IO::Path:D  $rakudo = $*EXECUTABLE.parent(3)
    ) {
        my str @all;
        my str @c;
        my str @doc;
        my str @java;
        my str @js;
        my str @nqp;
        my str @perl;
        my str @raku;
        my str @shell;
        my str @test;
        my str @yaml;
        my str @huh;

        # Extract the files to the right arrays
        my sub extract($io) {
            (.ends-with('.nqp') || .contains('/src/Raku/ast/')
              ?? @nqp
              !! .ends-with(<.pod .pod6 .rakudoc .md .txt .rtf>.any)
                   || (.contains('/docs/') && path-is-text($_))
                   || .contains(/ "/" <[A..Z]>+ $/)
                ?? @doc
                !! .ends-with(<.rakumod .raku .pm6 .p6 /t/harness6>.any)
                  ?? @raku
                  !! .ends-with(<.rakutest .t>.any)
                    ?? @test
                    !! .ends-with(<.pl .pm /t/harness5>.any)
                      ?? @perl
                      !! .ends-with(<.c .h .cpp>.any) || .contains('.c.')
                        ?? @c
                        !! .ends-with('.js')
                          ?? @js
                          !! .ends-with('.java')
                            ?? @java
                            !! .ends-with(<.sh .ps1 .bat .in>.any)
                              ?? @shell
                              !! .ends-with('.yml')
                                ?? @yaml
                                !! @huh
            ).push($_) for git-files($io);
        }

        extract($rakudo);
        extract($rakudo.add("nqp"));
        extract($rakudo.add("nqp").add("MoarVM"));

        $!cache.mkdir;
        for <c doc java js nqp perl raku shell test yaml> {
            @all.append(::("@$_"));
            self."rakudo-$_"().spurt(::("@$_").sort.join("\n"));
        }
        self.rakudo-all.spurt(@all.sort.join("\n"));

        @huh
    }
}

# vim: expandtab shiftwidth=4
