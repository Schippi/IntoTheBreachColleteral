return function(mod,table)
	for i=1,#table do
		local object = table[i]
		local name = object.Name
		local filename = object.Filename
		local path = object.Path or "units"
		local innerPath = object.ResourcePath or "units/player"
		
		local function replaceSprite(addition)
			modApi:appendAsset("img/"..innerPath.."/"..filename..addition..".png",mod.resourcePath.."/"..path.."/"..filename..addition..".png")
		end
		
		if object.Default then replaceSprite("") end
		if object.Animated then replaceSprite("_a") end
		if object.Broken then replaceSprite("_broken") end
		if object.Icon then replaceSprite("_ns") end
		if object.Icon then replaceSprite("_h") end
		if object.Submerged then replaceSprite("_w") end
		if object.SubmergedBroken then replaceSprite("_w_broken") end
		
		local function addImage(obj, addition)
			if obj == nil then obj = {} end
			obj.Image = innerPath.."/"..filename..addition..".png"
			return obj
		end
		
		if object.Default         then ANIMS[name] =             ANIMS.MechUnit:new(addImage(object.Default,"")) end
		if object.Animated        then ANIMS[name.."a"] =        ANIMS.MechUnit:new(addImage(object.Animated,"_a")) end
		if object.Submerged       then ANIMS[name.."w"] =        ANIMS.MechUnit:new(addImage(object.Submerged,"_w")) end
		if object.Broken          then ANIMS[name.."_broken"] =  ANIMS.MechUnit:new(addImage(object.Broken,"_broken")) end
		if object.SubmergedBroken then ANIMS[name.."w_broken"] = ANIMS.MechUnit:new(addImage(object.SubmergedBroken,"_w_broken")) end
		if object.Icon            then ANIMS[name.."_ns"] =      ANIMS.MechIcon:new(addImage(object.Icon,"_ns")) end
	end
end