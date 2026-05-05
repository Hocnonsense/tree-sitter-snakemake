# Changelog

## [3.0.0](https://github.com/Hocnonsense/tree-sitter-snakemake/compare/v2.1.0...v3.0.0) (2026-05-05)


### ⚠ BREAKING CHANGES

* vibe to seperate wildcards from snakemake stem
* expose nodes rule_import_list and rule_exclude_list

### Features

* add "name" directive and "rule" wildcard ([c598aad](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/c598aade25275d2266a9a86973c212d6248b791c))
* add queries for indents ([ba1b386](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/ba1b3868eaa960b945593404af9a7c2f296d3643))
* add queries for indents ([cf7e1f3](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/cf7e1f3aee683b34dec547e69cec4a87225d9773))
* expose nodes rule_import_list and rule_exclude_list ([af04aef](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/af04aef4081730b092462d9700ee724bd77a774d))
* improve handling of comments and parameter indentation ([0c65650](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/0c6565036b0229afb5c0e5e1fbd29abedd544b8c))
* minor query updates, format ([bb9b73b](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/bb9b73b9c443ca9cf56b739bf92831d65d075037))
* neovim example ([3d445d4](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/3d445d454221b4a78f75cc20afd56850bfd1eb02))
* **queries:** add rule_inheritance to folds ([5750bca](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/5750bcaadb2a980cfcd7bd870b9359c856784579))
* support exclude in rule imports ([20510da](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/20510da4bfd588d0b52bc054e6aec969bd4d01ab))
* update python parser to 0.21.0 ([f162064](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/f162064d8b64ade6670f2fd063d784de26b8cdd5))
* update queries ([8f912e5](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/8f912e53122ed21951bef0a016f436dd937b498a))
* update queries ([c62d293](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/c62d2933e0b1dbc3bb54b7183e87c479806cf710))
* update tree-sitter-python to 0.23.4 ([8dc721b](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/8dc721b6c851783efb667bc1a29216ea447452f6))
* update tree-sitter-python to 0.23.5 ([48b43fa](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/48b43fa64d65ba6c444ef6b48db1c91f8c28cd74))
* use external json to control directives ([c33ec31](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/c33ec31794b9962058cb286a591c14fb6faa1645))
* vibe to seperate wildcards from snakemake stem ([eac3201](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/eac3201feaee9fa9675d2eff50f8074022113e4e))


### Bug Fixes

* add localrule directive ([632f472](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/632f472a79a01cd4d1b8946c9517e60d0c41a664))
* add neovim example and release workflow ([861a421](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/861a42159f1c4f0583a6c3b526a96bfbd518a472))
* add tree-sitter.json ([29a82dd](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/29a82ddde86c0d428acf971b04794c13525c4bc5))
* allow $._newline in directives ([ba1b386](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/ba1b3868eaa960b945593404af9a7c2f296d3643))
* allow $._newline in directives ([1fadac9](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/1fadac9ff59e8ae6ec537c7340994c66d891922a))
* allow trailing comma in multiline arguments ([f98e8e6](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/f98e8e65d50d303282679f2a7992690efa3c1ff3))
* allow wildcards in conda directive ([308ee49](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/308ee499f76871c1f30a9ad7659ac775755a8a9e))
* ci ([44f0190](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/44f0190d53ef46df97a9d31d91d850b65d141cbc))
* ci ([b371780](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/b3717808ca19fabbef90ef920ea0828a58ee280c))
* clean more files ([a47692c](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/a47692cb017f5ca20680073460a3b07b0b0094da))
* code change requests by osthomas@github ([c47733d](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/c47733d8da88d5c8584883044cce77fd3d6c1df4))
* collect build_tools ([7aa8d8f](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/7aa8d8f24a0c99ec69e90df3a343909114c16f03))
* correct ci ([7d9e097](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/7d9e097f9ac4287b72516b83997b6a1cddaf0611))
* force push in ci ([3bf499a](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/3bf499acd3ef86b0ff6b1185d917d4d15ba72dd5))
* handle special directives ([c3f7ab9](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/c3f7ab9b9908644fd2f8998e497bf68116a14115))
* improve error handling ([ba1b386](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/ba1b3868eaa960b945593404af9a7c2f296d3643))
* improve error handling ([d962421](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/d962421d45a1b4e0d2a092e36dc9f7044ac2010a))
* optional($._docstring at the top of rule_body ([0745b73](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/0745b73a5990ca7e218cb21455d1e24602acbe8f))
* prepare to inject variables ([b5e5f51](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/b5e5f516f0e64e5f61cee46e3e39b7438dc62c79))
* recognize 'q' flag in wildcard interpolation ([bb24162](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/bb241628fccf182add6d3491a70ed5d75b277038))
* release ([f9f6715](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/f9f6715920a68339fc00df0f1d03decf1ddefc04))
* revert minor changes ([b7e13ea](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/b7e13eaa5d83c8ce9430968c4ce7981a69e47562))
* **scanner:** make functions static ([377fa20](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/377fa200bb9c8da2dc7297d6ed15e214caf7ce91))
* string defined in snakemake_iostr ([3429c88](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/3429c883e781eb829969202da9b28f12aadf16a2))
* **tests:** initial comments no longer children of directive_parameters ([311834e](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/311834ee86dfa4325b16c60d6bb617fe8ba076ca))
* update CI and README to use 'build' instead of 'codegen' ([f2e7e71](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/f2e7e71b1abd6fb5f57554992dc0cc609cf05476))
* update highlights generation ([d0927b2](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/d0927b2da48814d98f2c1c43bc96fec29ea490ad))
* update release ([46bfad5](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/46bfad5ea8d258a3e79d3a64a15cd100b6d9c86c))
* update tests ([bcf050d](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/bcf050d2aee7023ab07c5e93d7450cfe79c98908))


### Dependencies

* add auto release ([848e17c](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/848e17cac545b45e8af1da11b989b76db3727ca2))


### Documentation

* guide to Syncing with Snakemake ([fbda6c7](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/fbda6c7f860e746e346d7d1b054a86ec35d99039))
* more info in PR ([f8877db](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/f8877db0cbb336b0b055b19b3afd86e657c6ab87))
* reflect inclusion in nvim-treesitter ([ba1b386](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/ba1b3868eaa960b945593404af9a7c2f296d3643))
* reflect inclusion in nvim-treesitter ([72ec62b](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/72ec62be5e9dee8ec12377ea852a7e54eb106989))
* update README.md ([afb57b1](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/afb57b14ff69d1a6adedb67963217e4c7ee19ae6))
* update test usage instructions ([183dac7](https://github.com/Hocnonsense/tree-sitter-snakemake/commit/183dac737297a7a3b788c066d0926c1753f112b0))
