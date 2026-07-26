-- destroy the beetle
function minekart.destroy(self, puncher)
    automobiles_lib.remove_light(self)
    if self.sound_handle then
        minetest.sound_stop(self.sound_handle)
        self.sound_handle = nil
    end

    if self.driver_name then
        -- detach the driver first (puncher must be driver)
        if puncher then
            puncher:set_detach()
            puncher:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
            if minetest.global_exists("player_api") then
                player_api.player_attached[self.driver_name] = nil
                -- player should stand again
                player_api.set_animation(puncher, "stand")
            end
        end
        self.driver_name = nil
    end

    local pos = self.object:get_pos()

    if self.lf_wheel then self.lf_wheel:remove() end
    if self.rf_wheel then self.rf_wheel:remove() end
    if self.lr_wheel then self.lr_wheel:remove() end
    if self.rr_wheel then self.rr_wheel:remove() end

    automobiles_lib.seats_destroy(self)

    automobiles_lib.destroy_inventory(self)
    self.object:remove()

    pos.y=pos.y+2

    minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},'kartcar:kart')
end
--
-- entity
--

core.register_entity('kartcar:f_wheel',{
initial_properties = {
	physical = false,
	collide_with_objects=false,
	pointable=false,
	visual = "mesh",
	mesh = "kart_f_wheel.b3d",
    backface_culling = false,
	textures = {"kart_black.png", "kart_metal.png",},
	},
	
    on_activate = function(self,std)
	    self.sdata = minetest.deserialize(std) or {}
	    if self.sdata.remove then self.object:remove() end
        self.object:set_armor_groups({immortal=1})
    end,
	    
    get_staticdata=function(self)
      self.sdata.remove=true
      return minetest.serialize(self.sdata)
    end,
	
})

core.register_entity('kartcar:r_wheel',{
initial_properties = {
	physical = false,
	collide_with_objects=false,
	pointable=false,
	visual = "mesh",
	mesh = "kart_r_wheel.b3d",
    backface_culling = false,
	textures = {"kart_black.png", "kart_metal.png",},
	},
	
    on_activate = function(self,std)
	    self.sdata = minetest.deserialize(std) or {}
	    if self.sdata.remove then self.object:remove() end
        self.object:set_armor_groups({immortal=1})
    end,
	    
    get_staticdata=function(self)
      self.sdata.remove=true
      return minetest.serialize(self.sdata)
    end,
	
})

core.register_entity('kartcar:suspension',{
initial_properties = {
	physical = true,
	collide_with_objects=true,
    collisionbox = {-0.5, 0, -0.5, 0.5, 1, 0.5},
	pointable=false,
	visual = "sprite",
    textures = {"automobiles_alpha.png",},
	},

    on_activate = function(self,std)
	    self.sdata = minetest.deserialize(std) or {}
	    if self.sdata.remove then self.object:remove() end
    end,
	    
    get_staticdata=function(self)
      self.sdata.remove=true
      return minetest.serialize(self.sdata)
    end,

    --[[on_step = function(self, dtime, moveresult)
        minetest.chat_send_all(dump(moveresult))
    end,]]--
	
})

local function on_rightclick (self, clicker)
	if not clicker or not clicker:is_player() then
		--return
	end

	local name = clicker:get_player_name()
    --[[if self.owner and self.owner ~= name and self.owner ~= "" then return end]]--
    if self.owner == "" then
        self.owner = name
    end
    
	if name == self.driver_name then
        local formspec_f = automobiles_lib.driver_formspec
        if self._formspec_function then formspec_f = self._formspec_function end
        formspec_f(name)
	else
        --is the owner, okay, lets attach
        local attach_driver_f = automobiles_lib.attach_driver
        attach_driver_f(self, clicker)
        -- sound
        local base_pitch = 1
        if self._base_pitch then base_pitch = self._base_pitch end
        self.sound_handle = minetest.sound_play({name = self._engine_sound},
                {object = self.object, gain = 1, pitch = base_pitch, max_hear_distance = 30, loop = true,})
	end
end

