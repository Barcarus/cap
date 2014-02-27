local PANEL = {};
local LSD = surface.GetTextureID("Markjaw/LSD/dot");

function PANEL:Init()

	self:SetSize(ScrW(),ScrH())
	self:SetPos(0,0)
	self:SetVisible(false)
	self.GroupSystem = false;

end

local dot = surface.GetTextureID("Markjaw/LSD/dot");
local x,y;
local sX,sY;
local s = "";
local gate = "";
function PANEL:Paint()
	local Jumper = LocalPlayer():GetNetworkedEntity("jumper",NULL);
	local Pilot = LocalPlayer():GetNetworkedEntity("JPilot",NULL);
	local viewpoint = Jumper:GetPos()+Jumper:GetForward()*75+Jumper:GetUp()*25
	for k,v in pairs(ents.FindInCone(viewpoint,Jumper:GetForward(),10000,60)) do
		local pos = (Jumper:GetPos() - v:GetPos()):Length()
		if(v:IsNPC() or v:IsPlayer()) then
			if(not(LocalPlayer()==v)) then
				local vpos = v:GetPos()+Vector(0,0,20);
				local screen = vpos:ToScreen();
				for k,v in pairs(screen) do
					if k=="x" then
						x = v;
					elseif k=="y" then
						y = v;
					end
				end
				if(v:IsPlayer()) then
					s = v:GetName();
				elseif(v:IsNPC()) then
					s = v:GetClass();
					s = string.Replace(s,"npc_","");
					s = string.upper(s);
				end

				surface.SetTexture(dot);

				if (pos<10000) then
					surface.DrawTexturedRect(x-16, y-16, 32, 32);
					surface.SetFont("Default");
					surface.SetTextPos(x+20,y-20);
					surface.SetTextColor(Color(255,0,0,255));
					surface.DrawText(s);
					surface.SetTextPos(x+20,y);
					surface.DrawText(v:Health().."%");

				end
			end
		elseif(v.IsStargate) then
			local spos = v:GetPos();
			local toScreen = spos:ToScreen();
			for k,v in pairs(toScreen) do
				if k=="x" then
					sX = v;
				elseif k=="y" then
					sY = v;
				end
			end
			if(pos<2500) then
				gate = v:GetClass();
				gate = string.Replace(gate,"_"," ");
				gate = string.upper(gate);
				surface.SetFont("Default");
				surface.SetTextPos(sX+60,sY-60-(pos/75));
				surface.SetTextColor(Color(255,0,0,255));
				surface.DrawText(gate);
				surface.SetTextPos(sX+60,sY-45-(pos/75));
				surface.DrawText("Name: "..v:GetGateName());
				surface.SetTextPos(sX+60,sY-30-(pos/75));
				surface.DrawText("Address: "..v:GetGateAddress());
				local posy = 15;
				if (self.GroupSystem and not v.IsSupergate) then
					posy = 0;
					surface.SetTextPos(sX+60,sY-15-(pos/75));
					surface.DrawText("Group: "..v:GetGateGroup());
				end
				if(not(v:GetDialledAddress()=="")) then
					surface.SetTextPos(sX+60,sY-posy-(pos/75));
					surface.DrawText("Dialling: "..v:GetDialledAddress());
					print_r(v.Outputs)
				end
			end
		end
	end
	return true;
end


--################# Activate Panel @aVoN
function PANEL:Activate()
	if(not self.Active) then
		self.GroupSystem = util.tobool(StarGate.GroupSystem or 0);
		self:SetVisible(true); -- Calling SetVisible all the time causes heavy CPU Load
		self.Active = true;
	end
end

--################# Deactivate Panel @aVoN
function PANEL:Deactivate()
	if(self.Active) then
		self:SetVisible(false); -- Calling SetVisible all the time causes heavy CPU Load
		self.Active = nil;
	end
end
vgui.Register("JumperLSD",PANEL,"Panel");