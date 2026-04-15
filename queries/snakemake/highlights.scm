; inherits: python

; Compound directives
[
  "rule"
  "checkpoint"
  "module"
] @keyword

; Top level directives (eg. configfile, include)
(module
  (directive
    name: _ @keyword))

; Subordinate directives (eg. input, output)
body: (_
  (directive
    name: _ @label))

; rule/module/checkpoint names
(rule_definition
  name: (identifier) @type)

(module_definition
  name: (identifier) @type)

(checkpoint_definition
  name: (identifier) @type)

; Rule imports
(rule_import
  [
    "use"
    "rule"
    "from"
    "exclude"
    "as"
    "with"
  ] @keyword.import)

; Rule inheritance
(rule_inheritance
  "use" @keyword
  "rule" @keyword
  "with" @keyword)

; builtin variables
((identifier) @variable.builtin
  (#any-of? @variable.builtin "checkpoints" "config" "gather" "rules" "scatter" "workflow"))

; directive labels in block context (eg. within 'run:')
((identifier) @label
  (#any-of? @label "input" "jobid" "log" "output" "params" "resources" "rule" "threads" "wildcards")
  (#has-ancestor? @label "directive")
  (#has-ancestor? @label "block"))
