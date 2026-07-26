--
-- constants
--
minekart={}
minekart.gravity = automobiles_lib.gravity

minekart.S = nil

if(minetest.get_translator ~= nil) then
    minekart.S = minetest.get_translator(core.get_current_modname())

else
    minekart.S = function ( s ) return s end

end

local S = minekart.S

dofile(minetest.get_modpath("automobiles_lib") .. DIR_DELIM .. "custom_physics.lua")
dofile(minetest.get_modpath("automobiles_lib") .. DIR_DELIM .. "fuel_management.lua")
dofile(minetest.get_modpath("automobiles_lib") .. DIR_DELIM .. "ground_detection.lua")
dofile(minetest.get_modpath("automobiles_lib") .. DIR_DELIM .. "control.lua")
dofile(minetest.get_modpath("kartcar") .. DIR_DELIM .. "forms.lua")
dofile(minetest.get_modpath("kartcar") .. DIR_DELIM .. "entities.lua")
dofile(minetest.get_modpath("kartcar") .. DIR_DELIM .. "crafts.lua")


