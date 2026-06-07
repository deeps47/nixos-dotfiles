{ config, pkgs, lib, ... }:

{
  # Ensure unfree packages are allowed so Nix can fetch the proprietary CUDA toolkit
  nixpkgs.config.allowUnfree = true;

  # 1. The LLM Engine
  services.ollama = {
    enable = true;
    # Use the explicitly compiled CUDA package
    package = pkgs.ollama-cuda;
    environmentVariables.OLLAMA_CONTEXT_LENGTH = "32768";
  };

  # 2. The Web Scraper (Privacy-respecting search)
  services.searx = {
    enable = true;
    # Use the actively maintained SearXNG fork
    package = pkgs.searxng;

    settings = {
      server = {
        port = 8080;
        bind_address = "127.0.0.1";
        # SearXNG requires a secret key to boot. 
        # In a production environment, generate a secure string via sops/agenix.
        secret_key = "49d196ca478e313324621d81c78e2b5244d630a7008b89021d1f82015d06b12a";
      };
      search = {
        # Open WebUI requires the JSON format to parse the search results
        formats = [ "html" "json" ];
      };
    };
  };

  # 3. The Interface (Glues Ollama and SearXNG together)
  services.open-webui = {
    enable = true;
    port = 3000;

    # Inject the environment variables to configure RAG and tool usage
    environment = {
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";

      ENABLE_WEB_SEARCH = "true";
      WEB_SEARCH_ENGINE = "searxng";
      SEARXNG_QUERY_URL = "http://127.0.0.1:8080/search?q=<query>";

      # 1. Lock down the settings UI
      ENABLE_PERSISTENT_CONFIG = "false";
      USER_AGENT = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0 Safari/537.36";
    };
  };
  # --- PREVENT AUTOSTART ON BOOT ---
  systemd.services.ollama.wantedBy = lib.mkForce [ ];
  systemd.services.searx.wantedBy = lib.mkForce [ ];
  systemd.services.open-webui.wantedBy = lib.mkForce [ ];

}
