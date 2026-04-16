const PYTHON = require("tree-sitter-python/grammar")
module.exports = grammar(PYTHON, {
    // For reference, see:
    // https://snakemake.readthedocs.io/en/stable/snakefiles/writing_snakefiles.html#grammar
    // However, the grammar described therein is incomplete.
    name: "snakemake",

    externals: ($, original) => original.concat([
        $._IN_DIRECTIVE_PARAMETERS // this is a sentinel token and is never emitted, tells scanner we are inside directive parameters
    ]),

    inline: ($, original) => original.concat([
        $._simple_directive,
        $._rule_directive,
        $._module_directive,
    ]),

    rules: {
        _compound_statement: ($, original) => choice(
            original,
            $._compound_directive
        ),

        _statement: ($, original) => choice(
            original,  // already set choice($._simple_statements, $._compound_statement) in PYTHON
            $._simple_directive,
            $.rule_import  // use rule fron module.
        ),

        _simple_directive: $ => alias(choice(
            $._simple_directive_wc_none,
            $._simple_directive_block,
            $.localrules_directive,
            $.ruleorder_directive
        ), $.directive),

        // The $._newline separator is important to resolve ambiguities between
        // string and concatenated string within rules/modules
        _docstring: $ => seq(choice(
            $.string,
            $.concatenated_string
        ), $._newline),

        _simple_directive_wc_none: $ => new_directive(
            choice(
                "configfile",
                "container",
                "envvars",
                "include",
                "pepfile",
                "pepschema",
                "scattergather",
                "version",
                "wildcard_constraints",
                "workdir"
            ),
            "arguments",
            $._directive_parameters_wc_none
        ),

        _simple_directive_block: $ => new_directive(
            choice(
                "onerror",
                "onstart",
                "onsuccess"
            ),
            "body",
            $._suite
        ),

        localrules_directive: $ => new_directive("localrules", "arguments",
            $._directive_parameters_identifiers),
        ruleorder_directive: $ => new_directive("ruleorder", "arguments",
            $._directive_parameters_ruleorder),

        _compound_directive: $ => choice(
            $.rule_definition,
            $.checkpoint_definition,
            $.rule_inheritance,
            $.module_definition
        ),

        rule_definition: $ => seq(
            "rule",
            optional(
                field('name', $.identifier)
            ),
            ":",
            field('body', $._rule_suite)
        ),

        checkpoint_definition: $ => seq(
            "checkpoint",
            optional(
                field('name', $.identifier)
            ),
            ":",
            field('body', $._rule_suite)
        ),

        rule_import: $ => prec.right(seq(
            "use",
            "rule",
            choice(
                $.wildcard_import,
                $.rule_import_list
            ),
            "from",
            field("module_name", $.identifier),
            optional(seq(
                "exclude",
                $.rule_exclude_list
            )),
            optional(seq(
                "as",
                field(
                    "alias",
                    alias($._rule_import_as_pattern_target, $.as_pattern_target))
            )),
            optional(seq(
                "with",
                ":",
                field("body", $._rule_suite)
            ))
        )),

        rule_import_list: $ => choice(
            prec.right(commaSep1($.identifier)),
            seq("(", commaSep1($.identifier), ")")
        ),

        // as of snakemake 8.4.8, a parenthesized rule exclude list is
        // invalid (as opposed to a parenthesized rule import list)
        rule_exclude_list: $ => prec.right(commaSep1($.identifier)),

        _rule_import_as_pattern_target: $ => /[_*\p{XID_Start}][_*\p{XID_Continue}]*/,

        rule_inheritance: $ => seq(
            "use",
            "rule",
            field("name", $.identifier),
            "as",
            field("alias", alias($.identifier, $.as_pattern_target)),
            "with",
            ":",
            field("body", $._rule_suite)
        ),

        // analogous to tree-sitter-python: _suite
        _rule_suite: $ => choice(
            seq($._indent, $.rule_body),
            $._newline,
        ),

        // analogous to tree-sitter-python: block
        rule_body: $ => seq(
            optional($._docstring),
            repeat($._rule_directive),
            $._dedent
        ),

        // Directives which can appear in rule definitions
        _rule_directive: $ => alias(choice(
            $._rule_directive_wc_def,
            $._rule_directive_wc_interp,
            $._rule_directive_wc_none,
            $._rule_directive_block
        ), $.directive),

        // Rule directives with wildcard definitions (injected by snakemake_iostr sub-grammar)
        _rule_directive_wc_def: $ => new_directive(
            choice(
                "benchmark",
                "conda",
                "input",
                "log",
                "output"
            ),
            "arguments",
            $._directive_parameters_wc_none
        ),

        // Rule directives with wildcard interpolations (injected by snakemake_iostr sub-grammar)
        _rule_directive_wc_interp: $ => new_directive(
            choice(
                "message",
                "notebook",
                "script",
                "shell"
            ),
            "arguments",
            $._directive_parameters_wc_none
        ),

        // Rule directives without wildcards
        _rule_directive_wc_none: $ => new_directive(
            choice(
                "cache",
                "container",
                "cwl",
                "default_target",
                "envmodules",
                "group",
                "handover",
                "localrule",
                "name",
                "params",
                "priority",
                "resources",
                "retries",
                "shadow",
                "singularity",
                "template_engine",
                "threads",
                "wildcard_constraints",
                "wrapper"
            ),
            "arguments",
            $._directive_parameters_wc_none
        ),

        // Rule directives with code blocks
        _rule_directive_block: $ => new_directive(
            "run",
            "body",
            $._suite
        ),

        module_definition: $ => seq(
            "module",
            field("name", $.identifier),
            ":",
            field("body", $.module_body)
        ),

        module_body: $ => choice(
            seq(
                $._indent,
                repeat(
                    choice(
                        $._docstring,
                        $._module_directive
                    )
                ),
                $._dedent
            ),
            $._newline
        ),

        _module_directive: $ => alias(choice(
            $._module_directive_wc_none,
        ), $.directive),

        // Module directives without wildcards
        _module_directive_wc_none: $ => new_directive(
            choice(
                "config",
                "meta_wrapper",
                "prefix",
                "skip_validation",
                "snakefile"
            ),
            "arguments",
            $._directive_parameters_wc_none
        ),

        // Parameters for directives
        _directive_parameters: $ => directiveParameters($, $._directive_parameter),
        _directive_parameters_wc_none: $ => alias(
            $._directive_parameters,
            $.directive_parameters
        ),

        // Identifier list (for localrules)
        __directive_parameters_identifiers: $ => directiveParameters($, $.identifier),
        _directive_parameters_identifiers: $ => alias(
            $.__directive_parameters_identifiers,
            $.directive_parameters
        ),

        // Identifier comparisons (for ruleorder)
        __directive_parameters_ruleorder: $ => seq(
            $.identifier,
            repeat(seq(">", $.identifier))  // should be repeat1, but relax
        ),
        _directive_parameters_ruleorder: $ => alias(
            $.__directive_parameters_ruleorder,
            $.directive_parameters
        ),

        _directive_parameter: $ => choice(
            $.expression,
            $.keyword_argument,
            $.list_splat,  // *args
            $.dictionary_splat  // **kwargs
        ),

    }
});

