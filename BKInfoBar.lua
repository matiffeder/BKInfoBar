_G.BKVERSION = "2.4.3";
local scale = GetUIScale();
local mainC, thirdC, daily, quest, ShopPer, ShopSlots, BagPer, BagSlots, ECount, BCount, AMCount, PSCount, EJCount;
local GuildCount, FriendCount, mainL, mainXP, mainMXP, thirdL, thirdXP, thirdMXP = 0, 0, 0, 0, 0, 0, 0, 0;
local default = {
	["Time"]		= true,
	["Xp"]			= true,
	["Tp"]			= true,
	["Quest"]		= true,
	["Sys"]			= true,
	["Mail"]		= true,
	["Social"]		= true,
	["Bag"]			= true,
	["Class"]		= true,
	["Money"]		= true,
	["Item"]		= true,
	["Ammo"]		= true,
	["Fix"]			= false,
	["Online"]		= true,
	["XPShow"] 		= "1",
	["BagShow"] 		= "1",
	["TimeShow"]		= "1",
	["B1X"]			= 100,
	["B1Y"] 		= 220,
	["B2X"] 		= 100,
	["B2Y"]			= 250,
};

function BK_OnLoad(this)
	local lang = GetLanguage():upper();
	local _, err = loadfile("Interface/AddOns/BKInfoBar/Locales/"..lang..".lua");
	if err then
		BK_Print("|cff993333BKInfoBar can't find translation, ENUS.lua loaded.|r");
		dofile("Interface/AddOns/BKInfoBar/Locales/ENUS.lua");
	else
		dofile("Interface/AddOns/BKInfoBar/Locales/"..lang..".lua");
	end
	this:RegisterEvent("VARIABLES_LOADED");
end

function BK_OnEvent()
	if BKSettings==nil then
		BKSettings = default;
	else
		for k,v in pairs(default) do
			if BKSettings[k]==nil then
				BKSettings[k] = v;
			end
		end
	end
	SaveVariables("BKSettings");
	BK_Print("|cff34CB93BKInfoBar %s|r %s", BKVERSION, BKLang["Messages"]["WELCOME"]);
end

function BKBar1_Move()
	if BKSettings["Fix"]==false then
		BKBar1:StartMoving("TOPLEFT");
	else
		BK_Print("|cff34CB93BKInfoBar|r %s", BKLang["Messages"]["FIXED"]);
	end
end

function BKBar1_MoveEnd()
	BKBar1:StopMovingOrSizing();
	BKSettings["B1X"], BKSettings["B1Y"] = BKBar1:GetPos();
end

function BKBar2_Move()
	if BKSettings["Fix"]==false then
		BKBar2:StartMoving("TOPLEFT");
	else
		BK_Print("|cff34CB93BKInfoBar|r %s", BKLang["Messages"]["FIXED"]);
	end
end

function BKBar2_MoveEnd()
	BKBar2:StopMovingOrSizing();
	BKSettings["B2X"], BKSettings["B2Y"] = BKBar2:GetPos();
end

function BKBarConfigSave()
	BKSettings["Time"]=chkBKBarshow:IsChecked();
	BKSettings["Xp"]=chkBKBarXP:IsChecked();
	BKSettings["Tp"]=chkBKBarTP:IsChecked();
	BKSettings["Quest"]=chkBKBarPercent:IsChecked();
	BKSettings["Sys"]=chkBKBarSys:IsChecked();
	BKSettings["Mail"]=chkBKBarPing:IsChecked();
	BKSettings["Social"]=chkBKBarSocial:IsChecked();
	BKSettings["Bag"]=chkBKBarPlatz:IsChecked();
	BKSettings["Class"]=chkBKBarCharInfo:IsChecked();
	BKSettings["Money"]=chkBKBarMoney:IsChecked();
	BKSettings["Item"]=chkBKBarTasche:IsChecked();
	BKSettings["Ammo"]=chkBKBarAmmo:IsChecked();
	BKSettings["Fix"]=chkBKBarFix:IsChecked();
	BKSettings["Online"]=chkBKBarOnline:IsChecked();
end

