use Red::Utils;
use Red::Cli::Column;
unit class Red::Cli::Table;

has Str $.name is required;
has Str $.model-name = snake-to-camel-case $!name;
has @.columns;

multi method model-definition($ where so *)  { "unit model { $!model-name };\n" }
multi method model-definition($ where not *) { "model { $!model-name } \{" }
multi method model-end($ where so *)  { "" }
multi method model-end($ where not *) { "\}" }

method to-code(Str :$schema-class) {
    my $unit = not $schema-class.defined;
    qq:to/END/;
    { self.model-definition: $unit }
    { do for @!columns -> $col {
        $col.to-code: :$schema-class
    }.join("\n").indent: $unit ?? 0 !! 4 }
    { self.model-end: $unit }
    END
}
