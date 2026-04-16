configfile: "c.yaml"
# ^^^^^^^^ keyword

rule ruleA:
    # comment
    input: a = "b",
        b = "c",
        c = "{sample}.txt",
    output: "{sample}.tsv",
# comment
        # comment
        d = "d"
    shell:
#   ^^^^^ label
        "cat {input:q} > {output.d:q}"
        f"{input:d}"
        "{input}"

threads = 3
#^^^^^^ !label

if True:
    rule B:
#   ^^^^ keyword
#        ^ type
        input: "a"
#       ^^^^^ label
else:
    # branch
    rule B:
#   ^^^^ keyword
#        ^ type
        input: "b"
#       ^^^^^ label

checkpoint X:
# ^^^^^^^^ keyword
    input: 1
#    ^^^^^ label
    output: 2
#   ^^^^^ label
