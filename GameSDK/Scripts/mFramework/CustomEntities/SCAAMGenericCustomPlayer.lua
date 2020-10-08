local SCAAMGenericCustomPlayer = {
    Methods = {
        Client = {
            -- SCAAMGenericFunction
            -- Adds a Generic RMI function to circumvent the naming convention issue
            -- With the event system
            SCAAMGenericFunction = function(self)
                -- Do nothing
            end
        },
        Server = {}
    },
    Expose = {
        ClientMethods = {
            SCAAMGenericFunction = { RELIABLE_UNORDERED, PRE_ATTACH }
        },
        ServerMethods = {},
        ServerProperties = {}
    }
}

Log(">> Loading mFramework SCAAMGenericCustomPlayer");
local _status, _result = mReExpose('Player', SCAAMGenericCustomPlayer.Methods, SCAAMGenericCustomPlayer.Expose);
Log(">> Result: " .. tostring(_status or "Failed") .. " " .. tostring(_result or "No Message"));