function commaSep1(rule, sep_trail = true) {
    return sep1(rule, ',', sep_trail = sep_trail)
}

function sep1(rule, separator, sep_trail = true) {
    if (sep_trail) {
        return seq(rule, repeat(seq(separator, rule)), optional(separator))
    } else {
        return seq(rule, repeat(seq(separator, rule)))
    }
}

/*  DIRECTIVE PARAMETERS

    Directives can receive parameters
    -1- on a single line:
         input: "x", "y"
    -2- on a line, followed by an indented block:
         input: "x",
             "y",
             "y"
    -3- in an indented block:
         input:
             "x",
             "y"
    -4- empty:
        input:

    This helper builds the raw parameter-list shape for one of those forms.
    Call sites alias the result as (directive_parameters),
    so different directive-specific item types (generic parameters, identifiers, etc.)
    still produce the same public AST node.
 */
function directiveParameters($, parameter_rules) {
    // Include _IN_DIRECTIVE_PARAMETERS in the choice
    //  so it remains a valid symbol at each parameter position.
    // ([Snakemake scanner](src/scanner.c) checks this label to
    //  suppresses NEWLINE/DEDENT between parameters
    //  and keeps multiline parameter lists together.)
    parameter_rules = choice(parameter_rules, $._IN_DIRECTIVE_PARAMETERS)
    let rules = seq(parameter_rules, repeat(seq(",", parameter_rules)))
    // Parameters written entirely on the directive line.
    let line = seq(rules, optional(","), $._newline)
    // Parameters written entirely in the following indented block.
    let block = seq($._indent, rules, optional(","), $._dedent)
    // Parameters split between the directive line and the following block.
    let lineAndblock = seq(rules, ",", block)
    // Also allow an empty parameter list, e.g. `input:`.
    return (choice(line, lineAndblock, block, $._newline))
}

function new_directive(name, body_name, parameters) {
    return seq(
        field("name", name),
        ":",
        field(body_name, parameters)
    )
}
