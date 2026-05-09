<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/xterm@4.19.0/css/xterm.css" />
<script src="https://cdn.jsdelivr.net/npm/xterm@4.19.0/lib/xterm.js"></script>
<script src="https://cdn.jsdelivr.net/npm/xterm-addon-fit@0.5.0/lib/xterm-addon-fit.js"></script>

<style>
.premium-stat-box {
    background: #fff;
    border: 1px solid #e3e6f0;
    border-radius: 8px;
    padding: 15px 10px;
    text-align: center;
    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    margin-bottom: 20px;
    transition: transform 0.2s;
}
.premium-stat-box:hover {
    transform: translateY(-2px);
}
.premium-stat-box h5 {
    margin: 0 0 10px 0;
    font-size: 11px;
    font-weight: bold;
    color: #858796;
    text-transform: uppercase;
}
.premium-stat-box h3 {
    margin: 0;
    font-size: 20px;
    font-weight: bold;
    color: #3a3b45;
}
.status-indicator {
    display: inline-block;
    width: 10px;
    height: 10px;
    border-radius: 50%;
    margin-right: 5px;
}
.status-running { background-color: #1cc88a; box-shadow: 0 0 6px #1cc88a; }
.status-offline { background-color: #e74a3b; box-shadow: 0 0 6px #e74a3b; }
.status-starting { background-color: #f6c23e; box-shadow: 0 0 6px #f6c23e; }

.terminal-wrapper {
    background: #1e1e1e;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 5px 15px rgba(0,0,0,0.3);
    margin-bottom: 20px;
}
.terminal-header {
    background: #2d2d2d;
    padding: 8px 15px;
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    justify-content: space-between;
}
.mac-btn {
    width: 12px;
    height: 12px;
    border-radius: 50%;
    display: inline-block;
    margin-right: 6px;
}
.mac-close { background: #ff5f56; }
.mac-min { background: #ffbd2e; }
.mac-max { background: #27c93f; }
.mac-actions { display: flex; align-items: center; }
.terminal-power-btns { margin-left: auto; }
.terminal-power-btns .btn { margin-left: 5px; font-weight: bold; font-size: 11px; padding: 3px 8px; }
.terminal-title {
    color: #888;
    font-size: 13px;
    margin-left: 10px;
    font-family: monospace;
}
.terminal-container {
    padding: 10px;
    height: 420px;
    width: 100%;
}
.header-flex {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 25px;
    flex-wrap: wrap;
}
@media (max-width: 768px) {
    .header-flex { flex-direction: column; align-items: flex-start; }
    .header-flex .btn { margin-top: 15px; width: 100%; }
}
</style>

<div class="header-flex">
    <h3 style="margin: 0;"><i class="fas fa-server"></i> Gerenciamento do Servidor</h3>
    <a href="{$serviceurl}" target="_blank" class="btn btn-primary"><i class="fas fa-external-link-alt"></i> Acessar Painel Completo</a>
</div>

<div class="row">
    <div class="col-md-3 col-sm-6">
        <div class="premium-stat-box">
            <h5>Status do Servidor</h5>
            <h3 id="stat-status"><span class="status-indicator status-offline"></span> Carregando...</h3>
        </div>
    </div>
    <div class="col-md-3 col-sm-6">
        <div class="premium-stat-box">
            <h5>Uso de CPU</h5>
            <h3 id="stat-cpu">0%</h3>
        </div>
    </div>
    <div class="col-md-3 col-sm-6">
        <div class="premium-stat-box">
            <h5>Uso de RAM</h5>
            <h3 id="stat-ram">0 MB</h3>
        </div>
    </div>
    <div class="col-md-3 col-sm-6">
        <div class="premium-stat-box">
            <h5>Uso de Disco</h5>
            <h3 id="stat-disk">0 MB</h3>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        <div class="terminal-wrapper">
            <div class="terminal-header">
                <div class="mac-actions">
                    <span class="mac-btn mac-close"></span>
                    <span class="mac-btn mac-min"></span>
                    <span class="mac-btn mac-max"></span>
                    <span class="terminal-title">user@{$servername}: ~</span>
                </div>
                <div class="terminal-power-btns">
                    <button id="btn-clear" class="btn btn-default btn-sm" title="Limpar Console"><i class="fas fa-broom"></i> Limpar</button>
                    <button id="btn-start" class="btn btn-success btn-sm"><i class="fas fa-play"></i> Start</button>
                    <button id="btn-restart" class="btn btn-primary btn-sm"><i class="fas fa-sync-alt"></i> Restart</button>
                    <button id="btn-stop" class="btn btn-warning btn-sm"><i class="fas fa-stop"></i> Stop</button>
                    <button id="btn-kill" class="btn btn-danger btn-sm"><i class="fas fa-skull-crossbones"></i> Kill</button>
                </div>
            </div>
            <div id="terminal" class="terminal-container"></div>
            <div style="padding: 10px; background: #2d2d2d; border-top: 1px solid #444;">
                <div class="input-group">
                    <input type="text" id="console-input" class="form-control" placeholder="Digite um comando aqui e aperte Enter..." style="background: #1e1e1e; color: #fff; border: 1px solid #444;">
                    <span class="input-group-btn">
                        <button class="btn btn-primary" type="button" id="console-send">Enviar</button>
                    </span>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fas fa-info-circle"></i> Detalhes T&eacute;cnicos e Limites</h3>
            </div>
            <table class="table table-striped table-bordered" style="margin-bottom: 0;">
                <tr>
                    <td width="25%"><strong>Nome do Servidor</strong></td><td width="25%">{$servername}</td>
                    <td width="25%"><strong>Endere&ccedil;o IP</strong></td>
                    <td width="25%">
                        {if $ip}
                            <span id="server-ip">{$ip}:{$port}</span> 
                            <button class="btn btn-default btn-xs" style="margin-left: 5px;" onclick="copyIpToClipboard(this)" title="Copiar IP"><i class="far fa-copy"></i> Copiar</button>
                        {else}
                            Atribuindo...
                        {/if}
                    </td>
                </tr>
                <tr>
                    <td><strong>Limite de CPU</strong></td><td>{$cpu}%</td>
                    <td><strong>Limite de RAM</strong></td><td>{$memory} MB</td>
                </tr>
                <tr>
                    <td><strong>Limite de Disco</strong></td><td>{$disk} MB</td>
                    <td><strong>Status no WHMCS</strong></td><td>Ativo</td>
                </tr>
            </table>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    var serviceId = "{$serviceid}"; 
    var baseUrl = "clientarea.php?action=productdetails&id=" + serviceId + "&modop=custom&a=";
    
    var term = new Terminal({
        theme: { background: '#000000', foreground: '#ffffff' },
        disableStdin: true,
        cursorBlink: false,
        convertEol: true
    });
    var fitAddon = new FitAddon.FitAddon();
    term.loadAddon(fitAddon);
    term.open(document.getElementById('terminal'));
    fitAddon.fit();
    
    term.writeln('\x1b[33m[WHMCS] Tentando conectar ao daemon do Wings...\x1b[0m');

    var ws = null;
    
    function formatBytes(bytes) {
        if (bytes === 0) return '0 MB';
        var mb = bytes / 1024 / 1024;
        return mb.toFixed(2) + ' MB';
    }

    // Connect to WebSocket
    fetch(baseUrl + "GetConsoleToken")
        .then(res => res.json())
        .then(data => {
            if(!data.success) {
                term.writeln('\x1b[31m[WHMCS] Falha na conexao: ' + (data.error || 'Erro desconhecido') + '\x1b[0m');
                term.writeln('\x1b[31m[WHMCS] Dica: O Administrador precisa adicionar a Client API Key no campo "Access Hash" nas configuracoes do Servidor.\x1b[0m');
                return;
            }
            
            ws = new WebSocket(data.data.socket);
            
            ws.onerror = function(err) {
                term.writeln('\x1b[31m[WHMCS] Falha de Rede (Network Error). O navegador bloqueou a conexao com o Wings.\x1b[0m');
                term.writeln('\x1b[31m[WHMCS] Dica: Verifique se o seu WHMCS esta com HTTPS e o Wings tambem, ou aperte F12 para ver o erro do navegador.\x1b[0m');
            };

            ws.onopen = function() {
                ws.send(JSON.stringify({ event: "auth", args: [data.data.token] }));
                term.writeln('\x1b[32m[WHMCS] Conexao com o Wings estabelecida com sucesso!\x1b[0m');
                
                // Pedir logs passados
                ws.send(JSON.stringify({ event: "send logs", args: [] }));
            };
            
            ws.onmessage = function(msg) {
                var payload = JSON.parse(msg.data);
                if(payload.event === "console output") {
                    payload.args.forEach(line => term.writeln(line));
                }
            };
            
            ws.onclose = function() {
                term.writeln('\x1b[31m[WHMCS] Conexao encerrada.\x1b[0m');
            };

            function sendConsoleInput() {
                var inputEl = document.getElementById('console-input');
                var val = inputEl.value;
                if(val && ws && ws.readyState === WebSocket.OPEN) {
                    ws.send(JSON.stringify({ event: "send command", args: [val] }));
                    term.writeln('\x1b[33m> ' + val + '\x1b[0m');
                    inputEl.value = '';
                }
            }

            document.getElementById('console-send').addEventListener('click', sendConsoleInput);
            document.getElementById('console-input').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') sendConsoleInput();
            });

            function sendPowerAction(signal, btnId) {
                var btn = document.getElementById(btnId);
                var originalHtml = btn.innerHTML;
                btn.disabled = true;
                btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> ...';

                fetch(baseUrl + "SendPowerAction&signal=" + signal)
                    .then(res => res.json())
                    .then(data => {
                        btn.disabled = false;
                        btn.innerHTML = originalHtml;
                        if(data.success) {
                            term.writeln('\x1b[33m[WHMCS] Sinal de energia enviado: ' + signal + '\x1b[0m');
                            updateStats();
                        } else {
                            term.writeln('\x1b[31m[WHMCS] Erro ao enviar sinal: ' + data.error + '\x1b[0m');
                        }
                    }).catch(err => {
                        btn.disabled = false;
                        btn.innerHTML = originalHtml;
                        term.writeln('\x1b[31m[WHMCS] Erro de rede ao enviar sinal de energia.\x1b[0m');
                    });
            }

            document.getElementById('btn-start').addEventListener('click', () => sendPowerAction('start', 'btn-start'));
            document.getElementById('btn-restart').addEventListener('click', () => sendPowerAction('restart', 'btn-restart'));
            document.getElementById('btn-stop').addEventListener('click', () => sendPowerAction('stop', 'btn-stop'));
            document.getElementById('btn-kill').addEventListener('click', () => sendPowerAction('kill', 'btn-kill'));
            
            document.getElementById('btn-clear').addEventListener('click', () => {
                term.clear();
            });

        }).catch(err => {
            term.writeln('\x1b[31m[WHMCS] Erro na rota do WHMCS: ' + err + '\x1b[0m');
        });

    function updateStats() {
        fetch(baseUrl + "GetLiveStats")
            .then(res => res.json())
            .then(data => {
                if(data.success && data.attributes) {
                    var state = data.attributes.current_state;
                    var res = data.attributes.resources;
                    
                    var statusHtml = '<span class="status-indicator status-offline"></span> Offline';
                    if (state === 'running') statusHtml = '<span class="status-indicator status-running"></span> Online';
                    else if (state === 'starting') statusHtml = '<span class="status-indicator status-starting"></span> Iniciando';
                    else if (state === 'stopping') statusHtml = '<span class="status-indicator status-offline"></span> Parando';
                    
                    document.getElementById('stat-status').innerHTML = statusHtml;
                    document.getElementById('stat-cpu').innerText = res.cpu_absolute.toFixed(2) + '%';
                    document.getElementById('stat-ram').innerText = formatBytes(res.memory_bytes);
                    document.getElementById('stat-disk').innerText = formatBytes(res.disk_bytes);
                }
            });
    }

    updateStats();
    setInterval(updateStats, 5000); // 5 segundos
    
    window.addEventListener('resize', () => { fitAddon.fit(); });
    
    window.copyIpToClipboard = function(btn) {
        var ipText = document.getElementById('server-ip').innerText;
        var tempInput = document.createElement("input");
        tempInput.value = ipText;
        document.body.appendChild(tempInput);
        tempInput.select();
        document.execCommand("copy");
        document.body.removeChild(tempInput);
        
        var originalHtml = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-check text-success"></i> Copiado';
        setTimeout(function() { btn.innerHTML = originalHtml; }, 2000);
    };
});
</script>