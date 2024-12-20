eui = eui or {}

function eui:Print(msg, clr)
    clr = clr or Color(255, 255, 255)

	MsgC(Color(48, 156, 255), '[ENC UI LIBRARY] ', clr, msg .. '\n')
end

do
    local blockedFile = {}
    local deblockedFile = {}

    function eui:IncludeDir(fileDir)
        local files, dirs = file.Find(fileDir .. '*', 'LUA')

        for _, fileName in ipairs(files) do
            if (string.match(fileName, '.lua') and not blockedFile[fileName] and not deblockedFile[fileDir .. fileName]) then
                local filePrMWix = string.sub(fileName, 1, 2)

                if SERVER and filePrMWix ~= 'sv' then
                    eui:Print('Adding File: ' .. fileDir .. fileName, Color(0, 255, 0))
                    deblockedFile[fileDir .. fileName] = true
                    AddCSLuaFile(fileDir .. fileName)
                end

                if CLIENT and filePrMWix ~= 'sv' then
                    include(fileDir .. fileName)
                    deblockedFile[fileDir .. fileName] = true
                    eui:Print('Including File: ' .. fileDir .. fileName, Color(0, 255, 0))
                end
                
                if SERVER and filePrMWix ~= 'cl' then
                    include(fileDir .. fileName)
                    deblockedFile[fileDir .. fileName] = true
                    eui:Print('Including File: ' .. fileDir .. fileName, Color(0, 255, 0))
                end
            end
        end

        for _, dir in ipairs(dirs) do
            eui:IncludeDir(fileDir .. dir .. '/')
        end
    end
end

hook.Add('OnGamemodeLoaded', 'eui:LoadedMain', function()
    eui:IncludeDir('library/')
    eui:Print('Coded by Encoded', Color(0, 255, 0))
end)

if SERVER then
    resource.AddFile('materials/lib/circle.png')
end