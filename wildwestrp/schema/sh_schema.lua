--[[-------------------------------------------------------------------------
Purpose: This is where you set up everything for your schema. Title, description,
author, currency, custom flags.
---------------------------------------------------------------------------]]
SCHEMA.name = "Wild West RP"
SCHEMA.author = "Adaster"
SCHEMA.desc = "Hee-ya cowboy!"

nut.currency.set("", "dollar", "dollars") --Symbol, singular tense of currency, plural tense of currency

function SCHEMA:PlayerDeath( client )
    local items = client:getChar():getInv():getItems()
    for k, item in pairs( items ) do
        if item.isWeapon then
            if item:getData( "equip" ) and (client:Team() != FACTION_SHERIFF) then

                nut.item.spawn( item.uniqueID, client:GetShootPos(), function()
                    item:remove()
                end, Angle(), item.data )
            end
        end
    end
end

function SCHEMA:PlayerConnect(client, ip)
	for k,v in pairs(player.GetAll()) do
		v:ChatPrint(client.." has connected to the server.")
	end
end

function SCHEMA:PlayerDisconnected(client)
	PrintMessage(HUD_PRINTTALK, client:Name().." has disconnected from the server.")
end

nut.chat.register("event", {
	onCanSay =  function(speaker, text)
		return speaker:IsSuperAdmin()
	end,
	onCanHear = 10000000,
	onChatAdd = function(speaker, text)
		chat.AddText(Color(255, 0, 250), " [Event] ", color_white, text)
	end,
	prefix = {"/ev"}
})

nut.chat.register("advert", {
	onCanSay =  function(speaker, text)	
		if speaker:getChar():hasMoney(10) then
				speaker:getChar():takeMoney(10)
				speaker:notify("10 Tokens have been deducted from your wallet for advertising.")
			return true
		else 
			speaker:notify("You lack sufficient funds to make an advertisement.")
			return false 
		end
		end,
	onChatAdd = function(speaker, text)
		chat.AddText( Color(255, 238, 0), " [Advertisement] ", color_white, text)
	end,
	prefix = {"/advert"},
	noSpaceAfter = true,
	--filter = "advertisements"
})

nut.chat.register("admin", {
	onCanSay =  function(speaker, text)
		return true
	end,
	onCanHear =  function(speaker, listener)
		if(listener:IsAdmin() or listener == speaker) then
			return true
		else
			return false
		end
	end,
	onChatAdd = function(speaker, text)
		chat.AddText(Color(200, 50, 50), "[HELP] ".. speaker:GetName(), color_white, ": " ..text)
	end,
	prefix = {"/admin", "/help", "/report"}
})

-- special 1
nut.anim.setModelClass("models/fof/bandito/bandito.mdl", "citizen_male")
nut.anim.setModelClass("models/fof/desperados/desperados.mdl", "citizen_male")
nut.anim.setModelClass("models/fof/vigilante/vigilante.mdl", "citizen_male")
nut.anim.setModelClass("models/fof/ranger/ranger.mdl", "citizen_male")

-- special 2
nut.anim.setModelClass("models/newarthurmorgan/newarthurmorganpm.mdl", "citizen_male")
nut.anim.setModelClass("models/player/john_marston.mdl", "citizen_male")
nut.anim.setModelClass("models/sadieadler/sadieadlerpm.mdl", "citizen_female")
nut.anim.setModelClass("models/player/chocolatfurry5/chocolatfurry5.mdl", "citizen_male")
nut.anim.setModelClass("models/player/indiana_jones.mdl", "citizen_male")

-- native
nut.anim.setModelClass("models/player/azw/zulu/zulu.mdl", "citizen_male")
nut.anim.setModelClass("models/player/bobert/mkxerronblack.mdl", "citizen_male")

-- townfolk
nut.anim.setModelClass("models/humans/groupap/mapert_02.mdl", "citizen_male")
nut.anim.setModelClass("mmodels/humans/groupap/mapert_04.mdl", "citizen_male")
nut.anim.setModelClass("models/humans/groupap/mapert_06.mdl", "citizen_male")
nut.anim.setModelClass("models/humans/groupap/mapert_08.mdl", "citizen_male")

nut.flag.add("y", "Gun dealer access.")
nut.flag.add("Y", "Premium user access.")
nut.flag.add("d", "Clothes permit access.")

nut.util.include("sh_commands.lua")
nut.util.includeDir("hooks")
