--- Each SDK may have different environment variable configurations.
--- This allows plugins to define custom environment variables (including PATH settings)
--- Note: Be sure to distinguish between environment variable settings for different platforms!
--- @param ctx table Context information
function PLUGIN:EnvKeys(ctx)
    print(ctx.path)
    return {
        {
            key = "PATH",
            value = ctx.path
        },
    }
end
