local SCAAMGPSCustomPlayer = {
    Methods = {
        Client = {
            -- SCAAMGPSInit
            -- Inits the custom UI support for the players
            SCAAMGPSInit = function(self)

                -- Assigns the battle royale custom keys
                System.AddCCommand('SCAAMGPSMode', 'SCAAMGPSChangeMode(%1)', '');
                System.AddCCommand('SCAAMGPSFrame', 'SCAAMGPSChangeFrame(%1)', '');
                System.AddKeyBind('end', 'SCAAMGPSMode mode');
                System.AddKeyBind('mouse1', 'SCAAMGPSFrame mode');

                -- Sets the custom client variables
                self.SCAAMGPSObtainedMapData = false;
                self.SCAAMGPSInHand = false;

                SCAAMGPSStartPlayerGeneralUpdate(5000);
            end
        },
        Server = {
        }
    },
    Expose = {
        ClientMethods = {
            SCAAMGPSInit = { RELIABLE_ORDERED, POST_ATTACH }
        },
        ServerMethods = {},
        ServerProperties = {}
    }
}

Log(">> Loading mFramework SCAAMGPSCustomPlayer");
local _status, _result = mReExpose('Player', SCAAMGPSCustomPlayer.Methods, SCAAMGPSCustomPlayer.Expose);
Log(">> Result: " .. tostring(_status or "Failed") .. " " .. tostring(_result or "No Message"));