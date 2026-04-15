; inherits: python

; Inject snakemake_iostr into all plain string content.
; F-string interpolations are already (interpolation) nodes handled by Python,
; so string_content only contains literal text — {x} patterns are Snakemake wildcards.
((string (string_content) @injection.content)
 (#set! injection.language "snakemake_iostr"))
