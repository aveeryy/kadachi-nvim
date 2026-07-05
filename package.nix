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
  ]);

  optPlugins = with vimPlugins; [
    blink-cmp
    catppuccin-nvim
    conform-nvim
    fzf-lua
    grug-far-nvim
    inc-rename-nvim
    lualine-nvim
    mini-icons
    nvim-autopairs
    nvim-spider
    oil-nvim

    (luasnip.overrideAttrs (_: {
      src = fetchFromGitHub {
        owner = "aveeryy";
        repo = "LuaSnip";
        rev = "feat/transformation-formats";
        hash = "sha256-9qYBuxbHG3/6LjTcsC3bp81j2GdAsgRpSNgt+/ssmFc=";
      };
    }))
  ];

  extraPackages = [
    # LSPs
    basedpyright
    lua-language-server
    nil
    ruff
    typescript-language-server
    vue-language-server

    # Formatters
    black
    mdformat
    nixfmt
    prettier
    shfmt
    stylua

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