function BK_SetVisible(o, v)
	if v==true then
		o:Show();
	else
		o:Hide();
	end
end

function BKBar1Load()
	BKBar1:ClearAllAnchors();
	BKBar1:SetAnchor("TOPLEFT", "TOPLEFT", "UIParent", BKSettings["B1X"]/scale, BKSettings["B1Y"]/scale);
	BK_SetVisible(BKXp, BKSettings["Xp"]);
	BK_SetVisible(BKTp, BKSettings["Tp"]);
	BK_SetVisible(BKSys, BKSettings["Sys"]);
	BK_SetVisible(BKMoney, BKSettings["Money"]);
	BK_SetVisible(BKQuest, BKSettings["Quest"]);
	BK_SetVisible(BKMail, BKSettings["Mail"]);
	BK_SetVisible(BKSocial, BKSettings["Social"]);
	BK_SetVisible(BKBag, BKSettings["Bag"]);
	BK_SetVisible(BKClass, BKSettings["Class"]);

	local Bar1X = 20;
	if BKSettings["Xp"]==true then
		BKTp:ClearAllAnchors();
		BKTp:SetAnchor("LEFT", "RIGHT", "BKXp", 0, 0);
		Bar1X = Bar1X + 189;
		BKBar1:SetWidth(Bar1X);
		BKXp:ClearAllAnchors();
		BKXp:SetAnchor("LEFT", "RIGHT", "BKConfigButton", 0,0);
	else
		BKXp:ClearAllAnchors();
		BKXp:SetAnchor("LEFT", "RIGHT", "BKConfigButton", -189,0);
		BKBar1:SetWidth(Bar1X);
		BKTp:ClearAllAnchors();
		BKTp:SetAnchor("LEFT", "RIGHT", "BKXp", 0, 0);
	end

	if BKSettings["Tp"]==true then
		Bar1X = Bar1X + 79;
		BKTp:ClearAllAnchors();
		BKTp:SetAnchor("LEFT", "RIGHT", "BKXp", 0, 0);
		BKBar1:SetWidth(Bar1X);
	else
		BKTp:ClearAllAnchors();
		BKTp:SetAnchor("LEFT", "RIGHT", "BKXp", -79,0 );
		BKMoney:ClearAllAnchors();
		BKMoney:SetAnchor("LEFT", "RIGHT", "BKTp", 0, 0);
		Bar1X = Bar1X;
		BKBar1:SetWidth(Bar1X);
	end

	if BKSettings["Money"]==true then
		Bar1X = Bar1X + 179;
		BKMoney:ClearAllAnchors();
		BKMoney:SetAnchor("LEFT", "RIGHT", "BKTp", 0, 0);
		BKBar1:SetWidth(Bar1X);
	else
		BKMoney:ClearAllAnchors();
		BKMoney:SetAnchor("LEFT", "RIGHT", "BKTp", -179,0 );
		BKQuest:ClearAllAnchors();
		BKQuest:SetAnchor("LEFT", "RIGHT", "BKMoney", 0, 0);
		Bar1X = Bar1X;
		BKBar1:SetWidth(Bar1X);
	end

	if BKSettings["Quest"]==true then
		Bar1X = Bar1X + 59;
		BKQuest:ClearAllAnchors();
		BKQuest:SetAnchor("LEFT", "RIGHT", "BKMoney", 0, 0);
		BKBar1:SetWidth(Bar1X);
	else
		BKQuest:ClearAllAnchors();
		BKQuest:SetAnchor("LEFT", "RIGHT", "BKMoney", -59,0 );
		BKBag:ClearAllAnchors();
		BKBag:SetAnchor("LEFT", "RIGHT", "BKQuest", 0, 0);
		Bar1X = Bar1X;
		BKBar1:SetWidth(Bar1X);
	end

	if BKSettings["Bag"]==true then
		Bar1X = Bar1X + 69;
		BKBag:ClearAllAnchors();
		BKBag:SetAnchor("LEFT", "RIGHT", "BKQuest", 0, 0);
		BKBar1:SetWidth(Bar1X);
	else
		BKBag:ClearAllAnchors();
		BKBag:SetAnchor("LEFT", "RIGHT", "BKQuest", -69,0 );
		BKClass:ClearAllAnchors();
		BKClass:SetAnchor("LEFT", "RIGHT", "BKBag", 0, 0);
		Bar1X = Bar1X;
		BKBar1:SetWidth(Bar1X);
	end

	if BKSettings["Class"]==true then
		Bar1X = Bar1X + 109;
		BKClass:ClearAllAnchors();
		BKClass:SetAnchor("LEFT", "RIGHT", "BKBag", 0, 0);
		BKBar1:SetWidth(Bar1X);
	else
		BKClass:ClearAllAnchors();
		BKClass:SetAnchor("LEFT", "RIGHT", "BKBag", -109,0 );
		BKMail:ClearAllAnchors();
		BKMail:SetAnchor("LEFT", "RIGHT", "BKClass", 0, 0);
		Bar1X = Bar1X;
		BKBar1:SetWidth(Bar1X);
	end

	if BKSettings["Mail"]==true then
		Bar1X = Bar1X + 39;
		BKMail:ClearAllAnchors();
		BKMail:SetAnchor("LEFT", "RIGHT", "BKClass", 0, 0);
		BKBar1:SetWidth(Bar1X);
	else
		BKMail:ClearAllAnchors();
		BKMail:SetAnchor("LEFT", "RIGHT", "BKClass", -39,0 );
		BKSocial:ClearAllAnchors();
		BKSocial:SetAnchor("LEFT", "RIGHT", "BKMail", 0, 0);
		Bar1X = Bar1X;
		BKBar1:SetWidth(Bar1X);
	end

	if BKSettings["Social"]==true then
		Bar1X = Bar1X + 69;
		BKSocial:ClearAllAnchors();
		BKSocial:SetAnchor("LEFT", "RIGHT", "BKMail", 0, 0);
		BKBar1:SetWidth(Bar1X);
	else
		BKSocial:ClearAllAnchors();
		BKSocial:SetAnchor("LEFT", "RIGHT", "BKMail", -69,0 );
		Bar1X = Bar1X;
		BKBar1:SetWidth(Bar1X);
	end
