{
  versionSuffix ? "unknown2",

  lib,
  vimPlugins,
  wrapNeovim,
  stylua,
  black,
  lua-language-server,
  nil,
  nixfmt,
  shfmt,
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
      html
      javascript
      jsdoc
      json
      lua
      markdown
      markdown_inline
      nix
      python
      toml
      typescript
      vue
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
  ];

  extraPackages = [
    # LSPs
    lua-language-server
    nil
    shfmt

    # Formatters
    black
    nixfmt
    stylua
  ];

  extraInitLua = /* lua */ ''
    -- Treesitter initialization
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { ${getTreesitterPatterns treesitterGrammars} },
      callback = function (ev)
        vim.api.nvim_buf_call(ev.buf, function ()
          vim.treesitter.start()
        end)
      end
    })
  '';
}
