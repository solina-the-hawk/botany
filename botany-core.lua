-- =========================================================================
-- BOTANY: Automated Harvesting & Gathering System for Achaea
-- A comprehensive, modular system for botanical collection and processing.
-- Author: Solina (https://github.com/solina-the-hawk/Botany/)
-- Version: 1.0.0
-- =========================================================================

Botany = Botany or {}

-- =========================================================================
-- Configuration
-- =========================================================================
Botany.config = Botany.config or {
    colors = {
        botanyMain   = {50, 205, 50},   -- LimeGreen (Primary accents/ON states)
        botanyAccent = {34, 139, 34},   -- ForestGreen (Headers/Borders)
        botanyText   = {211, 211, 211}, -- LightGray (Standard text)
        botanyAlert  = {178, 34, 34},   -- Firebrick (Errors/OFF states)
    }
}

for name, rgb in pairs(Botany.config.colors) do
    color_table[name] = rgb
end

-- =========================================================================
-- Runtime States
-- =========================================================================
Botany.HarvestOn = Botany.HarvestOn or false
Botany.Balance = Botany.Balance or 1
Botany.HarvTar = Botany.HarvTar or "None"
Botany.Harvesting = Botany.Harvesting or false
Botany.Memory = Botany.Memory or {}
Botany.GlobalExpiration = Botany.GlobalExpiration or 24
Botany.AutoMode = Botany.AutoMode or false
Botany.LastRoom = Botany.LastRoom or "0"
Botany.GatherOn = Botany.GatherOn or false
Botany.GathTar = Botany.GathTar or "None"
Botany.Gathering = Botany.Gathering or false

Botany.ButcheryOn = Botany.ButcheryOn or false
Botany.RefiningOn = Botany.RefiningOn or false

Botany.Ginseng = Botany.Ginseng or {Enabled = true, Harvest = false}
Botany.Ash = Botany.Ash or {Enabled = true, Harvest = false}
Botany.Echinacea = Botany.Echinacea or {Enabled = true, Harvest = false}
Botany.Ginger = Botany.Ginger or {Enabled = true, Harvest = false}
Botany.Myrrh = Botany.Myrrh or {Enabled = true, Harvest = false}
Botany.Bellwort = Botany.Bellwort or {Enabled = true, Harvest = false}
Botany.Bloodroot = Botany.Bloodroot or {Enabled = true, Harvest = false}
Botany.Hawthorn = Botany.Hawthorn or {Enabled = true, Harvest = false}
Botany.Kuzu = Botany.Kuzu or {Enabled = true, Harvest = false}
Botany.Skullcap = Botany.Skullcap or {Enabled = true, Harvest = false}
Botany.Slipper = Botany.Slipper or {Enabled = true, Harvest = false}
Botany.Goldenseal = Botany.Goldenseal or {Enabled = true, Harvest = false}
Botany.Valerian = Botany.Valerian or {Enabled = true, Harvest = false}
Botany.Bayberry = Botany.Bayberry or {Enabled = true, Harvest = false}
Botany.Cohosh = Botany.Cohosh or {Enabled = true, Harvest = false}
Botany.Lobelia = Botany.Lobelia or {Enabled = true, Harvest = false}
Botany.Pear = Botany.Pear or {Enabled = true, Harvest = false}
Botany.Weed = Botany.Weed or {Enabled = true, Harvest = false}
Botany.Irid = Botany.Irid or {Enabled = true, Harvest = false}
Botany.Sileris = Botany.Sileris or {Enabled = true, Harvest = false}
Botany.Kelp = Botany.Kelp or {Enabled = true, Harvest = false}
Botany.Kola = Botany.Kola or {Enabled = true, Harvest = false}
Botany.Elm = Botany.Elm or {Enabled = true, Harvest = false}

Botany.gatherItems = {"Clay", "Saltwater", "Fruit", "Grain", "Vegetables", "Farm", "Nuts", "Olives", "Sugarcane", "Lumic", "Cacao", "Dust"}
for _, item in ipairs(Botany.gatherItems) do
  Botany[item] = Botany[item] or {Enabled = true, Gather = false}
end

function Botany.echo(text)
  cecho("\n<botanyText>[<botanyMain>Botany<botanyText>]: " .. text .. "<reset>")
end

-- =========================================================================
-- UI & Display
-- =========================================================================
function Botany.display()
  local harvStat = Botany.HarvestOn and "<botanyMain>ON<botanyText>" or "<botanyAlert>OFF<botanyText>"
  local gathStat = Botany.GatherOn and "<botanyMain>ON<botanyText>" or "<botanyAlert>OFF<botanyText>"
  local butchStat = Botany.ButcheryOn and "<botanyMain>ON<botanyText>" or "<botanyAlert>OFF<botanyText>"
  local refStat = Botany.RefiningOn and "<botanyMain>ON<botanyText>" or "<botanyAlert>OFF<botanyText>"
  local autoStat = Botany.AutoMode and "<botanyMain>ON<botanyText>" or "<botanyAlert>OFF<botanyText>"

  cecho("\n<botanyAccent>=======================================================================<reset>")
  cecho("\n<botanyAccent>                       B O T A N Y   S T A T U S                       <reset>")
  cecho("\n<botanyAccent>=======================================================================<reset>")
  cecho(string.format("\n<botanyText>  Harvesting: [%s] | Gathering: [%s] | Auto-Scan: [%s]", harvStat, gathStat, autoStat))
  cecho(string.format("\n<botanyText>  Butchering: [%s] | Refining:  [%s]", butchStat, refStat))
  cecho(string.format("\n<botanyText>  Area Expiration Timer: <botanyMain>%d<botanyText> IRL hours", Botany.GlobalExpiration))
  cecho("\n<botanyAccent>=======================================================================<reset>")
  cecho("\n<botanyText>  Type <botanyMain>bot help<botanyText> for a full list of commands.\n")
end

function Botany.help()
  cecho("\n<botanyAccent>=======================================================================<reset>")
  cecho("\n<botanyAccent>                          B O T A N Y   H E L P                        <reset>")
  cecho("\n<botanyAccent>=======================================================================<reset>\n")
  cecho("\n<botanyText>Commands work interchangeably with <botanyMain>bot<botanyText> or <botanyMain>botany<botanyText>.<reset>\n")
  cecho("\n<botanyMain>Basic Controls:<reset>")
  cecho("\n  <botanyMain>bot harvesting<botanyText>       - Toggle herb harvesting on/off")
  cecho("\n  <botanyMain>bot gathering<botanyText>        - Toggle commodity gathering on/off")
  cecho("\n  <botanyMain>bot butchering<botanyText>       - Toggle butchering module on/off")
  cecho("\n  <botanyMain>bot refining<botanyText>         - Toggle refining module on/off")
  cecho("\n  <botanyMain>bot auto<botanyText>             - Toggle auto-scan when walking into new rooms")
  cecho("\n  <botanyMain>bot expiration <hrs><botanyText> - Set memory expiration (e.g. 'bot expiration 24')")
  cecho("\n  <botanyMain>bot scan<botanyText>             - Force a manual harvest/gather scan right now")
  cecho("\n  <botanyMain>bot show<botanyText>             - Show enabled/disabled status of all plants")
  cecho("\n  <botanyMain>bot toggle <plant><botanyText>   - Toggle an individual plant/commodity on/off")
  cecho("\n  <botanyMain>bot reset<botanyText>            - Emergency reset (clears stuck active flags)")
  cecho("\n\n<botanyMain>Module Actions:<reset>")
  cecho("\n  <botanyMain>bot butcher <type><botanyText>   - Butcher inventory corpses (meat, skins, reagents)")
  cecho("\n  <botanyMain>bot refine <item> <#><botanyText>- Refine an amount of gathered commodities")
  cecho("\n<botanyAccent>=======================================================================<reset>\n")
end

function Botany.showTable()
  cecho("\n<botanyAccent>==================================================\n")
  cecho("<botanyAccent>               BOTANY CONFIGURATION\n")
  cecho("<botanyAccent>==================================================\n")
  
  local gatherSet = {}
  for _, v in ipairs(Botany.gatherItems) do gatherSet[v] = true end
  
  local herbs = {}
  for k, v in pairs(Botany) do
    if type(v) == "table" and v.Enabled ~= nil then
      table.insert(herbs, {name = k, enabled = v.Enabled, isGather = gatherSet[k]})
    end
  end
  table.sort(herbs, function(a, b) return a.name < b.name end)
  
  for _, herb in ipairs(herbs) do
    local moduleOn = herb.isGather and Botany.GatherOn or (not herb.isGather and Botany.HarvestOn)
    local statusText = ""
    
    if not moduleOn then
      statusText = "Disabled (Module Off)"
    elseif herb.enabled then
      statusText = "Enabled"
    else
      statusText = "Disabled"
    end
    
    local color = (herb.enabled and moduleOn) and "<botanyMain>" or "<botanyAlert>"
    local padding = string.rep(" ", 15 - string.len(herb.name))
    local paddedStatus = statusText .. string.rep(" ", 21 - string.len(statusText))
    
    cecho("<botanyText>  " .. herb.name .. padding .. "[ " .. color .. paddedStatus .. "<botanyText> ]\n")
  end
  cecho("<botanyAccent>==================================================\n")
end

-- =========================================================================
-- MODULE TOGGLER
-- =========================================================================
function Botany.toggleModule(modName)
  if modName == "butchery" then
    if not Botany.startButcher then
      Botany.echo("<botanyAlert>Error: <botanyText>Butchery module script is missing from your Mudlet package!")
      Botany.ButcheryOn = false
      return
    end
    Botany.ButcheryOn = not Botany.ButcheryOn
    local status = Botany.ButcheryOn and "<botanyMain>Enabled" or "<botanyAlert>Disabled"
    Botany.echo("Butchering Module: " .. status)
    
  elseif modName == "refining" then
    if not Botany.startRefine then
      Botany.echo("<botanyAlert>Error: <botanyText>Refining module script is missing from your Mudlet package!")
      Botany.RefiningOn = false
      return
    end
    Botany.RefiningOn = not Botany.RefiningOn
    local status = Botany.RefiningOn and "<botanyMain>Enabled" or "<botanyAlert>Disabled"
    Botany.echo("Refining Module: " .. status)
  end
  Botany.save()
end

-- =========================================================================
-- GATHERING LOGIC
-- =========================================================================
function Botany.gatherScan(isManual)
  if not Botany.GatherOn then return false end
  if Botany.Balance ~= 1 then
    if isManual then Botany.echo("Off Balance!") end
    return false
  end

  local rtype = gmcp.Room.Info.environment
  local found = false

  if rtype == "River" then 
    if Botany.Clay.Enabled then Botany.Clay.Gather = true; found = true end
  elseif rtype == "Ocean" then 
    if Botany.Saltwater.Enabled then Botany.Saltwater.Gather = true; found = true end
  elseif rtype == "Garden" then 
    if Botany.Fruit.Enabled then Botany.Fruit.Gather = true; found = true end
    if Botany.Vegetables.Enabled then Botany.Vegetables.Gather = true; found = true end
  elseif rtype == "Grasslands" then 
    if Botany.Grain.Enabled then Botany.Grain.Gather = true; found = true end
    if Botany.Sugarcane.Enabled then Botany.Sugarcane.Gather = true; found = true end
  elseif rtype == "Farm" then 
    if Botany.Farm.Enabled then Botany.Farm.Gather = true; found = true end
  elseif rtype == "Forest" then 
    if Botany.Nuts.Enabled then Botany.Nuts.Gather = true; found = true end
  elseif rtype == "Valley" then 
    if Botany.Olives.Enabled then Botany.Olives.Gather = true; found = true end
  elseif rtype == "Natural underground" then 
    if Botany.Lumic.Enabled then Botany.Lumic.Gather = true; found = true end
    if Botany.Dust.Enabled then Botany.Dust.Gather = true; found = true end
  elseif rtype == "Jungle" then 
    if Botany.Fruit.Enabled then Botany.Fruit.Gather = true; found = true end
    if Botany.Cacao.Enabled then Botany.Cacao.Gather = true; found = true end
  end

  if found then
    Botany.Gathering = true
    if isManual then Botany.echo("Attempting to gather in: " .. rtype .. "!") end
    Botany.gather()
    return true
  end
  return false
end

function Botany.gather()
  if Botany.Balance == 1 and Botany.GatherOn == true and Botany.Gathering == true then
    if Botany.Clay.Gather then Botany.GathTar = "Clay"; send("gather clay")
    elseif Botany.Saltwater.Gather then Botany.GathTar = "Saltwater"; send("gather saltwater into vial")
    elseif Botany.Fruit.Gather then Botany.GathTar = "Fruit"; send("gather fruit")
    elseif Botany.Vegetables.Gather then Botany.GathTar = "Vegetables"; send("gather vegetables")
    elseif Botany.Grain.Gather then Botany.GathTar = "Grain"; send("gather grain")
    elseif Botany.Sugarcane.Gather then Botany.GathTar = "Sugarcane"; send("gather sugarcane")
    elseif Botany.Farm.Gather then Botany.GathTar = "Farm"; send("gather from farm")
    elseif Botany.Nuts.Gather then Botany.GathTar = "Nuts"; send("gather nuts")
    elseif Botany.Olives.Gather then Botany.GathTar = "Olives"; send("gather olives")
    elseif Botany.Lumic.Gather then Botany.GathTar = "Lumic"; send("gather lumic")
    elseif Botany.Dust.Gather then Botany.GathTar = "Dust"; send("gather dust")
    elseif Botany.Cacao.Gather then Botany.GathTar = "Cacao"; send("gather cacao")
    else
      Botany.gatherFinished()
    end
  end
end

function Botany.gatherClear()
  local item = Botany.GathTar
  if item and Botany[item] then
    Botany[item].Gather = false
    Botany.gather()
  end
end

function Botany.gathered(amount)
  local item = Botany.GathTar
  if item and Botany[item] then Botany[item].Gather = false end
  Botany.trackStat(item, amount or 1)
end

function Botany.gatherFinished()
  Botany.Gathering = false
  Botany.echo("Finished Gathering!")
  send("inr all")
  Botany.markRoom()
end

function Botany.gatherToggle()
  Botany.GatherOn = not Botany.GatherOn
  local status = Botany.GatherOn and "<botanyMain>Enabled" or "<botanyAlert>Disabled"
  Botany.echo("Gathering Module: " .. status)
  Botany.save()
end

-- =========================================================================
-- HARVESTING LOGIC
-- =========================================================================
function Botany.harvested(amount)
  local plant = Botany.HarvTar
  if Botany[plant] then Botany[plant].Harvest = false end
  Botany.trackStat(plant, amount or 1)
end

function Botany.harvestClear()
  local plant = Botany.HarvTar
  if Botany[plant] then
    Botany[plant].Harvest = false
    Botany.harvest()
  else
    Botany.harvestFinished()
  end
end

function Botany.harvestFinished()
  if
    Botany.Ginseng.Harvest == false and Botany.Ash.Harvest == false and
    Botany.Echinacea.Harvest == false and Botany.Ginger.Harvest == false and
    Botany.Myrrh.Harvest == false and Botany.Bellwort.Harvest == false and
    Botany.Hawthorn.Harvest == false and Botany.Kuzu.Harvest == false and
    Botany.Skullcap.Harvest == false and Botany.Slipper.Harvest == false and
    Botany.Goldenseal.Harvest == false and Botany.Valerian.Harvest == false and
    Botany.Bayberry.Harvest == false and Botany.Cohosh.Harvest == false and
    Botany.Lobelia.Harvest == false and Botany.Pear.Harvest == false and
    Botany.Weed.Harvest == false and Botany.Irid.Harvest == false and
    Botany.Sileris.Harvest == false and Botany.Kelp.Harvest == false and
    Botany.Kola.Harvest == false and Botany.Elm.Harvest == false
  then
    Botany.Harvesting = false
    Botany.echo("Finished Harvesting!")
    send("inr all")
    
    -- Chain into gathering, if nothing gathered, safely mark the room
    if Botany.GatherOn then
      local startedGathering = Botany.gatherScan(false)
      if not startedGathering then Botany.markRoom() end
    else
      Botany.markRoom()
    end
  end
end

function Botany.harvest()
  if Botany.Balance == 1 and Botany.HarvestOn == true and Botany.Harvesting == true then
    if Botany.Ginseng.Harvest then Botany.HarvTar = "Ginseng"; send("harvest ginseng")
    elseif Botany.Lobelia.Harvest then Botany.HarvTar = "Lobelia"; send("harvest lobelia")
    elseif Botany.Ginger.Harvest then Botany.HarvTar = "Ginger"; send("harvest ginger")
    elseif Botany.Myrrh.Harvest then Botany.HarvTar = "Myrrh"; send("harvest myrrh")
    elseif Botany.Echinacea.Harvest then Botany.HarvTar = "Echinacea"; send("harvest echinacea")
    elseif Botany.Elm.Harvest then Botany.HarvTar = "Elm"; send("harvest elm")
    elseif Botany.Hawthorn.Harvest then Botany.HarvTar = "Hawthorn"; send("harvest hawthorn")
    elseif Botany.Bayberry.Harvest then Botany.HarvTar = "Bayberry"; send("harvest bayberry")
    elseif Botany.Ash.Harvest then Botany.HarvTar = "Ash"; send("harvest ash")
    elseif Botany.Bellwort.Harvest then Botany.HarvTar = "Bellwort"; send("harvest bellwort")
    elseif Botany.Cohosh.Harvest then Botany.HarvTar = "Cohosh"; send("harvest cohosh")
    elseif Botany.Kelp.Harvest then Botany.HarvTar = "Kelp"; send("harvest kelp")
    elseif Botany.Goldenseal.Harvest then Botany.HarvTar = "Goldenseal"; send("harvest goldenseal")
    elseif Botany.Slipper.Harvest then Botany.HarvTar = "Slipper"; send("harvest slipper")
    elseif Botany.Valerian.Harvest then Botany.HarvTar = "Valerian"; send("harvest valerian")
    elseif Botany.Sileris.Harvest then Botany.HarvTar = "Sileris"; send("harvest sileris")
    elseif Botany.Bloodroot.Harvest then Botany.HarvTar = "Bloodroot"; send("harvest bloodroot")
    elseif Botany.Irid.Harvest then Botany.HarvTar = "Irid"; send("harvest irid")
    elseif Botany.Weed.Harvest then Botany.HarvTar = "Weed"; send("harvest weed")
    elseif Botany.Pear.Harvest then Botany.HarvTar = "Pear"; send("harvest pear")
    elseif Botany.Skullcap.Harvest then Botany.HarvTar = "Skullcap"; send("harvest skullcap")
    elseif Botany.Kuzu.Harvest then Botany.HarvTar = "Kuzu"; send("harvest kuzu")
    elseif Botany.Kola.Harvest then Botany.HarvTar = "Kola"; send("harvest kola")
    end
  end
end

function Botany.harvestScan(isManual)
  if not Botany.HarvestOn then return false end
  if Botany.Balance ~= 1 then
    if isManual then Botany.echo("Off Balance!") end
    return false
  end

  local rtype = gmcp.Room.Info.environment
  local found = false

  if rtype == "Garden" or rtype == "Forest" then
    if Botany.Ginseng.Enabled then Botany.Ginseng.Harvest = true; found = true end
    if Botany.Echinacea.Enabled then Botany.Echinacea.Harvest = true; found = true end
    if Botany.Myrrh.Enabled then Botany.Myrrh.Harvest = true; found = true end
    if Botany.Ginger.Enabled then Botany.Ginger.Harvest = true; found = true end
    if Botany.Lobelia.Enabled then Botany.Lobelia.Harvest = true; found = true end
    if Botany.Elm.Enabled then Botany.Elm.Harvest = true; found = true end
  elseif rtype == "Hills" then 
    if Botany.Hawthorn.Enabled then Botany.Hawthorn.Harvest = true; found = true end
    if Botany.Bayberry.Enabled then Botany.Bayberry.Harvest = true; found = true end
  elseif rtype == "Swamp" then 
    if Botany.Ash.Enabled then Botany.Ash.Harvest = true; found = true end
    if Botany.Bellwort.Enabled then Botany.Bellwort.Harvest = true; found = true end
    if Botany.Cohosh.Enabled then Botany.Cohosh.Harvest = true; found = true end
  elseif rtype == "Freshwater" or rtype == "Ocean" then 
    if Botany.Kelp.Enabled then Botany.Kelp.Harvest = true; found = true end
  elseif rtype == "Grasslands" then 
    if Botany.Goldenseal.Enabled then Botany.Goldenseal.Harvest = true; found = true end
    if Botany.Slipper.Enabled then Botany.Slipper.Harvest = true; found = true end
  elseif rtype == "Mountains" then 
    if Botany.Valerian.Enabled then Botany.Valerian.Harvest = true; found = true end
  elseif rtype == "Valley" then 
    if Botany.Sileris.Enabled then Botany.Sileris.Harvest = true; found = true end
  elseif rtype == "Natural underground" then 
    if Botany.Bloodroot.Enabled then Botany.Bloodroot.Harvest = true; found = true end
    if Botany.Irid.Enabled then Botany.Irid.Harvest = true; found = true end
  elseif rtype == "Desert" then 
    if Botany.Weed.Enabled then Botany.Weed.Harvest = true; found = true end
    if Botany.Pear.Enabled then Botany.Pear.Harvest = true; found = true end
  elseif rtype == "Jungle" then 
    if Botany.Skullcap.Enabled then Botany.Skullcap.Harvest = true; found = true end
    if Botany.Kuzu.Enabled then Botany.Kuzu.Harvest = true; found = true end
    if Botany.Kola.Enabled then Botany.Kola.Harvest = true; found = true end
  end

  if found then
    Botany.Harvesting = true
    if isManual then Botany.echo("Attempting to harvest: " .. rtype .. " Herbs!") end
    Botany.harvest()
    return true
  end
  return false
end

function Botany.harvestToggle()
  Botany.HarvestOn = not Botany.HarvestOn
  local status = Botany.HarvestOn and "<botanyMain>Enabled" or "<botanyAlert>Disabled"
  Botany.echo("Harvesting Module: " .. status)
  Botany.save()
end

-- =========================================================================
-- SITUATIONAL ALERTS
-- =========================================================================
Botany.fishNames = {
  "trout", "salmon", "bass", "minnow", "koi", "pike", "carp"
}

Botany.reagentMobs = {
  "buffalo", "gour", "red scorpion", "yellow scorpion", "shark", "wyrm"
}

function Botany.checkRoomItems(event)
  if not Botany.HarvestOn and not Botany.GatherOn then return end
  
  local items = {}
  if event == "gmcp.Char.Items.List" and gmcp.Char.Items.List.location == "room" then
    items = gmcp.Char.Items.List.items
  elseif event == "gmcp.Char.Items.Add" and gmcp.Char.Items.Add.location == "room" then
    table.insert(items, gmcp.Char.Items.Add.item)
  else
    return
  end

  local foundEagle, foundSnake, foundReagentMob = false, false, false
  local reagentMobName = ""

  for _, item in ipairs(items) do
    local name = item.name:lower()
    local isDead = name:find("dead") or name:find("corpse")
    
    if Botany.HarvestOn then
      if name:find("eagle") and not isDead then foundEagle = true end
      if (name:find("snake") or name:find("sidewinder")) and isDead then foundSnake = true end
    end
    
    if Botany.GatherOn and not isDead then
      for _, mob in ipairs(Botany.reagentMobs) do
        if name:find(mob) then
          foundReagentMob = true; reagentMobName = item.name; break
        end
      end
      if not foundReagentMob then
        for _, fish in ipairs(Botany.fishNames) do
          if name:find(fish) then
            foundReagentMob = true; reagentMobName = item.name; break
          end
        end
      end
    end
  end

  if foundEagle then Botany.echo("<botanyMain>Notice:<botanyText> An eagle is here! You may be able to <botanyMain>PLUCK EAGLE<botanyText> for feathers.") end
  if foundSnake then Botany.echo("<botanyMain>Notice:<botanyText> A dead snake is here! You may be able to <botanyMain>HARVEST SKIN<botanyText>.") end
  if foundReagentMob then Botany.echo("<botanyMain>Notice:<botanyText> A " .. reagentMobName .. " is here! You can hunt it for butchery reagents.") end
end

-- =========================================================================
-- CORE SYSTEM & MEMORY LOGIC
-- =========================================================================
function Botany.reset()
  for k, v in pairs(Botany) do
    if type(v) == "table" and v.Harvest ~= nil then v.Harvest = false end
    if type(v) == "table" and v.Gather ~= nil then v.Gather = false end
  end
  Botany.Harvesting = false
  Botany.Gathering = false
  Botany.HarvestOn = false
  Botany.GatherOn = false
  Botany.HarvTar = "None"
  Botany.GathTar = "None"
  Botany.Balance = 1
  Botany.echo("Botany Values Forcibly Reset!")
end

function Botany.togglePlant(plant)
  if not plant or plant == "" then
    Botany.echo("<botanyAlert>Error: No plant/item specified!")
    return
  end
  plant = plant:sub(1,1):upper() .. plant:sub(2):lower()
  
  if Botany[plant] and type(Botany[plant]) == "table" and Botany[plant].Enabled ~= nil then
    Botany[plant].Enabled = not Botany[plant].Enabled
    local status = Botany[plant].Enabled and "<botanyMain>Enabled" or "<botanyAlert>Disabled"
    Botany.echo(plant .. " has been " .. status)
  else
    Botany.echo("<botanyAlert>Error: '" .. plant .. "' is not a valid botany item!")
  end
end

function Botany.markRoom()
  if not gmcp.Room or not gmcp.Room.Info then return end
  local roomID = tostring(gmcp.Room.Info.num)
  local areaName = gmcp.Room.Info.area
  Botany.Memory[areaName] = Botany.Memory[areaName] or { timestamp = os.time(), rooms = {} }
  Botany.Memory[areaName].rooms[roomID] = true
  Botany.Memory[areaName].timestamp = os.time()
  Botany.save()
end

function Botany.onRoom()
  if (not Botany.HarvestOn and not Botany.GatherOn) or not gmcp.Room or not gmcp.Room.Info then return end

  local roomID = tostring(gmcp.Room.Info.num)
  local areaName = gmcp.Room.Info.area
  local areaMem = Botany.Memory[areaName]
  
  if areaMem then
    local hoursElapsed = (os.time() - areaMem.timestamp) / 3600
    if hoursElapsed >= Botany.GlobalExpiration then
      Botany.Memory[areaName] = nil
      areaMem = nil
    end
  end

  local roomHarvested = false
  if areaMem and areaMem.rooms[roomID] then
    roomHarvested = true
    local daysElapsed = math.floor((os.time() - areaMem.timestamp) / 3600)
    
    local msg = daysElapsed == 0 
      and "You recall harvesting in this area less than a day ago." 
      or string.format("You recall harvesting in this area about %d days ago.", daysElapsed)
      
    if Botany.recallTrigger then killTrigger(Botany.recallTrigger) end
    Botany.recallTrigger = tempRegexTrigger("^(?:You see exits leading|You see a single exit leading|There are no obvious exits\\.|\\[ Exits:).*", function()
      cecho("\n<botanyMain>" .. msg .. "<reset>")
      killTrigger(Botany.recallTrigger)
      Botany.recallTrigger = nil
    end, 1)
    
    tempTimer(0.2, function()
      if Botany.recallTrigger then
        cecho("\n<botanyMain>" .. msg .. "<reset>\n")
        killTrigger(Botany.recallTrigger)
        Botany.recallTrigger = nil
      end
    end)
  end

  if Botany.AutoMode then
    if Botany.LastRoom ~= roomID then
      Botany.LastRoom = roomID
      if not roomHarvested then
        tempTimer(0.5, function()
          Botany.scan(false)
        end)
      end
    end
  end
end

function Botany.toggleAuto()
  Botany.AutoMode = not Botany.AutoMode
  local status = Botany.AutoMode and "<botanyMain>Enabled" or "<botanyAlert>Disabled"
  Botany.echo("Auto-Mode: " .. status)
  Botany.save()
end

function Botany.setExpiration(hours)
  local numHours = tonumber(hours)
  if numHours and numHours > 0 then
    Botany.GlobalExpiration = numHours
    Botany.echo("Area expiration timer set to <botanyMain>" .. numHours .. "<botanyText> real-life hours.")
    Botany.save()
  else
    Botany.echo("<botanyAlert>Error: Please provide a valid number of hours.")
  end
end

function Botany.save()
  local baseDir = getMudletHomeDir() .. "/Botany"
  if not lfs.attributes(baseDir, "mode") then lfs.mkdir(baseDir) end
  
  local exportData = {
    HarvestOn = Botany.HarvestOn,
    GatherOn = Botany.GatherOn,
    ButcheryOn = Botany.ButcheryOn,
    RefiningOn = Botany.RefiningOn,
    AutoMode = Botany.AutoMode,
    GlobalExpiration = Botany.GlobalExpiration,
    Memory = Botany.Memory,
    CleaverID = Botany.CleaverID,
    CleaverContainer = Botany.CleaverContainer,
    LifetimeStats = Botany.Stats.Lifetime       -- ADD THIS LINE
  }
  
  local allItems = {
    "Ginseng", "Ash", "Echinacea", "Ginger", "Myrrh", "Bellwort", "Bloodroot", 
    "Hawthorn", "Kuzu", "Skullcap", "Slipper", "Goldenseal", "Valerian", "Bayberry", 
    "Cohosh", "Lobelia", "Pear", "Weed", "Irid", "Sileris", "Kelp", "Kola", "Elm"
  }
  for _, item in ipairs(Botany.gatherItems) do table.insert(allItems, item) end
  
  for _, item in ipairs(allItems) do
    if Botany[item] then exportData[item] = {Enabled = Botany[item].Enabled} end
  end

  local filepath = baseDir .. "/Botany_Profile.json"
  local file = io.open(filepath, "w")
  if file then
    file:write(yajl.to_string(exportData))
    file:close()
  end
end

function Botany.load()
  local filepath = getMudletHomeDir() .. "/Botany/Botany_Profile.json"
  local file = io.open(filepath, "r")
  if not file then return end 
  
  local contents = file:read("*a")
  file:close()
  
  local success, data = pcall(yajl.to_value, contents)
  if success and type(data) == "table" then
    if data.HarvestOn ~= nil then Botany.HarvestOn = data.HarvestOn end
    if data.GatherOn ~= nil then Botany.GatherOn = data.GatherOn end
    if data.ButcheryOn ~= nil then Botany.ButcheryOn = data.ButcheryOn end
    if data.RefiningOn ~= nil then Botany.RefiningOn = data.RefiningOn end
    if data.AutoMode ~= nil then Botany.AutoMode = data.AutoMode end
    if data.GlobalExpiration ~= nil then Botany.GlobalExpiration = data.GlobalExpiration end
    if data.Memory ~= nil then Botany.Memory = data.Memory end
    if data.LifetimeStats ~= nil then Botany.Stats.Lifetime = data.LifetimeStats end -- ADD THIS LINE
    if data.CleaverID ~= nil then Botany.CleaverID = data.CleaverID end             -- Added
    if data.CleaverContainer ~= nil then Botany.CleaverContainer = data.CleaverContainer end -- Added
    
    local allItems = {
        "Ginseng", "Ash", "Echinacea", "Ginger", "Myrrh", "Bellwort", "Bloodroot", 
        "Hawthorn", "Kuzu", "Skullcap", "Slipper", "Goldenseal", "Valerian", "Bayberry", 
        "Cohosh", "Lobelia", "Pear", "Weed", "Irid", "Sileris", "Kelp", "Kola", "Elm"
    }
    for _, item in ipairs(Botany.gatherItems) do table.insert(allItems, item) end
    
    for _, item in ipairs(allItems) do
      if data[item] and data[item].Enabled ~= nil then
        Botany[item] = Botany[item] or {}
        Botany[item].Enabled = data[item].Enabled
      end
    end
    Botany.echo("<botanyMain>Loaded Botany Configuration.")
  end
end

function Botany.updateBal()
  Botany.Balance = tonumber(gmcp.Char.Vitals.bal)
end

-- =========================================================================
-- MASTER SCAN
-- =========================================================================
function Botany.scan(isManual)
  local rtype = gmcp.Room.Info and gmcp.Room.Info.environment or "Unknown"
  local started = false
  
  if Botany.HarvestOn then
     started = Botany.harvestScan(isManual)
  end

  if not started and Botany.GatherOn then
     started = Botany.gatherScan(isManual)
  end

  if not started and isManual then
    if Botany.HarvestOn or Botany.GatherOn then
        Botany.echo("<botanyAlert>Notice: <botanyText>Nothing enabled to collect in this environment (<botanyMain>" .. rtype .. "<botanyText>).")
    else
        Botany.echo("<botanyAlert>Notice: <botanyText>Both Harvesting and Gathering are disabled. Turn one on to scan.")
    end
  end
end

-- =========================================================================
-- STAT TRACKER
-- =========================================================================
Botany.Stats = Botany.Stats or { Session = {}, Lifetime = {} }

function Botany.trackStat(item, amount)
  if not item or item == "None" then return end
  
  -- Clean up the item name (capitalize first letter, lowercase rest)
  item = item:sub(1,1):upper() .. item:sub(2):lower()
  amount = tonumber(amount) or 1
  
  Botany.Stats.Session[item] = (Botany.Stats.Session[item] or 0) + amount
  Botany.Stats.Lifetime[item] = (Botany.Stats.Lifetime[item] or 0) + amount
end

function Botany.showStats(scope)
  scope = scope and scope:lower() == "lifetime" and "Lifetime" or "Session"
  
  cecho("\n<botanyAccent>==================================================\n")
  cecho("<botanyAccent>             BOTANY STATS: <botanyMain>" .. scope:upper() .. "\n")
  cecho("<botanyAccent>==================================================\n")
  
  local data = Botany.Stats[scope]
  local hasData = false
  local sortedKeys = {}
  
  for k, _ in pairs(data) do table.insert(sortedKeys, k) end
  table.sort(sortedKeys)
  
  for _, k in ipairs(sortedKeys) do
      hasData = true
      local padding = string.rep(" ", 20 - string.len(k))
      cecho("<botanyText>  " .. k .. padding .. ": <botanyMain>" .. data[k] .. "\n")
  end
  
  if not hasData then
      cecho("<botanyText>  No stats recorded for this " .. scope:lower() .. " yet.\n")
  end
  cecho("<botanyAccent>==================================================\n")
end

-- =========================================================================
-- MASTER COMMAND HANDLER
-- =========================================================================
function Botany.handleCommand(args_str)
  local args = args_str:split(" ")
  local cmd = args[1] and args[1]:lower() or ""

  if cmd == "" then Botany.display()
  elseif cmd == "help" then Botany.help()
  elseif cmd == "harvesting" then Botany.harvestToggle()
  elseif cmd == "gathering" then Botany.gatherToggle()
  elseif cmd == "butchering" then Botany.toggleModule("butchery")
  elseif cmd == "refining" then Botany.toggleModule("refining")
  elseif cmd == "auto" then Botany.toggleAuto()
  elseif cmd == "expiration" then Botany.setExpiration(args[2])
  elseif cmd == "scan" then Botany.scan(true)
  elseif cmd == "show" then Botany.showTable()
  elseif cmd == "toggle" then Botany.togglePlant(args[2])
  elseif cmd == "reset" then Botany.reset()
  elseif cmd == "show" then Botany.showTable()
  elseif cmd == "stats" then Botany.showStats(args[2]) -- ADD THIS LINE
  elseif cmd == "toggle" then Botany.togglePlant(args[2])
  elseif cmd == "cleaver" then 
    Botany.CleaverID = args[2]
    Botany.echo("Cleaver set to ID: <botanyMain>" .. tostring(args[2]))
    Botany.save()
  elseif cmd == "container" then 
    Botany.CleaverContainer = args[2] == "none" and nil or args[2]
    Botany.echo("Cleaver Container set to: <botanyMain>" .. tostring(args[2]))
    Botany.save()
  elseif cmd == "stop" then
    if Botany.IsButchering and Botany.stopButcher then Botany.stopButcher(false) end
    if Botany.IsRefining and Botany.stopRefine then Botany.stopRefine(false) end
    Botany.echo("All active automated tasks have been halted.")
  elseif cmd == "butcher" then
    if Botany.ButcheryOn and Botany.startButcher then Botany.startButcher(args[2])
    else Botany.echo("<botanyAlert>Error: <botanyText>Butchering module is disabled or missing. Type 'bot butchering' to enable.") end
  elseif cmd == "refine" then
    if Botany.RefiningOn and Botany.startRefine then Botany.startRefine(args[2], args[3])
    else Botany.echo("<botanyAlert>Error: <botanyText>Refining module is disabled or missing. Type 'bot refining' to enable.") end
  else 
    cecho("\n<botanyText>[<botanyMain>Botany<botanyText>]: Unknown command. Try <botanyMain>bot help<botanyText>.\n")
  end
end

-- =========================================================================
-- INITIALIZATION & TRIGGERS
-- =========================================================================
Botany.trigger_ids = Botany.trigger_ids or {}
Botany.alias_ids = Botany.alias_ids or {}
Botany.event_ids = Botany.event_ids or {}

function Botany.createTriggers()
  for _, id in pairs(Botany.trigger_ids) do killTrigger(id) end
  for _, id in pairs(Botany.alias_ids) do killAlias(id) end
  Botany.trigger_ids = {}
  Botany.alias_ids = {}

  table.insert(Botany.alias_ids, tempAlias("^(?i)(?:bot|botany)(?:\\s+(.*))?$", [[
      local args_str = matches[2] or ""
      Botany.handleCommand(args_str)
  ]]))
  table.insert(Botany.trigger_ids, tempRegexTrigger("^Password correct\\. Welcome to Achaea\\.$", [[Botany.init()]]))
  table.insert(Botany.trigger_ids, tempRegexTrigger("^You reach out and carefully harvest (\\d+)", [[
      Botany.harvested(matches[2])
      Botany.gathered(matches[2])
  ]]))
  table.insert(Botany.trigger_ids, tempRegexTrigger("^You have already harvested from this plant recently\\.$", [[Botany.harvestClear()]]))
  table.insert(Botany.trigger_ids, tempRegexTrigger("^That plant has been fully harvested\\.$", [[Botany.harvestClear()]]))
  table.insert(Botany.trigger_ids, tempRegexTrigger("^What do you wish to harvest", [[Botany.harvestClear()]]))
  table.insert(Botany.trigger_ids, tempRegexTrigger("^You gather some .+\\.$", [[Botany.gathered()]]))
  table.insert(Botany.trigger_ids, tempRegexTrigger("^You fill the vial with saltwater\\.$", [[Botany.gathered()]]))
  table.insert(Botany.trigger_ids, tempRegexTrigger("^You pick .+\\.$", [[Botany.gathered()]]))
  table.insert(Botany.ButcherTriggers, tempRegexTrigger("^You skilfully butcher the corpse.*yielding (\\d+) (.+)\\.$", [[
        Botany.trackStat(matches[3], matches[2])
    ]]))
  table.insert(Botany.trigger_ids, tempRegexTrigger("(?i)^There is nothing here to gather\\.$", [[Botany.gatherClear()]]))
  table.insert(Botany.trigger_ids, tempRegexTrigger("(?i)^You can find no more .+ here\\.$", [[Botany.gatherClear()]]))
  table.insert(Botany.trigger_ids, tempRegexTrigger("(?i)^There is no .+ here to gather\\.$", [[Botany.gatherClear()]]))
  table.insert(Botany.trigger_ids, tempRegexTrigger("(?i)^You cannot gather anything here\\.$", [[Botany.gatherClear()]]))
  table.insert(Botany.trigger_ids, tempRegexTrigger("(?i)^There is no .+ here\\.$", [[Botany.gatherClear()]]))
  table.insert(Botany.trigger_ids, tempRegexTrigger("(?i)^What do you wish to gather", [[Botany.gatherClear()]]))
  table.insert(Botany.trigger_ids, tempRegexTrigger("(?i)^You have already gathered from th(?:is|at) plant recently\\.$", [[Botany.gatherClear()]]))
  table.insert(Botany.trigger_ids, tempRegexTrigger("(?i)^You carefully search the cracks and crevices of the surrounding rock, but find nothing\\.$", [[Botany.gatherClear()]]))
  table.insert(Botany.trigger_ids, tempRegexTrigger("^You have recovered balance on all limbs\\.$", [[
    if Botany.Harvesting then Botany.harvest(); Botany.harvestFinished()
    elseif Botany.Gathering then Botany.gather() end
  ]]))
  table.insert(Botany.trigger_ids, tempPromptTrigger([[
    if (Botany.HarvestOn and Botany.Harvesting) or (Botany.GatherOn and Botany.Gathering) then
      cecho("<botanyText>(<botanyMain>Botany<botanyText>)<reset> ")
    end
  ]]))
end

function Botany.init()
  Botany.load()
  for _, id in pairs(Botany.event_ids) do killAnonymousEventHandler(id) end
  Botany.event_ids = {}

  Botany.createTriggers()
  
  local reg = function(event, func)
    table.insert(Botany.event_ids, registerAnonymousEventHandler(event, func))
  end
  
  reg("gmcp.Char.Vitals", "Botany.updateBal")
  reg("sysDisconnectionEvent", "Botany.save")
  reg("sysExitEvent", "Botany.save")
  reg("gmcp.Room.Info", "Botany.onRoom")
  reg("gmcp.Char.Items.List", "Botany.checkRoomItems")
  reg("gmcp.Char.Items.Add", "Botany.checkRoomItems")
  
  Botany.echo("System Initialized.")
end

Botany.init()