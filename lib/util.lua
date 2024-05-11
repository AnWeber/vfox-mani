function isGithubToken(token)
    local character = "[a-zA-Z0-9]"
    -- Personal Access Token (Classic)
    if token:match("^ghp_" .. character:rep(36) .. "$") then
        return true
        -- Personal Access Token (Fine-Grained)
    elseif token:match("^github_pat_" .. character:rep(22) .. "_" .. character:rep(59) .. "$") then
        return true
    end

    return false
end

return {
    -- Authenticate to get higher rate limit   ↓ Add your GitHub Token here
    githubToken = os.getenv("GITHUB_TOKEN") or "",
}
