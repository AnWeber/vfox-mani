--- Return all available versions provided by this plugin
--- @param ctx table Empty table used as context, for future extension
--- @return table Descriptions of available versions and accompanying tool descriptions
function PLUGIN:Available(ctx)
    return fetchVersions()
end

local http = require("http")
local json = require("json")
local util = require("./util")

function fetchVersions()
    local result = {}
    local headers = {
        ["Accept"] = "application/vnd.github+json",
    }
    if isGithubToken(util.githubToken) then
        headers = {
            ["Accept"] = "application/vnd.github+json",
            ["Authorization"] = "Bearer " .. util.githubToken,
        }
    end
    local resp, err = http.get({
        -- Authenticate to get higher rate limit
        headers = headers,
        url = "https://api.github.com/repos/alajmo/mani/releases?per_page=60",
    })
    if err ~= nil then
        error("Failed to get information: " .. err)
    end
    if resp.status_code ~= 200 then
        error("Failed to get information: " .. err .. "\nstatus_code => " .. resp.status_code)
    end
    local releases = json.decode(resp.body)

    for i, release in ipairs(releases) do
        local version = release.tag_name:sub(2)
        if i == 1 then
            table.insert(result, {
                version = version,
                note = "latest",
            })
        else
            table.insert(result, {
                version = version,
            })
        end
        ::continue::
    end


    return result
end