minekart.car_properties1 = {
	initial_properties = {
	    physical = true,
        collide_with_objects = true,
	    collisionbox = {-0.1, 0.0, -0.1, 0.1, 0.1, 0.1},
	    selectionbox = {-0.8, 0.0, -0.8, 0.8, 1, 0.8},
        stepheight = 0.5 + automobiles_lib.extra_stepheight,
	    visual = "mesh",
	    mesh = "kart_body.b3d",
        backface_culling = false,
        textures = {
            "automobiles_black.png", --bancos
            "automobiles_painting.png", --nariz
            "automobiles_painting.png", --laterais
            "automobiles_red.png", --motor
            "automobiles_white.png", --tanque de combustivel
            "automobiles_black.png", --tampa tanque
            "automobiles_black.png", --coletor escape
            "automobiles_black.png", --escapamento
            "automobiles_metal.png", --eixo direcao
            "automobiles_metal.png", --transmissao
            "automobiles_black.png", --conjunto direcao
            "automobiles_black.png", --chassis
            "automobiles_metal.png", --assoalho
            },
    },
    textures = {},
	driver_name = nil,
	sound_handle = nil,
    owner = "",
    static_save = true,
    infotext = "A nice Kart car",
    hp = 50,
    buoyancy = 2,
    physics = automobiles_lib.physics,
    lastvelocity = vector.new(),
    time_total = 0,
    _passenger = nil,
    _color = "#FFFFFF",
    _steering_angle = 0,
    _engine_running = false,
    _last_checkpoint = "",
    _total_laps = -1,
    _race_id = "",
    _energy = 1,
    _last_time_collision_snd = 0,
    _last_time_drift_snd = 0,
    _last_time_command = 0,
    _roll = math.rad(0),
    _pitch = 0,
    _longit_speed = 0,
    _show_rag = false,
    _show_lights = false,
    _light_old_pos = nil,
    _last_ground_check = 0,
    _last_light_move = 0,
    _last_engine_sound_update = 0,
    _turn_light_timer = 0,
    _inv = nil,
    _inv_id = "",
    _change_color = automobiles_lib.paint,
    _intensity = 4,
    _car_gravity = -automobiles_lib.gravity,
    _is_flying = 0,
    _trunk_slots = 0,
    _engine_sound = "kart_engine",
    _horn_sound = '',
    _base_pitch = 0.7,
    _max_fuel = 5,

    _vehicle_name = "Kart",
    _formspec_function = minekart.driver_formspec,
    _seat_pos = {{x=0.0,y=2,z=6.0}},

    _front_suspension_ent = 'kartcar:suspension',
    _front_suspension_pos = {x=0,y=2.1,z=14.7},
    _front_wheel_ent = 'kartcar:f_wheel',
    _front_wheel_xpos = 6,
    _front_wheel_frames = {x = 1, y = 11},
    _rear_suspension_ent = 'kartcar:suspension',
    _rear_suspension_pos = {x=0,y=2.1,z=0},
    _rear_wheel_ent = 'kartcar:r_wheel',
    _rear_wheel_xpos = 8.2,
    _rear_wheel_frames = {x = 1, y = 11},
    _wheel_compensation = 0.9,

    _transmission_state = 1,

    _LONGIT_DRAG_FACTOR = 0.16*0.16,
    _LATER_DRAG_FACTOR = 30.0,
    _max_acc_factor = 8,
    _max_speed = 25,
    _min_later_speed = 1.5,
    _consumption_divisor = 60000,

    get_staticdata = automobiles_lib.get_staticdata,

	on_deactivate = function(self)
        automobiles_lib.save_inventory(self)
	end,

    on_activate = automobiles_lib.on_activate,

	on_step = function(self, dtime)
        automobiles_lib.on_step(self, dtime)
        local rad_angle = math.rad(-self._steering_angle)
        self.object:set_bone_override("dir_l", {rotation = {vec = {x = 0, y = rad_angle, z = 0}, absolute = false}})
        self.object:set_bone_override("dir_r", {rotation = {vec = {x = 0, y = rad_angle, z = 0}, absolute = false}})
        self.object:set_bone_override("dir_bar", {rotation = {vec = {x = 0, y = -rad_angle, z = 0}, absolute = false}})
    end,

	on_punch = automobiles_lib.on_punch,
	on_rightclick = on_rightclick,
}

minetest.register_entity("kartcar:kart", minekart.car_properties1)


