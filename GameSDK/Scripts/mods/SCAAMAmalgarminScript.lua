-- Calling OnInitPreLoaded function to reload the UI on the client
RegisterCallback(_G,
    'OnInitPreLoaded',
    nil,
    function ()
        Log("SCAAMAmalgarmin >> PreLoading GPS Config");
        SCAAMGPSPreInitModules();
    end
)

-- Calling OnInitAllLoaded function to register the GPS config on level load
RegisterCallback(_G,
    'OnInitAllLoaded',
    nil,
    function ()
        Log("SCAAMAmalgarmin >> Loading GPS Config");
        SCAAMGPSInitModules();
    end
);