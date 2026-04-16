const PYTHON = require("tree-sitter-python/grammar")
const DIRECTIVES = require("./directives.json")

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
        $._use_rule_directive,
        $._rule_directive_run,
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
            $._simple_directive_params,
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

        _simple_directive_params: $ => new_directive(
            choice(...DIRECTIVES.params.filter(
                d => !["localrules", "ruleorder"].includes(d)
            )),
            "arguments",
            $._directive_parameters_wc_none
        ),
        localrules_directive: $ => new_directive("localrules", "arguments",
            $._directive_parameters_identifiers),
        ruleorder_directive: $ => new_directive("ruleorder", "arguments",
            $._directive_parameters_ruleorder),

        _simple_directive_block: $ => new_directive(
            choice(...DIRECTIVES.python),
            "body",
            $._suite
        ),

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
                field("body", $._use_rule_suite)
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
            field("body", $._use_rule_suite)
        ),

        // analogous to tree-sitter-python: _suite
        _use_rule_suite: $ => choice(
            seq($._indent, $.use_rule_body),
            $._newline,
        ),
        // analogous to tree-sitter-python: block
        use_rule_body: $ => seq(
            optional($._docstring),
            repeat($._use_rule_directive),
            $._dedent
        ),

        _rule_suite: $ => choice(
            seq($._indent, $.rule_body),
            $._newline,
        ),
        // can accept runable directives
        rule_body: $ => seq(
            optional($._docstring),
            repeat($._use_rule_directive),
            optional($._rule_directive_run),
            $._dedent
        ),

        // Terminal rule directives: `run`-style directives may appear at most
        // once and only at the end of a rule body.
        __rule_directive_run: $ => choice(
            new_directive(
                ...DIRECTIVES.statements.rule.run.python,  // only "run"
                "body",
                $._suite
            ),
            new_directive(
                choice(...DIRECTIVES.statements.rule.run.shell),
                "arguments",
                $._directive_parameters_wc_none
            )
        ),
        _rule_directive_run: $ => alias(
            $.__rule_directive_run,
            $.directive
        ),

        __use_rule_directive: $ => new_directive(
            choice(...DIRECTIVES.statements.rule.params),
            "arguments",
            $._directive_parameters_wc_none
        ),
        _use_rule_directive: $ => alias(
            $.__use_rule_directive,
            $.directive
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
                optional($._docstring),
                repeat($._module_directive),
                $._dedent
            ),
            $._newline
        ),

        _module_directive: $ => alias(choice(
            $._module_directive_params,
        ), $.directive),

        // Module directives with parameter bodies.
        _module_directive_params: $ => new_directive(
            choice(...DIRECTIVES.statements.module.params),
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