end

function BKBar2Load()
	BKBar2:ClearAllAnchors();
	BKBar2:SetAnchor("TOPLEFT", "TOPLEFT", "UIParent", BKSettings["B2X"]/scale, BKSettings["B2Y"]/scale);
	BK_SetVisible(BKTime, BKSettings["Time"]);
	BK_SetVisible(BKSys, BKSettings["Sys"]);
	BK_SetVisible(BKItem, BKSettings["Item"]);
	BK_SetVisible(BKAmmo, BKSettings["Ammo"]);

	FramerateText:ClearAllAnchors();
	FramerateText:SetAnchor("BOTTOMRIGHT", "TOPRIGHT", "BKBar2", 290, 0);
	FramerateText:SetScale(0.7);
	local Bar2X = 0;
	if BKSettings["Time"]==true then
		BKSys:ClearAllAnchors();
		BKSys:SetAnchor("LEFT", "RIGHT", "BKTime", 0, 0);
		Bar2X = Bar2X + 139;
		BKBar2:SetWidth(Bar2X);
		BKTime:ClearAllAnchors();
		BKTime:SetAnchor("LEFT", "LEFT", "BKBar2", 0,0);
	else
		BKTime:ClearAllAnchors();
		BKTime:SetAnchor("LEFT", "LEFT", "BKBar2", -139,0);
		BKBar2:SetWidth(Bar2X);
		BKSys:ClearAllAnchors();
		BKSys:SetAnchor("LEFT", "RIGHT", "BKTime", 0, 0);
	end

	if BKSettings["Sys"]==true then
		Bar2X = Bar2X + 79;
		BKSys:ClearAllAnchors();
		BKSys:SetAnchor("LEFT", "RIGHT", "BKTime", 0, 0);
		BKBar2:SetWidth(Bar2X);
	else
		BKSys:ClearAllAnchors();
		BKSys:SetAnchor("LEFT", "RIGHT", "BKTime", -79,0 );
		BKItem:ClearAllAnchors();
		BKItem:SetAnchor("LEFT", "RIGHT", "BKSys", 0, 0);
		Bar2X = Bar2X;
		BKBar2:SetWidth(Bar2X);
	end

	if BKSettings["Item"]==true then
		Bar2X = Bar2X + 139;
		BKItem:ClearAllAnchors();
		BKItem:SetAnchor("LEFT", "RIGHT", "BKSys", 0, 0);
		BKBar2:SetWidth(Bar2X);
	else
		BKItem:ClearAllAnchors();
		BKItem:SetAnchor("LEFT", "RIGHT", "BKSys", -139,0 );
		BKAmmo:ClearAllAnchors();
		BKAmmo:SetAnchor("LEFT", "RIGHT", "BKItem", 0, 0);
		Bar2X = Bar2X;
		BKBar2:SetWidth(Bar2X);
	end

	if BKSettings["Ammo"]==true then
		Bar2X = Bar2X + 49;
		BKAmmo:ClearAllAnchors();
		BKAmmo:SetAnchor("LEFT", "RIGHT", "BKItem", 0, 0);
		BKBar2:SetWidth(Bar2X);
	else
		BKAmmo:ClearAllAnchors();
		BKAmmo:SetAnchor("LEFT", "RIGHT", "BKItem", -49,0 );
		Bar2X = Bar2X;
		BKBar2:SetWidth(Bar2X);
	end
