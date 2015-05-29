local flirt_file = './data/flirt.lua'
local flirt_table

function read_flirt_file()
    local f = io.open(flirt_file, "r+")

    if f == nil then
        print ('Created a new quotes file on '..flirt_file)
        serialize_to_file({}, flirt_file)
    else
        print ('Quotes loaded: '..flirt_file)
        f:close()
    end
    return loadfile (flirt_file)()
end

function save_flirt(msg)
 local to_id = tostring("flirt")

 local flirt = flirt_table[to_id]
 flirt[#flirt+1] = msg.text:sub(11)

 serialize_to_file(flirt_table, flirt_file)

 return "Frase aggiunta"
end

function error_flirt(msg)
 return "Uso: !addflirt [frase]"
end


function get_flirt(msg)
    local to_id = tostring("flirt")
    local flirt_phrases

    flirt_table = read_flirt_file()
    flirt_phrases = flirt_table[to_id]

    return flirt_phrases[math.random(1,#flirt_phrases)]
end

function run(msg, matches)
    if string.match(msg.text, "!flirt$") then
        return get_flirt(msg)
    elseif string.match(msg.text, "^!addflirt (.+)$") then
         flirt_table = read_flirt_file()
         return save_flirt(msg)
    elseif string.match(msg.text, "^!addflirt$") then
                return error_flirt(msg)

    end
end

return {
    description = "Save quote",
    description = "Flirt plugin, with love, for Tars",
    usage = {
        "!flirt = Invia una frase d'amore a Tars",
        "!addflirt = Aggiungi una frase d'amore. \n Uso: !addflirt frase"
    },
    patterns = {
        "^!flirt$",
        "^!addflirt (.+)$",
                "^!addflirt$"
    },
    run = run
}

