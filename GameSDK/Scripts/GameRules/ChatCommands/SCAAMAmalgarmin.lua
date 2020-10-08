-- SCAAM Amalgarmin Mod v1.2.0
-- Created by Cuartas

-- The JSON object to process JSON data
SCAAMGPSJSON = nil;

-- Validating if Miscreated:RevivePlayer is set
if not (Miscreated.RevivePlayer) then
    Miscreated.RevivePlayer = function (self, playerId)
        Log('SCAAMAmalgarmin >> Setting a generic Miscreated:RevivePlayer to make it exist');
    end
end

-- SCAAMGPSPreInitModules
-- Manage UI reload stuff
function SCAAMGPSPreInitModules()
    if (not CryAction.IsServer()) then
        Log('SCAAMAmalgarmin >> Called client UI init from not IsServer');
        ReloadModUIOnlyOnce();
    end
end

-- SCAAMGPSInitModules
-- Manage storage stuff (Based on Theros' mFramework)
function SCAAMGPSInitModules()
    SCAAMGPSJSON = require('JSON');
end

--------------------------------------------------------------------------
---------------------------- CUSTOM UI SCRIPTS ---------------------------
--------------------------------------------------------------------------

SCAAMGPSUIFunctions = {};

-- SCAAMGPSUIFunctions:UpdatePlayerPosAndRotationGame
-- Updates the player indicator position and rotation on the map game
function SCAAMGPSUIFunctions:UpdatePlayerPosAndRotationGame(playerData)
    if (not SCAAMGPSJSON) then
        SCAAMGPSJSON = require('JSON');
    end

    UIAction.CallFunction('mod_SCAAMAmalgarminUI', 1, 'UpdatePlayerPosAndRotation', SCAAMGPSJSON.stringify(playerData));
end

-- SCAAMGPSUIFunctions:RegisterListeners
-- Opens the menu UI and registers the actions
function SCAAMGPSUIFunctions:RegisterListeners()
    UIAction.RegisterElementListener(self, 'mod_SCAAMAmalgarminUI', 1, 'onGetMapInfo', 'GetMapInfo');
end

-- SCAAMGPSUIFunctions:GetMapInfo
-- Retrieves the map data and passes it to the UI
function SCAAMGPSUIFunctions:GetMapInfo()
    local mapName = System.GetCVar('sv_map');
    local mapScale = 0;

    if (System.IsValidMapPos({x = 8692, y = 8692, z = 100}) == true) then
        mapScale = 8192;
    elseif (System.IsValidMapPos({x = 4596, y = 4596, z = 100}) == true) then
        mapScale = 4096;
    elseif (System.IsValidMapPos({x = 2548, y = 2548, z = 100}) == true) then
        mapScale = 2048;
    elseif (System.IsValidMapPos({x = 1524, y = 1524, z = 100}) == true) then
        mapScale = 1024;
    elseif (System.IsValidMapPos({x = 1012, y = 1012, z = 100}) == true) then
        mapScale = 512;
    elseif (System.IsValidMapPos({x = 756, y = 756, z = 100}) == true) then
        mapScale = 256;
    elseif (System.IsValidMapPos({x = 628, y = 628, z = 100}) == true) then
        mapScale = 128;
    end

    UIAction.CallFunction('mod_SCAAMAmalgarminUI', 1, 'SetMapInfo', mapName, tostring(mapScale));
end

-- SCAAMGPSPlayerGeneralUpdate
-- Updates the player position in the gps
function SCAAMGPSPlayerGeneralUpdate(dummyVar)
    local player = System.GetEntity(g_localActorId);
    local timer = 1000;
    local gps = player.inventory:GetCurrentItem();

    if (gps) then
        if (gps.weapon and gps.class == 'SCAAMAmalgarmin') then
            if (player.SCAAMGPSObtainedMapData == false) then
                SCAAMGPSUIFunctions:RegisterListeners();
                player.SCAAMGPSObtainedMapData = true;
            end

            player.SCAAMGPSInHand = true;
            local playerAngles = player:GetAngles();

            local playerData = {
                Position = player:GetWorldPos(),
                Rotation = playerAngles.z * 180/g_Pi
            };

            timer = 10;

            SCAAMGPSUIFunctions:UpdatePlayerPosAndRotationGame(playerData);
        else
            if (player.SCAAMGPSInHand == true) then
                UIAction.ReloadElement('mod_SCAAMAmalgarminUI', 1);
                player.SCAAMGPSInHand = false;
            end
        end
    else
        if (player.SCAAMGPSInHand == true) then
            UIAction.ReloadElement('mod_SCAAMAmalgarminUI', 1);
            player.SCAAMGPSInHand = false;
        end
    end
    
    SCAAMGPSStartPlayerGeneralUpdate(timer);
end

-- SCAAMGPSStartPlayerGeneralUpdate
-- Starts the timer to update the player's position for the map in the GPS
function SCAAMGPSStartPlayerGeneralUpdate(timer)
    Script.SetTimerForFunction(timer, 'SCAAMGPSPlayerGeneralUpdate', {});
end

-- SCAAMGPSChangeMode
-- Changes the GPS mode from zoomed to normal or viceversa
function SCAAMGPSChangeMode(mode)
    if (ActionMapManager.IsFilterEnabled('only_ui') == false and ActionMapManager.IsFilterEnabled('inventory') == false) then
        local player = System.GetEntity(g_localActorId);

        if (player.SCAAMGPSInHand == true) then
            UIAction.CallFunction('mod_SCAAMAmalgarminUI', 1, 'ToggleMap');
        end
    end
end

-- SCAAMGPSChangeFrame
-- Changes frame in the UI
function SCAAMGPSChangeFrame(mode)
    if (ActionMapManager.IsFilterEnabled('only_ui') == false and ActionMapManager.IsFilterEnabled('inventory') == false) then
        local player = System.GetEntity(g_localActorId);

        if (player.SCAAMGPSInHand == true) then
            UIAction.CallFunction('mod_SCAAMAmalgarminUI', 1, 'SwitchToFrame');
        end
    end
end

-- SCAAMGPSRestartGPS
-- Restarts the GPS to see if it loads
function SCAAMGPSRestartGPS(reload)
    UIAction.ReloadElement('mod_SCAAMAmalgarminUI', 1);
end

--------------------------------------------------------------------------
-------------------------- CUSTOM UI SCRIPTS END -------------------------
--------------------------------------------------------------------------

-- Calling the Miscreated Revive player function to initialize the Amalgarmin script
RegisterCallbackReturnAware(
    Miscreated,
    'RevivePlayer',
    function (self, ret, playerId)
        local player = System.GetEntity(playerId);

        if (player and player.player) then

            -- Inits the custom UI support for players
            mSendEvent(
                player.id,
                {
                    Type = 'SCAAMGPSInit',
                    Data = {dummyData = ''}
                },
                false,
                false
            );
        end

        return ret;
    end,
    nil
);