end

function BK_Print(str, ...)
	DEFAULT_CHAT_FRAME:AddMessage(str:format(...), 1, 1, 1);
end

function BK_Dec(value)
	while true do
		value, k = string.gsub(value, "^(-?%d+)(%d%d%d)", '%1.%2');
		if (k==0) then
			break;
		end
	end
	return value;
end

SLASH_BKBar1="/BKC";
SLASH_BKBar2="/BKCONF";
SlashCmdList["BKBar"]=BKBar_ConfigLoad;

--======================== EXP ========================

function BKXp_Changer()
	if BKSettings["XPShow"]=="1" then BKSettings["XPShow"] = "2";
	elseif BKSettings["XPShow"]=="2" then BKSettings["XPShow"] = "3";
	elseif BKSettings["XPShow"]=="3" then BKSettings["XPShow"] = "4";
	else BKSettings["XPShow"] = "1";
	end
end

function BKXp_Update()
	local mC, sC = UnitClass("player");
	local count = GetPlayerNumClasses();
	for i = 1, count do
		local class, token, level, currExp, maxExp, debt = GetPlayerClassInfo(i, true);
		if class~=nil then
			if class==mC then
				mainC = class;
				mainL = level;
				mainXP = currExp;
				mainMXP = maxExp;
			elseif class==sC then
				subC = class;
				subL = level;
				subXP = currExp;
				subMXP = maxExp;
			elseif count==3 then
				thirdC = class;
				thirdL = level;
				thirdXP = currExp;
				thirdMXP = maxExp;
				thirdExpD = debt;
			end
		end
	end
	local mainExpD, mainTpD, subExpD, subTpD = GetPlayerExpDebt();
	if mainExpD<0 or mainTpD<0 then
		BKXp_Text1:SetColor(.75, .23, .23);
	else
		BKXp_Text1:SetColor(1, 1, 1);
	end
	local subXPP;
	if sC=="" or sC==nil then
		BKXp_Text2:SetColor(1, 1, 1);
		subC = NONE;
		subL = "Lv"
		subXP = 0;
		subMXP = 0;
		subXPP = "0%"
	else
		if subExpD<0 or subTpD<0 then
			BKXp_Text2:SetColor(.75, .23, .23);
		else
			BKXp_Text2:SetColor(1, 1, 1);
		end
		subXPP = (math.ceil((subXP / subMXP) * 1000) / 10).."%"
	end

	local mainXPP = (math.ceil((mainXP / mainMXP) * 1000) / 10).."%"
	if BKSettings["XPShow"]=="1" then
		BKXp_Text1:SetText(BK_Dec(mainXP).."/"..BK_Dec(mainMXP).." - "..mainXPP);
		BKXp_Text2:SetText(BK_Dec(subXP).."/"..BK_Dec(subMXP).." - "..subXPP);
	elseif BKSettings["XPShow"]=="2" then
		BKXp_Text1:SetText(BK_Dec(mainMXP-mainXP).."/"..BK_Dec(mainMXP).." - "..mainXPP);
		BKXp_Text2:SetText(BK_Dec(subMXP-subXP).."/"..BK_Dec(subMXP).." - "..subXPP);
	elseif BKSettings["XPShow"]=="3" then
		BKXp_Text1:SetText(BK_Dec(mainXP).." - "..mainXPP);
		BKXp_Text2:SetText(BK_Dec(subXP).." - "..subXPP);
	else
		BKXp_Text1:SetText(BK_Dec(mainMXP-mainXP).." - "..mainXPP);
		BKXp_Text2:SetText(BK_Dec(subMXP-subXP).." - "..subXPP);
	end

	BKClass_Text1:SetText(mainC..": "..mainL);
	BKClass_Text2:SetText(subC..": "..subL);
