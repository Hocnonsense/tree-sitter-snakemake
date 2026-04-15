// Sub-grammar for Snakemake wildcard patterns embedded in strings.
// Injected by the main snakemake grammar's injections.scm into string_content
// nodes inside wildcard-capable directives (input, output, shell, etc.).
//
// Handles two wildcard forms:
//   Definition  (input/output/log/benchmark/conda):
//     {name}            plain wildcard
//     {name,constraint} wildcard with regex constraint
//     {{                escaped literal {
//
//   Interpolation (shell/script/message/notebook):
//     {name}            simple reference
//     {name.attr[idx]}  attribute / subscript chain
//     {name:flag}       with format flag (e.g. :q)
//     {{                escaped literal {

module.exports = grammar({
    name: 'snakemake_wildcard',

    // Do not skip any whitespace: the injected content is raw string text
    // and every character is significant.
    extras: $ => [],

    rules: {
        source: $ => repeat(choice(
            $.wildcard,
            $.escaped_brace,
            $.text
        )),

        wildcard: $ => seq(
            '{',
            field('name', $.name),
            optional(choice(
                seq(',', field('constraint', $.constraint)),
                seq(':', field('flag', $.flag))
            )),
            '}'
        ),

        // {{ or }} are escaped literal braces, not wildcard delimiters.
        escaped_brace: $ => choice('{{', '}}'),

        // name: an identifier optionally followed by .attr and/or [index] chains,
        // e.g. "input", "input.a", "wildcards.sample", "input.a[0].b"
        name: $ => /[a-zA-Z_]\w*(?:\.[a-zA-Z_]\w*|\[\d+\])*/,

        // constraint: everything that is not a brace, allowing {N} quantifiers
        // e.g. "\w+", "[A-Z]+", "(?:\d{2})"
        constraint: $ => /(?:[^{}]|\{\d+\})+/,

        // flag: single word, currently only "q" (quote whitespace)
        flag: $ => /\w+/,

        // text: any run of non-brace characters
        text: $ => /[^{}]+/,
    }
});
