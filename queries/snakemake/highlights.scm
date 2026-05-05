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

; ---------------------------------------------------------------------------
; GENERATED FROM highlights.json. Do not edit this section by hand.
; ---------------------------------------------------------------------------

; Top-level Snakemake directives
(module
  (directive
    name: [
      "conda"
      "configfile"
      "container"
      "containerized"
      "envvars"
      "include"
      "inputflags"
      "localrules"
      "onerror"
      "onstart"
      "onsuccess"
      "outputflags"
      "pathvars"
      "pepfile"
      "pepschema"
      "report"
      "resource_scopes"
      "ruleorder"
      "scattergather"
      "singularity"
      "storage"
      "wildcard_constraints"
      "workdir"
    ] @keyword))

; Rule and use-rule parameter directives
(rule_body
  (directive
    name: [
      "benchmark"
      "cache"
      "conda"
      "container"
      "containerized"
      "default_target"
      "envmodules"
      "group"
      "handover"
      "input"
      "localrule"
      "log"
      "message"
      "name"
      "output"
      "params"
      "pathvars"
      "priority"
      "resources"
      "retries"
      "shadow"
      "singularity"
      "threads"
      "wildcard_constraints"
    ] @label))

(rule_import
  body: (rule_body
    (directive
      name: [
        "benchmark"
        "cache"
        "conda"
        "container"
        "containerized"
        "default_target"
        "envmodules"
        "group"
        "handover"
        "input"
        "localrule"
        "log"
        "message"
        "name"
        "output"
        "params"
        "pathvars"
        "priority"
        "resources"
        "retries"
        "shadow"
        "singularity"
        "threads"
        "wildcard_constraints"
      ] @label)))

(rule_inheritance
  body: (rule_body
    (directive
      name: [
        "benchmark"
        "cache"
        "conda"
        "container"
        "containerized"
        "default_target"
        "envmodules"
        "group"
        "handover"
        "input"
        "localrule"
        "log"
        "message"
        "name"
        "output"
        "params"
        "pathvars"
        "priority"
        "resources"
        "retries"
        "shadow"
        "singularity"
        "threads"
        "wildcard_constraints"
      ] @label)))

; Rule terminal directives (run, shell, script, ...)
(rule_body
  (directive
    name: [
      "cwl"
      "notebook"
      "run"
      "script"
      "shell"
      "template_engine"
      "wrapper"
    ] @label))

; Module directives
(module_body
  (directive
    name: [
      "config"
      "meta_wrapper"
      "name"
      "pathvars"
      "prefix"
      "replace_prefix"
      "skip_validation"
      "snakefile"
    ] @label))

; Snakemake classes and exceptions
((identifier) @type
  (#any-of? @type
  "Path"
  "WorkflowError"))

; Snakemake objects available in Python regions
((identifier) @variable.builtin
  (#any-of? @variable.builtin
  "access"
  "checkpoints"
  "config"
  "gather"
  "rules"
  "scatter"
  "snakemake"
  "storage"
  "workflow"))

; Bare job parameter objects in Python blocks
(block
  (expression_statement
    (identifier) @label
    (#any-of? @label
  "config"
  "input"
  "log"
  "output"
  "params"
  "resources"
  "threads"
  "wildcards")))

; Attribute access on job parameters, e.g. output.foo
(attribute
  object: (identifier) @label
  attribute: (identifier) @variable
  (#any-of? @label
  "config"
  "input"
  "log"
  "output"
  "params"
  "resources"
  "threads"
  "wildcards"))

; Attribute access on rules/checkpoints objects, e.g. rules.foo
(attribute
  object: (identifier) @variable.builtin
  attribute: (identifier) @variable
  (#any-of? @variable.builtin "rules" "checkpoints"))

; checkpoints.foo.get
(attribute
  object: (attribute
    object: (identifier) @variable.builtin
    attribute: (identifier) @variable)
  attribute: (identifier) @function.builtin
  (#eq? @variable.builtin "checkpoints")
  (#eq? @function.builtin "get"))

; Snakemake helper functions used in Python regions
(call
  function: (identifier) @function.builtin
  (#any-of? @function.builtin
  "ancient"
  "before_update"
  "branch"
  "collect"
  "directory"
  "ensure"
  "evaluate"
  "exists"
  "expand"
  "extract_checksum"
  "flag"
  "flatten"
  "from_queue"
  "gitfile"
  "github"
  "gitlab"
  "glob_wildcards"
  "local"
  "lookup"
  "multiext"
  "parse_input"
  "pipe"
  "protected"
  "repeat"
  "report"
  "service"
  "shell"
  "subpath"
  "temp"
  "temporary"
  "touch"
  "unpack"
  "update"))
