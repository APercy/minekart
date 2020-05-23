--
-- fuel
--

function minekart_load_fuel(self, player_name)
    if self._energy < 0.90 then 
        local player = minetest.get_player_by_name(player_name)
        local inv = player:get_inventory()
        local inventory_fuel = "biofuel:biofuel"

        if inv:contains_item("main", inventory_fuel) then
            local stack = ItemStack(inventory_fuel .. " 1")
            local taken = inv:remove_item("main", stack)

	        self._energy = self._energy + 1
            if self._energy > 1 then self._energy = 1 end
            minekart.last_fuel_display = 0
            minetest.chat_send_player(player_name, "Full tank!")
	    end
    else
        minetest.chat_send_player(player_name, "No refuel for you! You have more than 90% of fuel in the tank.")
    end
end

