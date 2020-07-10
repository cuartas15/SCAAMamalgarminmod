-- Calling OnInitAllLoaded function to register the Battle royale config on level load
RegisterCallback(_G,
    'OnInitAllLoaded',
    nil,
    function ()
        Log("SCAAMAmalgarmin >> Loading GPS Config");
        SCAAMGPSInitModules();
    end
);