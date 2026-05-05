; Wildcard name: highlight as variable
(wildcard (name) @variable)

; Format flag (:q etc.): highlight as builtin parameter
(wildcard (flag) @variable.parameter.builtin)

; Literal string text between wildcard expressions
(text) @string

; Directive label references in interpolation wildcards
; e.g. {input}, {output.a}, {wildcards.sample}
((wildcard (name) @label)
  (#match? @label "^(input|jobid|log|output|params|resources|rule|threads|wildcards)"))

; Constraint content: inject as regex for further highlighting
(wildcard
  (constraint) @injection.content
  (#set! injection.language "regex"))

; Escaped braces
(escaped_brace) @string.escape
