local util = require("util")
--- When user invoke `use` command, this function will be called to get the
--- valid version information.
--- @param ctx table Context information
function PLUGIN:PreUse(ctx)
  --- return the version information
  return {
    version = ctx.version,
  }
end
