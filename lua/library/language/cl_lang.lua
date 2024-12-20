eui.lang = eui.lang or {}
eui.lang.phrases = eui.lang.phrases or {}

local lang = eui.lang

function lang:AddPhrase(langId, phraseId, text)
    self.phrases[langId] = self.phrases[langId] or {}
    self.phrases[langId][phraseId] = text
end

function lang:AddPhrases(langId, tableText)
    for phrasesId, text in pairs(tableText) do
        self:AddPhrase(langId, phrasesId, text)
    end
end

do
    local gsub = string.gsub

    function lang:Get(phraseId, args, translate)
        local base = self.phrases.russian or {}
        local pLocal = self.phrases[self.id] or {}
        local text

        if pLocal[phraseId] then
            text = pLocal[phraseId]
            goto process
        end

        if base[phraseId] then
            text = base[phraseId]
            goto process    
        end

        ::process::
        
        if text and args then
            for k, v in pairs(args) do
                v = tostring(v)

                local arg = translate and lang:Get(value) or value

                text = gsub(text, '{' .. key .. '}', arg, 1)
            end
        end

        return text or phraseId
    end
end

do
    local langs = {
        ['ru'] = 'russian',
        ['en'] = 'english',
        ['de'] = 'german',
        ['fr'] = 'french',
        ['uk'] = 'ukraine' // sheet
    }

    function lang:GetGameLanguage()
        local curLanguage = GetConVar('gmod_language'):GetString()
        
        return langs[curLanguage]
    end

    function lang:SetNormalLanguage()
        local lang = self:GetGameLanguage()

        if not lang then 
            self.id = 'ru'    
            return 
        end
        
        self.id = lang
    end

    lang:SetNormalLanguage()

    cvars.AddChangeCallback('gmod_language', function()
        lang:SetNormalLanguage()
    end, 'eui.languages')
end