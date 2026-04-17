; inherits: python

; Compound directives
[
  "rule"
  "checkpoint"
  "module"
] @keyword

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

; directive labels in block context (eg. within 'run:')
((identifier) @label
  (#any-of? @label "input" "jobid" "log" "output" "params" "resources" "rule" "threads" "wildcards")
  (#has-ancestor? @label "directive")
  (#has-ancestor? @label "block"))
