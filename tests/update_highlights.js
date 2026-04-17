#!/usr/bin/env node

const fs = require("fs")
const path = require("path")

const root = path.resolve(__dirname, "..")
const dataPath = path.join(root, "highlights.json")
const templatePath = path.join(root, "queries", "snakemake", "highlights.template.scm")
const outputPath = path.join(root, "queries", "snakemake", "highlights.scm")

const data = JSON.parse(fs.readFileSync(dataPath, "utf8"))
const template = fs.readFileSync(templatePath, "utf8").trimEnd()
const current = fs.existsSync(outputPath) ? fs.readFileSync(outputPath, "utf8") : ""

function renderAnyOf(capture, items) {
    const unique = [...new Set(items)].sort()
    return `(#any-of? ${capture}\n${unique.map(item => `  "${item}"`).join("\n")})`
}

const generated = `
; ---------------------------------------------------------------------------
; GENERATED FROM highlights.json. Do not edit this section by hand.
; ---------------------------------------------------------------------------

; Snakemake classes and exceptions
((identifier) @type
  ${renderAnyOf("@type", data.classes)})

; Snakemake objects available in Python regions
((identifier) @variable.builtin
  ${renderAnyOf("@variable.builtin", data.builtin_objects)})

; Bare job parameter objects in Python blocks
(block
  (expression_statement
    (identifier) @label
    ${renderAnyOf("@label", data.job_params)}))

; Attribute access on job parameters, e.g. \`output.foo\`
(attribute
  object: (identifier) @label
  attribute: (identifier) @variable
  ${renderAnyOf("@label", data.job_params)})

; Attribute access on rules/checkpoints objects, e.g. \`rules.foo\`
(attribute
  object: (identifier) @variable.builtin
  attribute: (identifier) @variable
  (#any-of? @variable.builtin "rules" "checkpoints"))

; \`checkpoints.foo.get\`
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
  ${renderAnyOf("@function.builtin", data.helper_functions)})
`.trim()

const updated = `${template}\n\n${generated}\n`

if (process.argv.includes("--check")) {
    if (updated !== current) {
        process.stderr.write("highlights.scm is out of date. Run: node tests/update_highlights.js\n")
        process.exit(1)
    }
    process.exit(0)
}

fs.writeFileSync(outputPath, updated)
