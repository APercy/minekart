local S = minekart.S

--
-- items
--

-- kart
minetest.register_tool("kartcar:kart", {
    description = "Kart",
    inventory_image = "kart_inv.png",
    liquids_pointable = false,
    stack_max = 1,

	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end

        local stack_meta = itemstack:get_meta()
        local staticdata = stack_meta:get_string("staticdata")

        local pointed_pos = pointed_thing.above
		--pointed_pos.y=pointed_pos.y+0.2
		local car = minetest.add_entity(pointed_pos, "kartcar:kart", staticdata)
		if car and placer then
            local ent = car:get_luaentity()
            local owner = placer:get_player_name()
            if ent then
                ent.owner = owner
                ent.hp = 50 --reset hp
                --minetest.chat_send_all("owner: " .. ent.owner)
		        car:set_yaw(placer:get_look_horizontal())
		        itemstack:take_item()
                ent.object:set_acceleration({x=0,y=-automobiles_lib.gravity,z=0})
                automobiles_lib.setText(ent, S("Kart"))
                automobiles_lib.create_inventory(ent, ent._trunk_slots, owner)
            end
		end

		return itemstack
	end,
})

--
-- crafting
--
if minetest.get_modpath("default") then
	minetest.register_craft({
		output = "kartcar:kart",
		recipe = {
			{"default:obsidian_block", "default:steel_ingot", "default:obsidian_block"},
			{"default:steel_ingot",    "default:mese_block",  "default:steel_ingot"},
			{"default:obsidian_block", "default:steel_ingot", "default:obsidian_block"},
		}
	})
end


local old_entities = {"kartcar:steering_wheel_axis","kartcar:steering_wheel","kartcar:dir_bar", "kartcar:left_wheel", "kartcar:right_wheel"}
for _,entity_name in ipairs(old_entities) do
    minetest.register_entity(":"..entity_name, {
        on_activate = function(self, staticdata)
            self.object:remove()
        end,
    })
end
