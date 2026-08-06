{
  versionSuffix ? "unknown",

  fetchFromGitHub,

  lib,
  vimPlugins,
  wrapNeovim,
  stylua,
  black,
  lua-language-server,
  nil,
  nixfmt,
  shfmt,
  ruff,
  basedpyright,
  prettier,
  mdformat,
  vue-language-server,
  typescript-language-server,
  ripgrep,
  rust-analyzer,
}:
let
  inherit (builtins)
    filter
    replaceStrings
    ;
  inherit (lib.strings)
    hasInfix
    join
    removePrefix
    ;

  treesitterGrammars = vimPlugins.nvim-treesitter.withPlugins (
    packages: with packages; [
      bash
      comment
      css
      csv
      diff
      dockerfile
      git_rebase
      gitattributes
      gitcommit
      gitignore
      graphql
      html
      javascript
      jsdoc
      json
      lua
      luadoc
      markdown
      markdown_inline
      nix
      python
      query
      regex
      requirements
      rust
      sql
      toml
      typescript
      vue
      yaml
    ]
  );

  getTreesitterPattern' =
    grammar:
    replaceStrings [ "bash_interactive" ] [ "bash" ] (
      removePrefix "nvim-treesitter-grammar-" grammar.pname
    );

  getTreesitterPattern = grammar: "\"${getTreesitterPattern' grammar}\"";

  getTreesitterPatterns =
    treesitterPkg:
    join ", " (
      map getTreesitterPattern (filter (dep: hasInfix "grammar" dep.name) treesitterPkg.dependencies)
    );
in
wrapNeovim {
  inherit versionSuffix;

  pname = "kadachi-nvim";

  cleanRuntimePath = true;
  additionalRuntimePaths = [ ".nvim" ];

  userConfig = ./config;

  startPlugins = [
    treesitterGrammars
  ]
  ++ (with vimPlugins; [
    lz-n
    lzn-auto-require
    nvim-lspconfig
    friendly-snippets
    fzf-lua
  ]);

  optPlugins = with vimPlugins; [
    blink-cmp
    catppuccin-nvim
    conform-nvim
    grug-far-nvim
    inc-rename-nvim
    lualine-nvim
    mini-icons
    nvim-autopairs
    nvim-spider
    oil-nvim

    (luasnip.overrideAttrs {
      src = fetchFromGitHub {
        owner = "aveeryy";
        repo = "LuaSnip";
        rev = "feat/transformation-formats";
        hash = "sha256-+DkDCe5uNY26LiFlvqcPUYg11oeLe84GBVb2aK0Mc3Y=";
      };
    })

    (obsidian-nvim.overrideAttrs {
      src = fetchFromGitHub {
        owner = "obsidian-nvim";
        repo = "obsidian.nvim";
        rev = "5acd67bd55eaeeb28cd7167ca48ba2276655137d";
        hash = "sha256-3HhlO6sqksmhcn2e+CJ20Hd/dTZVot6/K07QNPLmqRI=";
      };
    })
  ];

  extraPackages = [
    # LSPs
    basedpyright
    lua-language-server
    nil
    ruff
    rust-analyzer
    typescript-language-server
    vue-language-server

    # Formatters
    black
    nixfmt
    prettier
    shfmt
    stylua

    (mdformat.withPlugins (
      pythonPackages: with pythonPackages; [
        mdformat-frontmatter
        mdformat-gfm
        (buildPythonPackage (finalAttrs: {
          pname = "mdformat-obsidian";
          version = "0.3.2";

          src = fetchPypi {
            inherit (finalAttrs) version;
            pname = "mdformat_obsidian";
            hash = "sha256-HeVX5hxl9WMVKgM3qWRZJNiGSLfFyj8tM3kUH1uXMuw=";
          };

          dependencies = [
            pythonPackages.mdformat
            mdformat-gfm
            mdit-py-plugins
          ];

          pyproject = true;
          build-system = [
            uv-build
          ];

          doCheck = false;
        }))
        (buildPythonPackage (finalAttrs: {
          pname = "mdformat-wikilink";
          version = "0.3.0";

          src = fetchPypi {
            inherit (finalAttrs) version;
            pname = "mdformat_wikilink";
            hash = "sha256-qkglVLcU5tsZqYjQFFlSacbS6eaW0U2scX2MJezUEgE=";
          };

          dependencies = [
            pythonPackages.mdformat
            mdit-py-plugins
          ];

          pyproject = true;
          build-system = [
            poetry-core
          ];

          doCheck = false;
        }))
      ]
    ))

    # Other
    ripgrep
  ];

  extraLuaPackages =
    luaPkgs: with luaPkgs; [
      jsregexp
    ];

  extraInitLua = /* lua */ ''
    -- Treesitter initialization
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { ${getTreesitterPatterns treesitterGrammars} },
      callback = function (ev)
        vim.api.nvim_buf_call(ev.buf, function ()
          vim.treesitter.start()
        end)
        vim.bo[ev.buf].indentexpr = "v:lua.require'kadachi-nvim.config.indent'.indentexpr()";
      end
    })

    -- Vue language server
    vim.g.vue_language_server = "${vue-language-server}/lib/language-tools/packages/language-server";
  '';
}
