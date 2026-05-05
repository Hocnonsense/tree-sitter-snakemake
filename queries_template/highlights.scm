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

(rule_import
  (rule_import_list
    (identifier) @type))

(rule_import
  module_name: (identifier) @type)

(rule_import
  alias: (as_pattern_target) @type)

; Rule inheritance
(rule_inheritance
  [
    "use"
    "rule"
    "as"
    "with"
  ] @keyword
  name: (identifier) @type
  alias: (as_pattern_target) @type)

; directive labels in block context (eg. within 'run:')
((identifier) @label
  (#any-of? @label "input" "jobid" "log" "output" "params" "resources" "rule" "threads" "wildcards")
  (#has-ancestor? @label "directive")
  (#has-ancestor? @label "block"))
