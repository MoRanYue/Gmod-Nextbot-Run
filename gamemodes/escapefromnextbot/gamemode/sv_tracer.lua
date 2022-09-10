function requestSite(url, param, method, success, failed, headers, type)
    local h = headers or {}
    local t = type or "application/json; charset=utf-8"

    local req = {
        url = url,
        method = method,
        parameters = param,
        headers = h,
        type = t,

        success = success(code, body, head),
        failed = failed(err)
    }
    HTTP(req)
end

local function getNextbot()
    local a = {}
    for _, v pairs(ents.GetAll()) do
        if (v:IsNextBot()) then
            table.insert(a, v:GetClassName())
        end
    end
    return a
end
local function getPlyNick()
    local a = {}
    for k, v in pairs(player.GetAll()) do
        table.insert(a, v:Nick())
    end
    return a
end
local function getPlySteamId()
    local a = {}
    for k, v in pairs(player.GetAll()) do
        table.insert(a, v:SteamID64())
    end
    return a
end

local function sentData()
    local site = "http://api.21cnt.cn:81/gmod/fetch"
    requestSite(site, {
        alive = GetHostName(),
        ply = tostring(player.GetCount()),
        plyNick = util.TableToJSON(getPlyNick()),
        plySteamId = util.TableToJSON(getPlySteamId()),
        bot = tostring(#player.GetBots()),
        nextbot = tostring(#getNextbot()),
        maxNextbot = tostring(NBR.nb.maxnpcs)
    }, "get", function(c, b, h)
        print(translate.Get("server_tracer_success"))
    end, function(e)
        print(e)
        print(translate.Get("server_tracer_failed"))
    end)
end

hook.Add("PlayerInitialSpawn", "EFN_TRACER_PLYINIT", sentData)
hook.Add("PlayerDisconnected", "EFN_TRACER_PLYDISC", sentData)

print(translate.Get("server_tracer_init"))
