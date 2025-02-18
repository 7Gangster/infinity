formatNumber = function(number)   
    local formatted = number   
    while true do       
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')     
        if ( k==0 ) then       
            break   
        end   
    end   
    return formatted 
end 

notifyS = function(player, message, type)
    exports["crp_notify"]:addBox(player, message, type)
end

notifyC = function(message, type)
    exports["crp_notify"]:addBox(message, type)
end

function removeHex(message)
	if (type(message) == "string") then
		while (message ~= message:gsub("#%x%x%x%x%x%x", "")) do
			message = message:gsub("#%x%x%x%x%x%x", "")
		end
	end
	return message or false
end

function puxarNome(player)
    return removeHex(getPlayerName(player))
end

function puxarID(player)
    return (getElementData(player, "ID") or 0)
end

function puxarConta(player)
    return getAccountName(getPlayerAccount(player))
end

function dadosMarker()
    return "cylinder", 1.1, 0, 0, 0, 90
end

local tableNumberAccents = { ["{"] = true, ["}"] = true, ["["] = true, ["]"] = true, ["!"] = true, ["@"] = true, ["#"] = true, ["$"] = true, ["%"] = true, ["¨"] = true, ["&"] = true, ["*"] = true, ["("] = true, [")"] = true, ["-"] = true, ["="] = true, ["_"] = true, ["+"] = true, ["/"] = true, ["\\"] = true, ["|"] = true, ["."] = true, [","] = true, ["<"] = true, [">"] = true, [":"] = true, [";"] = true, ["~"] = true, ["^"] = true, ["`"] = true, ["?"] = true, ['"'] = true,  ["'"] = true,  [' '] = true, ["Ç"] = true, ["ü"] = true, ["é"] = true, ["â"] = true, ["ä"] = true, ["à"] = true, ["å"] = true, ["ç"] = true, ["ê"] = true, ["ë"] = true, ["è"] = true, ["ï"] = true, ["î"] = true, ["ì"] = true, ["Ä"] = true, ["Å"] = true, ["É"] = true, ["æ"] = true, ["Æ"] = true, ["ô"] = true, ["ö"] = true, ["ò"] = true, ["û"] = true, ["ù"] = true, ["ÿ"] = true, ["Ö"] = true, ["Ü"] = true, ["¢"] = true, ["£"] = true, ["¥"] = true, ["₧"] = true, ["ƒ"] = true, ["á"] = true, ["í"] = true, ["ó"] = true, ["ú"] = true, ["ñ"] = true, ["Ñ"] = true, ["ª"] = true, ["º"] = true, ["¿"] = true, ["⌐"] = true, ["¬"] = true, ["½"] = true, ["¼"] = true, ["¡"] = true, ["«"] = true, ["»"] = true, ["░"] = true, ["▒"] = true, ["▓"] = true, ["│"] = true, ["┤"] = true, ["╡"] = true, ["╢"] = true, ["╖"] = true, ["╕"] = true, ["╣"] = true, ["║"] = true, ["╗"] = true, ["╝"] = true, ["╜"] = true, ["╛"] = true, ["┐"] = true, ["└"] = true, ["┴"] = true, ["┬"] = true, ["├"] = true, ["─"] = true, ["┼"] = true, ["╞"] = true, ["╟"] = true, ["╚"] = true, ["╔"] = true, ["╩"] = true, ["╦"] = true, ["╠"] = true, ["═"] = true, ["╬"] = true, ["╧"] = true, ["╨"] = true, ["╤"] = true, ["╥"] = true, ["╙"] = true, ["╘"] = true, ["╒"] = true, ["╓"] = true, ["╫"] = true, ["╪"] = true, ["┘"] = true, ["┌"] = true, ["█"] = true, ["▄"] = true, ["▌"] = true, ["▐"] = true, ["▀"] = true, ["α"] = true, ["ß"] = true, ["Γ"] = true, ["π"] = true, ["Σ"] = true, ["σ"] = true, ["µ"] = true, ["τ"] = true, ["Φ"] = true, ["Θ"] = true, ["Ω"] = true, ["δ"] = true, ["∞"] = true, ["φ"] = true, ["ε"] = true, ["∩"] = true, ["≡"] = true, ["±"] = true, ["≥"] = true, ["≤"] = true, ["⌠"] = true, ["⌡"] = true, ["÷"] = true, ["≈"] = true, ["°"] = true, ["∙"] = true, ["·"] = true, ["√"] = true, ["ⁿ"] = true, ["²"] = true, ["■"] = true, ["´"] = true, ["à"] = true, ["á"] = true, ["â"] = true, ["ã"] = true, ["ä"] = true, ["ç"] = true, ["è"] = true, ["é"] = true, ["ê"] = true, ["ë"] = true, ["ì"] = true, ["í"] = true, ["î"] = true, ["ï"] = true, ["ñ"] = true, ["ò"] = true, ["ó"] = true, ["ô"] = true, ["õ"] = true, ["ö"] = true, ["ù"] = true, ["ú"] = true, ["û"] = true, ["ü"] = true, ["ý"] = true, ["ÿ"] = true, ["À"] = true, ["Á"] = true, ["Â"] = true, ["Ã"] = true, ["Ä"] = true, ["Ç"] = true, ["È"] = true, ["É"] = true, ["Ê"] = true, ["Ë"] = true, ["Ì"] = true, ["Í"] = true, ["Î"] = true, ["Ï"] = true, ["Ñ"] = true, ["Ò"] = true, ["Ó"] = true, ["Ô"] = true, ["Õ"] = true, ["Ö"] = true, ["Ù"] = true, ["Ú"] = true, ["Û"] = true, ["Ü"] = true, ["Ý"] = true,}
function verifyNumber(str)
    local noAccentsStr = false
    for strChar in string.gfind(str, "([%z\1-\127\194-\244][\128-\191]*)") do
        if (tableNumberAccents[strChar]) then
            noAccentsStr = tableNumberAccents[strChar]
        end
    end
    return noAccentsStr
end

function convertTimestamp(timeInString)
    if timeInString then
        local splitado = split(timeInString, ":")
        return (tonumber(splitado[2]*1000)+tonumber(splitado[1]*60000))
    end
    return 0
end

function convertTime(ms) 
    local min = math.floor ( ms/60000 ) 
    local sec = math.floor( (ms/1000)%60 ) 
    if min < 10 then 
        min = "0"..min
    end 
    if sec < 10 then 
        sec = "0"..sec
    end 
    return min, sec 
end