end

function BKXp_SetColor(color)
	if color<0 then return "|cffBE3B3B";
	else return "|cffFFFFFF"; end
end

function BKXp_Tooltip(this)
	local xpbonus, tpbonus = GetPlayerExtraPoint();
	local mainExp, mainTp, subExp, subTp = GetPlayerExpDebt("player");
	local mL, sL = UnitLevel("player");
	GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT", -20, 0); 
	GameTooltip:SetText("");
	GameTooltip:AddLine("|cffffff00Lv"..mL.." "..mainC);
	GameTooltip:AddLine(BKLang["Messages"]["XPDEBT"]..BKXp_SetColor(mainExp)..BK_Dec(mainExp));
	GameTooltip:AddLine(BKLang["Messages"]["TPDEBT"]..BKXp_SetColor(mainTp)..BK_Dec(mainTp));
	if sL~=0 then
		GameTooltip:AddLine("|cffffff00Lv"..sL.." "..subC);
		GameTooltip:AddLine(BKLang["Messages"]["XPDEBT"]..BKXp_SetColor(subExp)..BK_Dec(subExp));
		GameTooltip:AddLine(BKLang["Messages"]["TPDEBT"]..BKXp_SetColor(subTp)..BK_Dec(subTp));
	end
	if thirdC~=nil then
		GameTooltip:AddSeparator();
		GameTooltip:AddLine("|cffffff00Lv"..thirdL.." "..thirdC);
		GameTooltip:AddLine(BKLang["Messages"]["XPNOW"]..BK_Dec(thirdXP).."/"..BK_Dec(thirdMXP));
		GameTooltip:AddLine(BKLang["Messages"]["XPNEED"]..BK_Dec(thirdMXP-thirdXP).."/"..BK_Dec(math.ceil(((thirdMXP-thirdXP) / thirdMXP) * 100)).."%");
		GameTooltip:AddLine(BKLang["Messages"]["XPDEBT"]..BKXp_SetColor(thirdExpD)..BK_Dec(thirdExpD));
	end
	GameTooltip:AddSeparator();
	GameTooltip:AddLine(BKLang["Messages"]["XPBONUS"]..BK_Dec(xpbonus));
	GameTooltip:AddLine(BKLang["Messages"]["TPBONUS"]..BK_Dec(tpbonus));
end

function BKTp_Tooltip(this)
	local tpused = GetTotalTpExp() - GetTpExp();
	GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT", -20, 0); 
	GameTooltip:SetText("");
	GameTooltip:AddLine(BKLang["Messages"]["TPNOW"]..BK_Dec(GetTpExp()));
	GameTooltip:AddLine(BKLang["Messages"]["TPUSED"]..BK_Dec(tpused));
	GameTooltip:AddLine(BKLang["Messages"]["TPALL"]..BK_Dec(GetTotalTpExp()));
end

--======================== Quest ========================

