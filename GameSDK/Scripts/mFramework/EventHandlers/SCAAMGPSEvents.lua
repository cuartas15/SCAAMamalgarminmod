Log('SCAAMAmalgarmin >> Registering events');
g_mEventHandlers['SCAAMGPSInit'] = function(playerId, event, source_id, target_id)
    local player = System.GetEntity(g_localActorId);

    -- Assigns the battle royale custom keys
    System.AddCCommand('SCAAMGPSMode', 'SCAAMGPSChangeMode(%1)', '');
    System.AddCCommand('SCAAMGPSFrame', 'SCAAMGPSChangeFrame(%1)', '');
    System.AddKeyBind('end', 'SCAAMGPSMode mode');
    System.AddKeyBind('mouse1', 'SCAAMGPSFrame mode');

    -- Sets the custom client variables
    player.SCAAMGPSObtainedMapData = false;
    player.SCAAMGPSInHand = false;

    SCAAMGPSStartPlayerGeneralUpdate(5000);
end