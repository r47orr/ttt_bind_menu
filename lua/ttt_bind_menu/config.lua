TTTBindMenu.config = TTTBindMenu.config or {}

// this functionality is also not yet complete. A lot of stuff is to be made.

// set up some of the important values we will need along the way

TTTBindMenu.config.FilePathOrigin = "DATA"
TTTBindMenu.config.FilePath = "ttt_bind_menu/"
TTTBindMenu.config.FileName = "settings.json"

local FilePathOrigin = TTTBindMenu.config.FilePathOrigin
local FilePath = TTTBindMenu.config.FilePath
local FileName = TTTBindMenu.config.FileName

// -----------------------------------------------------------------
// just a shortcut for the file.Exists() function.
// it is only for practical and clean code purposes
// -----------------------------------------------------------------
function TTTBindMenu.config:ConfigExists()

    return file.Exists(FilePath, FilePathOrigin)
end

// -----------------------------------------------------------------
// PURPOSE: will write the addon's settings to the config file, overwriting all current data, if it exists
// -----------------------------------------------------------------
function TTTBindMenu.config:SaveSettings(data)

    -- should be noted that this function will have to be rewritten once we are starting to mess with inputs
    -- for new settings and preferences
    if !self:ConfigExists() then 
        file.CreateDir(FilePath)
    end

    -- we can't just completely overwrite the whole settings' file with the data received from this function
    file.Write(FilePath .. FileName, util.TableToJSON(data))
end

// -----------------------------------------------------------------
// Pretty straight forward: it will just rename your current config file's name
// so that the FetchConfig() function doesn't find it, and will return the default ones.
// Maybe not the best or most efficient way to do that, but you can always send a PR and suggest something better :)
// it does work, it is not that ugly, neither problematic, so I don't see a big problem for this solution (FOR NOW)
// -----------------------------------------------------------------
function TTTBindMenu.config:ResetDefaults()
    
    if !self:ConfigExists() then
        return false 
    end

    file.Rename(FilePath .. FileName, FilePath .. "old_" .. FileName)

    return true
end

// -----------------------------------------------------------------
// Also straight forward: resetting to defaults doesn't really delete the old configs,
// it just renames them, so it should be safe and pretty easy to get them back.
// -----------------------------------------------------------------
function TTTBindMenu.config:UndoResetDefaults(enforce)
    
    if self:ConfigExists() and !enforce then
        return false 
    end

    if !file.Exists(FilePath .. "old_" .. FileName, FileGameDir) then return false end

    file.Rename(FilePath .. "old_" .. FileName, FilePath .. FileName)

    return true
end

// -----------------------------------------------------------------
// PURPOSE: it will search for the config file in the set up directory 
// and try to return its content or will return default settings
// HOW: there's no further explaining it, it is pretty straightforward
// -----------------------------------------------------------------
function TTTBindMenu.config:FetchConfig()

    if !self:ConfigExists() then return self.DefaultSettings end

    settings = file.Read(FilePath .. FileName, FileGameDir)

    settings = util.JSONToTable(settings)

    return settings
end

function TTTBindMenu.config:FetchSingle(field)

    return self.Table[field] or self:FetchConfig()[field] or self:FetchConfig()
end

TTTBindMenu.config.DefaultSettings = {
    // add ULX/CAMI ranks that should have the ability to create binds
    choice_allowed_ranks = {
        superadmin = true,
        user = false,
    },
    // by default, only superadmins should have access to the addon's global settings and management
    config_allowed_ranks = {
        superadmin = true,
    }
}
TTTBindMenu.config:SaveSettings(TTTBindMenu.config.DefaultSettings)

TTTBindMenu.config.Table = TTTBindMenu.config:FetchConfig()

if SERVER then
    -- also for debugging...
    print('[' .. TTTBindMenu.Prefix .. '] Current configuration table:\n')
    PrintTable(TTTBindMenu.config.Table)
    print('========================================================================')
end