function BKQuest_Update()
	local dailyCount, dailyPerDay = Daily_count();
	if dailyCount==dailyPerDay then
		daily = "|cffBE3B3B"..dailyCount.."/"..dailyPerDay.."|r";
	else
		daily = dailyCount.."/"..dailyPerDay;
	end
	local totalQuest = GetNumQuestBookButton_QuestBook();
	local finishQuest = 0;
	if totalQuest > 0 then
		for i = 1, totalQuest do
			local _, _, _, _, _, _, _, _, _, Complete = GetQuestInfo(i);
			if Complete then
				finishQuest = finishQuest + 1;
			end
		end
		quest = finishQuest.."/"..totalQuest;
	else
		quest = NONE;
	end
	BKQuest_Text1:SetText(daily);
	BKQuest_Text2:SetText(quest);
end

function BKQuest_Tooltip(this)
	GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT", -20, 0); 
	GameTooltip:SetText("");
	GameTooltip:AddLine(UI_QUEST_MSG_DAILY..": "..daily);
	GameTooltip:AddLine(PB_DROPDOWN_MISSION..": "..quest);
end

--======================== Dura ========================

function BKDura_SetColor(color)
	if color<41 then return "|cffBE3B3B";
	elseif color<86 then return "|cffFFAA00";
	else return "|cffFFFFFF"; end
end

function BKDura_Tooltip(this)
	local itemCount = 0;
	local AvgDur = 0;
	GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT", -20, 0)
	GameTooltip:SetText("")
	for i = 0, 16 do
		if i~=9 then
			local curD, maxD, itemName = GetInventoryItemDurable("player", i)
			if itemName then
				itemCount = itemCount + 1;
				local TEMP_DUR = math.ceil((curD / maxD) * 10000) / 10;
				AvgDur = AvgDur + TEMP_DUR;
				if maxD>100 then
					maxD = "|cff00FF00"..maxD.."|r";
				end
				if curD>100 then
					curD = "|cff00FF00"..curD.."|r";
				else
					curD = BKDura_SetColor(curD)..curD.."|r";
				end
				local r, g, b = GetItemQualityColor(GetInventoryItemQuality("player", i))
				GameTooltip:AddDoubleLine(itemName, curD.."/"..maxD, r, g, b)
			end
		end
	end
	AvgDur = math.ceil((AvgDur/itemCount) * 10) / 100;
	GameTooltip:AddSeparator();
	GameTooltip:AddDoubleLine(" ", BKDura_SetColor(AvgDur)..AvgDur.."%|r")
end

--======================== Ammo ========================

function BKAmmo_Update()
	local _, _, name = GetInventoryItemDurable("player", 9);
	if name then
		ECount = GetInventoryItemCount("player", 9);
		BCount = GetCountInBagByName(name);
	else
		ECount = 0;
		BCount = 0;
	end
	if ECount<=25 then
		BKAmmo_Text1:SetText("|cffBE3B3B"..ECount);
	else
		BKAmmo_Text1:SetText(ECount);
	end
	BKAmmo_Text2:SetText(BCount);
end

function BKAmmo_Tooltip(this)
	GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT", -20, 0); 
	GameTooltip:SetText("");
	GameTooltip:AddLine(BACKPACK_EQUIP..": "..ECount);
	GameTooltip:AddLine(GCF_TEXT_BAG..": "..BCount);
end

--======================== Bag ========================

function BKBag_OnClick(key)
	if key=="LBUTTON" then
		if BankFrame:IsVisible() then
			BankFrame:Hide();
		elseif TimeLet_GetLetTime("BankLet")<0 then
			BankFrame:Show();
		else
			OpenBank();
		end
	elseif key=="RBUTTON" then
		if BKSettings["BagShow"]=="1" then BKSettings["BagShow"] = "2";
		elseif BKSettings["BagShow"]=="2" then BKSettings["BagShow"] = "3";
		elseif BKSettings["BagShow"]=="3" then BKSettings["BagShow"] = "4";
		else BKSettings["BagShow"] = "1";
		end
		BKBag_Update();
	end
end

