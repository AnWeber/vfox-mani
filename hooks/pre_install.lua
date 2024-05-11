--- Returns some pre-installed information, such as version number, download address, local files, etc.
--- If checksum is provided, vfox will automatically check it for you.

--- @return table Version information
function PLUGIN:PreInstall(ctx)
    local file, headers, version = getDownloadInfo(ctx.version)

    return {
        url = file,
        headers = headers,
        version = version
    }
end

-- pre_install.lua
function getDownloadInfo(version)
    local file
    local headers
    if version == "latest" then
        version = getLatestVersion()
    end
    file = generateURL(version, RUNTIME.osType, RUNTIME.archType)

    return file, headers, version
end

local http = require("http")
local json = require("json")
local util = require("./util")

function getLatestVersion()
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
        headers = headers,
        url = "https://api.github.com/repos/alajmo/mani/releases/latest",
    })
    if err ~= nil then
        error("Failed to request: " .. err)
    end
    if resp.status_code ~= 200 then
        error("Failed to get latest version: " .. err .. "\nstatus_code => " .. resp.status_code)
    end
    local latest = json.decode(resp.body)
    local version = latest.tag_name:sub(2)

    return version
end

-- releases/download/v${version}/mani_${version}_${platform}_${arch}.tar.gz"

function generateURL(version, osType, archType)
    local githubURL = os.getenv("GITHUB_URL") or "https://github.com/"
    local baseURL = githubURL:gsub("/$", "") .. "/alajmo/mani/releases/download/v%s/mani_%s_%s_%s%s"

    local ending = ".tar.gz"

    if osType == "windows" then
        ending = ".zip"
    end
    local file = baseURL:format(version, version, osType, archType, ending)

    return file
end
