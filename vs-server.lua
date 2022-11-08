------------------------------------------------------------------------------
-- vsAuth | By: Vieira's Store
------------------------------------------------------------------------------
function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

-------------------------------------------
-- CONFIGURAÇÕES DA AUTH ⬇
-------------------------------------------
local AuthIsOK = "XXXXX" -- Coloque sua webhook substituindo os XXXXX
local AuthIsNotOK = "XXXXX" -- Coloque sua webhook substituindo os XXXXX
local AuthIsTimeOut = "XXXXX" -- Coloque sua webhook substituindo os XXXXX

local authorizationIp = "0.0.0.0" -- Substitua 0.0.0.0 com o IP de quem poderá autenticar esse script. (Site para pegar o IP: https://meuip.com.br)

local AuthScript = false -- Deixe em false para a autenticação funcionar
-------------------------------------------
-- CONFIGURAÇÕES DA AUTH ^
-------------------------------------------

if debug.getinfo( PerformHttpRequest ).short_src:find("citizen:/scripting/lua/scheduler.lua") then

PerformHttpRequest("http://api.ipify.org/", function(err, data)
    if err >= 200 and err <= 299 then
        local receivedIp = data
        if authorizationIp == receivedIp then
            AuthScript = true
            Wait(1000)
            print("^2[resource_name] Autenticado - Qualquer duvida -> Name#XXXX") -- Substitua Name#XXXX Pelo seu discord EX: EuNoah#8056
            SendWebhookMessage(AuthIsOK,"```prolog\n[O IP]: "..receivedIp.."\n[AUTENTICOU]: O Script [resource_name]" ..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        else
            AuthScript = false
            Wait(1000)
            print("^8[resource_name] Não autenticado - Qualquer duvida -> Name#XXXX") -- Substitua Name#XXXX Pelo seu discord EX: EuNoah#8056
            SendWebhookMessage(AuthIsNotOK,"```prolog\n[O IP]: "..receivedIp.."\n[NÃO AUTENTICOU]: O Script [resource_name] utilizando a licença do IP: "..authorizationIp.." " ..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
            Wait(10000)
            os.exit()
        end
    else
        AuthScript = false
        Wait(1000)
        print("^3[resource_name] Não autenticado - Falha na autenticação - Avise o -> Name#XXXX") -- Substitua Name#XXXX Pelo seu discord EX: EuNoah#8056
        SendWebhookMessage(AuthIsTimeOut,"```prolog\n[O IP]: N/A \n[NÃO AUTENTICOU]: O Script [resource_name] Pois não conseguimos pegar o IP dele." ..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        Wait(10000)
        os.exit()
    end
end)
else
    AuthScript = false
    print("^3[resource_name] Nao autenticado - Codigo de burlamento de auth encontrado. - Qualquer duvida -> Name#XXXX") -- Substitua Name#XXXX Pelo seu discord EX: EuNoah#8056
    os.exit()
end
