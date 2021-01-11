if (SERVER) then
	util.AddNetworkString("OpenInvMenu")

	function ItemCanEnterForEveryone(inventory, action, context)
		if (action == "transfer") then return true end
	end

	function CanReplicateItemsForEveryone(inventory, action, context)
		if (action == "repl") then return true end
	end
else
	net.Receive("OpenInvMenu", function()
		local target = net.ReadEntity()
		local index = net.ReadType()

		local targetInv = nut.inventory.instances[index]
		local myInv = LocalPlayer():getChar():getInv()

		local inventoryDerma = targetInv:show()
		inventoryDerma:SetTitle(target:getChar():getName().."'s Inventory")
		inventoryDerma:MakePopup()
		inventoryDerma:ShowCloseButton(true)

		local myInventoryDerma = myInv:show()
		myInventoryDerma:MakePopup()
		myInventoryDerma:ShowCloseButton(true)
		myInventoryDerma:SetParent(inventoryDerma)
		myInventoryDerma:MoveLeftOf(inventoryDerma, 4)
	end)
end
	--[[-------------------------------------------------------------------------
	Purpose: Check other players inventory's
	---------------------------------------------------------------------------]]
	nut.command.add("checkinventory", {
		adminOnly = true,
		syntax = "<string target>",
		onRun = function(client, arguments)
			local target = nut.command.findPlayer(client, arguments[1])
			if (IsValid(target) and target:getChar() and target != client) then
				local inventory = target:getChar():getInv()
				inventory:addAccessRule(ItemCanEnterForEveryone, 1)
				inventory:addAccessRule(CanReplicateItemsForEveryone, 1)
				inventory:sync(client)
				net.Start("OpenInvMenu")
				net.WriteEntity(target)
				net.WriteType(inventory:getID())
				net.Send(client)
			elseif (target == client) then
				client:notifyLocalized("This isn't meant for checking your own inventory.")
			end
		end
	})

	--[[-------------------------------------------------------------------------
	Purpose: Check other players money amount.
	---------------------------------------------------------------------------]]
	nut.command.add("chargetmoney", {
		adminOnly = true,
		syntax = "<string target>",
		onRun = function(client, arguments)
			local target = nut.command.findPlayer(client, arguments[1])
			local character = target:getChar()
			client:notifyLocalized(character:getName().." has "..character:getMoney()..".")
		end
	})

	
nut.command.add("cleanitems", {
	adminOnly = true,
	onRun = function(client, arguments)
		local count = 0
	
		for k, v in pairs(ents.FindByClass("nut_item")) do
			count = count + 1
			v:Remove()
		end
		
		client:notify(count.. " items have been cleaned up from the map.")
	end
})

nut.command.add("cleannpcs", {
	adminOnly = true,
	onRun = function(client, arguments)
		local count = 0
	
		for k, v in pairs(ents.GetAll()) do
			if IsValid(v) and (v:IsNPC() or v.chance) and !IsFriendEntityName(v:GetClass()) then
				count = count + 1
				v:Remove()
			end
		end
		
		client:notify(count.. " NPCs and Nextbots have been cleaned up from the map.")
	end
})

nut.command.add("spawnitem", {
	adminOnly = true,
	syntax = "<string item> <number amount>",
	onRun = function(client, arguments)

		if (IsValid(client) and client:getChar()) then
			local uniqueID = arguments[1]:lower()

			if (!nut.item.list[uniqueID]) then
				for k, v in SortedPairs(nut.item.list) do
					if (nut.util.stringMatches(v.name, uniqueID)) then
						uniqueID = k

						break
					end
				end
			end

            local aimPos = client:GetEyeTraceNoCursor().HitPos 

            aimPos:Add(Vector(0, 0, 10))  

			if(nut.item.list[uniqueID]) then
				local amount = tonumber(arguments[2]) or 1
				if(amount > 10) then
					amount = 10
				end
			
				for i = 1, amount or 1 do
					nut.item.spawn(uniqueID, aimPos)
				end
            else
				client:notify("Invalid Item")
			end
		end
	end
})

nut.command.add("chargetmodel", {
	adminOnly = true,
	syntax = "<string name>",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target) and target:getChar()) then
			client:notify(target:GetModel())
		else
			client:notify("Invalid Target")
		end
	end
})

-- Roll information in chat.
nut.chat.register("flip", {
	format = "%s flipped a coin and it landed on %s.",
	color = Color(155, 111, 176),
	filter = "actions",
	font = "nutChatFontItalics",
	onCanHear = nut.config.get("chatRange", 280),
	deadCanChat = true
})

nut.command.add("flip", {
	onRun = function(client, arguments)
		local roll = math.random(0,1)
	
		if(roll == 1) then
			nut.chat.send(client, "flip", "Heads")
		else
			nut.chat.send(client, "flip", "Tails")
		end
	end
})