function BKBag_Update()
	local bused, btotal = GetBagCount();
	AMCount = GetCountInBagByName(TEXT("Sys206879_name")) + GetCountInBankByName(TEXT("Sys206879_name"));
	PSCount = GetCountInBagByName(TEXT("Sys240181_name")) + GetCountInBankByName(TEXT("Sys240181_name"));
	EJCount = GetCountInBagByName(TEXT("Sys201545_name")) + GetCountInBankByName(TEXT("Sys201545_name"));
	BKMoney_Text1:SetText(BK_Dec(GetPlayerMoney("copper")).." "..BKLang["Messages"]["GOLD"].."|cff686868 | |cffc0c0c0"..GetPlayerMoney("billdin").. " " ..BKLang["Messages"]["PHIR"]);
	BKMoney_Text2:SetText("|cff6DCDDC"..GetPlayerMoney("account").."|cff686868 | |cffDC6D6D"..GetPlayerMoney("bonus").."|cff686868 | |cff6DDCB5"..AMCount.."|cff686868 | |cffFA9051"..PSCount.."|cff686868 | |cffFA5151"..EJCount);

	local sused = 0;
	for i = 1, 50 do
		local _, _, count, _ = GetGoodsItemInfo(i);
		if count>0 then
			sused = sused + 1;
		end
	end
	local sload = math.ceil((sused / 50) * 100);
	ShopPer = BKBag_SetColor(sload)..sload.."%";
	ShopSlots = BKBag_SetColor(sload)..sused.."/50";
	local ShopFree = BKBag_SetColor(sload)..50-sused.."/"..50;
	local bload = math.ceil((bused / btotal) * 100);
	BagPer = BKBag_SetColor(bload)..bload.."%";
	BagSlots = BKBag_SetColor(bload)..bused.."/"..btotal;
	local BagFree = BKBag_SetColor(bload)..btotal-bused.."/"..btotal;
	if BKSettings["BagShow"]=="1" then
		BKBag_Text1:SetText(BagSlots);
		BKBag_Text2:SetText(ShopSlots);
	elseif BKSettings["BagShow"]=="2" then
		BKBag_Text1:SetText(BagFree);
		BKBag_Text2:SetText(ShopFree);
	elseif BKSettings["BagShow"]=="3" then
		BKBag_Text1:SetText(BagSlots);
		BKBag_Text2:SetText(BagPer);
	else
		BKBag_Text1:SetText(BagPer);
		BKBag_Text2:SetText(ShopPer);
	end

	local index1, _, name1, count1 = GetBagItemInfo("1");
	local index2, _, name2, count2 = GetBagItemInfo("2");
	BKItemTip1 = index1;
	BKItemTip2 = index2;
	BKItem_Text1:SetText(count1.."x "..name1);
	BKItem_Text2:SetText(count2.."x "..name2);
end

function BKBag_SetColor(color)
	if color>80 then return "|cffBE3B3B";
	elseif color>69 then return "|cffFFAA00";
	else return "|cffFFFFFF"; end
end

function BKBag_Tooltip(this)
	GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT", -20, 0); 
	GameTooltip:SetText("");
	GameTooltip:AddLine(GCF_TEXT_BAG..": "..BagSlots.." - "..BagPer);
	GameTooltip:AddLine(MERCHANT..": "..ShopSlots.." - "..ShopPer);
end

function BKMoney_Tooltip(this)
	GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT", -20, 0); 
	GameTooltip:SetText("");
	GameTooltip:AddLine(MONEY_RUNE..": |cff6DCDDC"..GetPlayerMoney("account"));
	GameTooltip:AddLine(BILLBOARD_003..": |cffDC6D6D"..GetPlayerMoney("bonus"));
	GameTooltip:AddLine(TEXT("Sys206879_name")..": |cff6DDCB5"..AMCount);
	GameTooltip:AddLine(TEXT("Sys240181_name")..": |cffFA9051"..PSCount);
	GameTooltip:AddLine(TEXT("Sys201545_name")..": |cffFA5151"..EJCount);
end

--======================== Mail ========================

local unread = 0;

