# Java and Kafka profile for the machines used for coding (t480, s720): jdtls with debugger
# and JUnit from the editor, google-java-format, kcat. The broker itself is dev/kafka/compose.yaml.
{ config, lib, pkgs, ... }:

let
  cfg = config.my.java;
  debugServer = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server";
  testServer = "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server";
  kafkaCompose = "~/repositories/nixos-config/dev/kafka/compose.yaml";
in
{
  options.my.java.jdtlsXmx = lib.mkOption {
    type = lib.types.str;
    default = "1g";
    description = "Maximum heap of the Java language server (jdtls).";
  };

  config = {
    home.packages = with pkgs; [
      kcat
    ];

    # Start the broker only when needed: `kafka-up`, `kafka-ui-up`, `kafka-down` (see dev/kafka/README.md)
    programs.bash.shellAliases = {
      kafka-up = "podman-compose -f ${kafkaCompose} up -d";
      kafka-ui-up = "podman-compose -f ${kafkaCompose} --profile ui up -d";
      kafka-down = "podman-compose -f ${kafkaCompose} --profile ui down";
    };

    programs.nixvim = {
      # nvim-jdtls starts the server itself (needed for the debugger bundles), so the plain
      # lspconfig entry from neovim.nix is switched off here.
      plugins.lsp.servers.jdtls.enable = lib.mkForce false;
      extraPlugins = [ pkgs.vimPlugins.nvim-jdtls ];
      extraPackages = [ pkgs.jdt-language-server pkgs.google-java-format ];

      plugins.dap.enable = true;
      plugins.dap-ui.enable = true;
      plugins.dap-virtual-text.enable = true;

      plugins.conform-nvim = {
        enable = true;
        settings.formatters_by_ft.java = [ "google-java-format" ];
      };

      keymaps = [
        { mode = "n"; key = "<F5>"; action = "<cmd>lua require('dap').continue()<CR>"; options.desc = "Debug: continue/start"; }
        { mode = "n"; key = "<F10>"; action = "<cmd>lua require('dap').step_over()<CR>"; options.desc = "Debug: step over"; }
        { mode = "n"; key = "<F11>"; action = "<cmd>lua require('dap').step_into()<CR>"; options.desc = "Debug: step into"; }
        { mode = "n"; key = "<F12>"; action = "<cmd>lua require('dap').step_out()<CR>"; options.desc = "Debug: step out"; }
        { mode = "n"; key = "<leader>db"; action = "<cmd>lua require('dap').toggle_breakpoint()<CR>"; options.desc = "Debug: toggle breakpoint"; }
        { mode = "n"; key = "<leader>dB"; action = "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Condition: '))<CR>"; options.desc = "Debug: conditional breakpoint"; }
        { mode = "n"; key = "<leader>du"; action = "<cmd>lua require('dapui').toggle()<CR>"; options.desc = "Debug: toggle UI"; }
        { mode = "n"; key = "<leader>dr"; action = "<cmd>lua require('dap').repl.toggle()<CR>"; options.desc = "Debug: REPL"; }
        { mode = "n"; key = "<leader>dl"; action = "<cmd>lua require('dap').run_last()<CR>"; options.desc = "Debug: run last"; }
        { mode = "n"; key = "<leader>dx"; action = "<cmd>lua require('dap').terminate()<CR>"; options.desc = "Debug: stop"; }
        { mode = "n"; key = "<leader>cf"; action = "<cmd>lua require('conform').format({ async = true, lsp_format = 'fallback' })<CR>"; options.desc = "Format file"; }
      ];

      extraConfigLua = ''
        -- open and close the debug UI together with the debug session
        local dap, dapui = require('dap'), require('dapui')
        dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
        dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
        dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

        -- Java: jdtls + java-debug + java-test, one server per project
        vim.api.nvim_create_autocmd('FileType', {
          pattern = 'java',
          callback = function()
            local jdtls = require('jdtls')
            local root = vim.fs.root(0, { 'mvnw', 'gradlew', 'pom.xml', 'build.gradle', '.git' }) or vim.fn.getcwd()
            local workspace = vim.fn.stdpath('cache') .. '/jdtls/' .. vim.fn.sha256(root):sub(1, 12)

            local bundles = {}
            for _, jar in ipairs(vim.split(vim.fn.glob('${debugServer}/com.microsoft.java.debug.plugin-*.jar'), '\n')) do
              if jar ~= "" then table.insert(bundles, jar) end
            end
            for _, jar in ipairs(vim.split(vim.fn.glob('${testServer}/*.jar'), '\n')) do
              local name = vim.fn.fnamemodify(jar, ':t')
              if jar ~= "" and name ~= 'com.microsoft.java.test.runner-jar-with-dependencies.jar' and name ~= 'jacocoagent.jar' then
                table.insert(bundles, jar)
              end
            end

            jdtls.start_or_attach({
              cmd = { 'jdtls', '--jvm-arg=-Xmx${cfg.jdtlsXmx}', '-data', workspace },
              root_dir = root,
              capabilities = require('cmp_nvim_lsp').default_capabilities(),
              init_options = { bundles = bundles },
              on_attach = function(_, bufnr)
                jdtls.setup_dap({ hotcodereplace = 'auto' })
                require('jdtls.dap').setup_dap_main_class_configs()
                local function map(key, fn, desc)
                  vim.keymap.set('n', key, fn, { buffer = bufnr, desc = desc })
                end
                map('<leader>tn', jdtls.test_nearest_method, 'Test: nearest method')
                map('<leader>tc', jdtls.test_class, 'Test: class')
                map('<leader>jo', jdtls.organize_imports, 'Java: organize imports')
              end,
            })
          end,
        })
      '';
    };
  };
}
