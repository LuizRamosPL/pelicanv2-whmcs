# Pelican V2 - Advanced WHMCS Provisioning Module

Um módulo premium e de nível de produção para integrar o **Pelican Panel** (e Pterodactyl v1.x) ao **WHMCS**. Este módulo vai além do simples provisionamento: ele entrega uma experiência completa de "Painel de Controle" diretamente dentro da Área do Cliente do seu WHMCS, reduzindo drasticamente os tickets de suporte.

## ✨ Funcionalidades Principais

* **Provisionamento Automatizado:** Criação, Suspensão, Reativação e Cancelamento automáticos de servidores.
* **Console Web Interativo (Real-Time):** Terminal `Xterm.js` embutido na Área do Cliente. Permite visualizar logs de inicialização e enviar comandos para o servidor (ex: `op nome`, `say olá`) sem precisar abrir o painel Pelican.
* **Dashboard de Métricas ao Vivo:** Cartões estilizados que se atualizam automaticamente exibindo o Status do Servidor, Uso de CPU, Memória RAM e Disco (Via AJAX + Client API).
* **Controles de Energia (Power Actions):** Botões nativos na interface do WHMCS para iniciar, reiniciar, parar ou forçar a parada (kill) do servidor.
* **UX/UI Premium:** Botões modernos, design inspirado no console do MacOS, botão inteligente de "Copiar IP" e sistema de "Clear Console".
* **Ferramentas para o Administrador:** Botão customizado "Reinstall Server" disponível na página de gerenciamento do admin no WHMCS.

---

## 📋 Requisitos do Sistema

* **WHMCS:** Versão 8.x ou superior.
* **Painel:** Pelican Panel v1.x (ou Pterodactyl v1.x).
* **PHP:** 7.4, 8.0, 8.1 ou 8.2.

---

## 🚀 Como Instalar e Configurar

### Passo 1: Upload dos Arquivos
1. Faça o download/clone deste repositório.
2. Envie a pasta `pelicanv2` para dentro do diretório de módulos de servidor do seu WHMCS: `seu-whmcs/modules/servers/`.

### Passo 2: Gerar as Chaves de API no Pelican
Para que o módulo consiga tanto gerenciar a infraestrutura (criar servidores) quanto exibir o console ao vivo, você precisará de **DUAS** chaves de API diferentes criadas por um usuário Administrador:

1. **Application API Key (Para Provisionamento):**
   * Logue no Pelican como Administrador.
   * Vá no **Painel de Admin** (engrenagem no topo) -> **API**.
   * Clique em "Create New". Dê todas as permissões de leitura e escrita (Read/Write) para Nodes, Allocations, Users, Servers, etc.
   * Copie o token secreto gigante gerado.

2. **Client API Key (Para o Web Console e Gráficos):**
   * Ainda logado como Administrador, saia do painel de Admin e clique na sua foto/nome no canto superior direito -> **Minha Conta (Account)**.
   * Vá na aba **API Credentials**.
   * Digite uma descrição (ex: "Console WHMCS") e clique em **Create**.
   * ⚠️ **Atenção:** Um popup verde vai aparecer no meio da tela. **Copie o token secreto GIGANTE dentro desse popup**. O texto curto que fica na lista (`pacc_...`) não funciona, você precisa do token do popup!

### Passo 3: Configurar o Servidor no WHMCS
1. No seu WHMCS, vá em **Opções (Setup) -> Produtos/Serviços -> Servidores**.
2. Adicione um novo servidor:
   * **Nome:** Pelican Panel
   * **Hostname:** A URL completa do seu painel (ex: `https://painel.suahospedagem.com.br`).
   * **Endereço IP:** (Deixe em branco).
   * **Tipo do Módulo:** Escolha `Pelicanv2`.
   * **Usuário:** (Deixe em branco).
   * **Senha (Password):** Cole aqui a sua **Application API Key** (aquela gerada no painel de admin).
   * **Hash de Acesso (Access Hash):** Cole aqui a sua **Client API Key** (aquela gerada no seu perfil de usuário com o popup verde).
   * **Seguro (SSL):** Marque a caixinha se o painel usa HTTPS (Recomendado).

### Passo 4: Liberação de Segurança do Web Console (CORS) 🚨 CRÍTICO
Por motivos de segurança, o daemon do Pelican (`Wings`) bloqueia tentativas de leitura do terminal vindas de outros sites que não sejam o próprio painel. Para que o terminal carregue dentro do site do seu WHMCS, você deve adicionar a URL do seu WHMCS na lista de origens permitidas (CORS) do nó físico.

1. Acesse o **SSH do servidor físico (Node)** onde os jogos rodam.
2. Edite o arquivo de configuração do Wings: `nano /etc/pelican/config.yml` (ou `/etc/pterodactyl/config.yml`).
3. Procure a linha `allowed_origins:` e adicione a URL exata do seu WHMCS. Exemplo:
```yaml
allowed_origins:
  - "https://painel.suahospedagem.com.br"
  - "https://whmcs.suahospedagem.com.br"
```
4. Salve o arquivo e reinicie o Wings: `systemctl restart wings` (ou `systemctl restart pelican-wings`).
5. *Nota: Se a tela do console no WHMCS ficar com erro de "Falha de Rede", certifique-se de que tanto o WHMCS quanto o Wings estão rodando com certificados SSL válidos (HTTPS/WSS).*

---

## 🛠 Configuração do Produto no WHMCS

Ao criar o produto/serviço no WHMCS e vincular a este módulo, vá na aba **Configurações do Módulo (Module Settings)** e preencha os Custom Fields conforme o padrão do Pterodactyl:

* **Location ID:** ID da localização onde o servidor será criado.
* **Egg ID:** ID do jogo/egg.
* **Memory / Swap / CPU / Disk:** Limites de recursos em MB/%.
* **Port Range:** (Opcional) Portas permitidas separadas por vírgula.
* Etc...

---

## 📜 Licença e Créditos
Este módulo foi amplamente refatorado para garantir máxima estabilidade em ambientes de produção rodando PHP 8+, integrando as melhores práticas de WebSockets de maneira assíncrona. Aproveite!
