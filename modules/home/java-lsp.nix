# Java language server in Neovim (t480, s720): nvim-jdtls with jdt-language-server, Lombok and
# formatting by jdtls. No debugger and no JUnit plugin here: debugging is done in VS Code, tests
# run with Space t t (mvn test in a terminal split).
{ config, lib, pkgs, ... }:

let
  cfg = config.my.java;
  lombokAgent = "${pkgs.lombok}/share/java/lombok.jar";
in
{
  options.my.java.jdtlsXmx = lib.mkOption {
    type = lib.types.str;
    default = "1g";
    description = "Maximum heap of the Java language server (jdtls).";
  };

  config.programs.nixvim = {
    # nvim-jdtls starts the server itself, so the plain lspconfig entry from neovim.nix is
    # switched off here.
    plugins.lsp.servers.jdtls.enable = lib.mkForce false;
    extraPlugins = [ pkgs.vimPlugins.nvim-jdtls ];
    extraPackages = [ pkgs.jdt-language-server ];

    keymaps = [
      { mode = "n"; key = "<leader>cf"; action = "<cmd>lua vim.lsp.buf.format({ async = true })<CR>"; options.desc = "Format file (jdtls)"; }
    ];

    extraConfigLua = ''
      -- Java: jdtls, one server per project
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'java',
        callback = function()
          local jdtls = require('jdtls')
          local root = vim.fs.root(0, { 'mvnw', 'gradlew', 'pom.xml', 'build.gradle', '.git' }) or vim.fn.getcwd()
          local workspace = vim.fn.stdpath('cache') .. '/jdtls/' .. vim.fn.sha256(root):sub(1, 12)

          jdtls.start_or_attach({
            cmd = { 'jdtls', '--jvm-arg=-Xmx${cfg.jdtlsXmx}', '--jvm-arg=-javaagent:${lombokAgent}', '-data', workspace },
            root_dir = root,
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
            on_attach = function(_, bufnr)
              local function map(key, fn, desc)
                vim.keymap.set('n', key, fn, { buffer = bufnr, desc = desc })
              end
              map('<leader>jo', jdtls.organize_imports, 'Java: organize imports')
              -- Tests: mvn test (the wrapper if the project has one) in a terminal split at the project root
              map('<leader>tt', function()
                local mvn = vim.uv.fs_stat(root .. '/mvnw') and './mvnw' or 'mvn'
                vim.cmd('botright 15split | terminal cd ' .. vim.fn.shellescape(root) .. ' && ' .. mvn .. ' test')
              end, 'Test: mvn test in a split')
            end,
          })
        end,
      })
    '';
  };
}