function BKMail_Update(event)
	if event=="MAIL_SHOW" then
		unread = 0;
		BKMail_Text1:SetColor(1, 1, 1)
	end
	if event=="CHAT_MSG_SYSTEM" then
		if arg1==TEXT("SYS_NEW_MAIL") then
			unread = unread + 1;
			BKMail_Text1:SetColor(1, .67, 0)
		end
	end
	BKMail_Text1:SetText(unread);
end

function BKMail_Click()
	if TimeLet_GetLetTime("MailLet")<0 then
		StaticPopup_Show("TIMEFLAG_FAIL1");
		return;
	else
		OpenMail();
	end
end

--======================== Social ========================

function BKSocial_Update()
	GuildCount=0;
	for i=1,GetNumGuildMembers() do
		local _,_,_,_,_,_,_,_,_,_,On=GetGuildRosterInfo(i);
		if On then if On==true then GuildCount=GuildCount+1; end; end
	end
	FriendCount=0;
	for i=1,GetFriendCount("Friend") do
		local _,_,On=GetFriendInfo("Friend",i);
		if On then if On==true then FriendCount=FriendCount+1; end; end
	end
	BKSocial_Text1:SetText(GuildCount.."/"..GetNumGuildMembers());
	BKSocial_Text2:SetText(FriendCount.."/"..GetFriendCount("Friend"));
end

function BKSocial_Tooltip(this)
	GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT", -20, 0); 
	GameTooltip:SetText("");
	GameTooltip:AddLine(GUILD..": "..GuildCount.."/"..GetNumGuildMembers());
	GameTooltip:AddLine(C_RELATION_FRIEND..": "..FriendCount.."/"..GetFriendCount("Friend"));
end

--======================== Clock ========================

local start = GetTime();
local update1 = 0;

function BKTime_Changer()
	if BKSettings["TimeShow"]=="1" then 
		BKSettings["TimeShow"] = "2";
		BK_Print("|cff34CB93BKInfoBar|r %s", BKLang["Messages"]["TIMEVERSION1"]);
	else
		BKSettings["TimeShow"] = "1";
		BK_Print("|cff34CB93BKInfoBar|r %s", BKLang["Messages"]["TIMEVERSION2"]);
	end

end

function BKTime_Update(this, elapsedTime)
	update1 = update1 + elapsedTime;
	if update1>=1 then 
		local current = GetTime();
		local temptime = current - start;
		local hours = math.floor(temptime / 3600);
		local minutes = ((temptime - (hours * 3600)) / 60);
		if BKSettings["TimeShow"]=="1" then 
			if BKSettings["Online"]==true then
				BKTime_Text2:SetText(os.date("%H:%M").." (Online: "..string.format("%02d:%02d",hours,minutes)..")");
			else
				BKTime_Text2:SetText(os.date("%H:%M"));
			end
		else
			if BKSettings["Online"]==true then
				BKTime_Text2:SetText(os.date("%I:%M").." (Online: "..string.format("%02d:%02d",hours,minutes)..")");
			else
				BKTime_Text2:SetText(os.date("%I:%M"));
			end
		end
		BKTime_Text1:SetText(os.date("%d.%b.%Y - %a"));
	end
end 

--======================== SYS ========================
local update2 = 0;

function BKSys_Update(this, elapsedTime)
	update2 = update2 + elapsedTime;
	if update2>=1 then 
		local FRAMES = GetFramerate();
		local PING = GetPing();
		if FRAMES<=20.0 then
			BKSys_Text1:SetText(string.format("|cffBE3B3B FPS: %.0f", GetFramerate()));
		elseif FRAMES<=30.0 then
			BKSys_Text1:SetText(string.format("|cffFFAA00 FPS: %.0f", GetFramerate()));
		else
			BKSys_Text1:SetText(string.format("FPS: %.0f", GetFramerate()));
		end
		if PING>=150 then
			BKSys_Text2:SetText(string.format("|cffBE3B3B Ping: %d ", GetPing()));
		elseif PING>=100 then
			BKSys_Text2:SetText(string.format("|cffFFAA00 Ping: %d ", GetPing()));
		else
			BKSys_Text2:SetText(string.format("Ping: %d ", GetPing()));
		end
	end
end
