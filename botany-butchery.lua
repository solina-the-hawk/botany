-- =========================================================================
-- BOTANY EXTENSION: Butchery Module
-- A dynamic extension for the Botany collection system.
-- Author: Solina (https://github.com/solina-the-hawk/Botany/)
-- Version: 1.0.0
-- =========================================================================

Botany = Botany or {}
Botany.ButcheryQueue = {}
Botany.IsButchering = false
Botany.ButcherTriggers = Botany.ButcherTriggers or {}

function Botany.startButcher(mode)
  mode = mode and mode:lower() or ""
  if mode == "reagent" then mode = "reagents" end
  if mode == "skin" then mode = "skins" end

  if mode ~= "meat" and mode ~= "skins" and mode ~= "reagents" then
    Botany.echo("<botanyAlert>Error: <botanyText>Please specify meat, skins, or reagents. (e.g., 'bot butcher meat')")
    return
  end

  Botany.butcherMode = mode
  Botany.IsButchering = false 
  Botany.echo("Scanning inventory for corpses to butcher for " .. mode .. "...")
  sendGMCP('Char.Items.Inv ""')
end

function Botany.onItemsListButchery()
  if gmcp.Char.Items.List.location == "inv" and Botany.butcherMode then
    Botany.ButcheryQueue = {}
    local reagent_keywords = {"scorpion", "squid", "fish", "shark", "buffalo", "wyrm"}

    for _, item in ipairs(gmcp.Char.Items.List.items) do
      if item.name:lower():find("corpse") then
        local is_reagent_mob = false
        for _, kw in ipairs(reagent_keywords) do
          if item.name:lower():find(kw) then is_reagent_mob = true; break end
        end

        if Botany.butcherMode == "reagents" then
          if is_reagent_mob then table.insert(Botany.ButcheryQueue, item.id) end
        else
          table.insert(Botany.ButcheryQueue, item.id)
        end
      end
    end

    if #Botany.ButcheryQueue == 0 then
      Botany.echo("No suitable corpses found in your inventory for " .. Botany.butcherMode .. ".")
      Botany.butcherMode = nil
      return
    end

    Botany.echo("Found <botanyMain>" .. #Botany.ButcheryQueue .. "<botanyText> corpse(s). Initiating butchery loop...")
    Botany.IsButchering = true
    Botany.ActiveButcherMode = Botany.butcherMode
    Botany.butcherMode = nil

    -- Handle Cleaver Wielding
    if Botany.CleaverID then
        if Botany.CleaverContainer then
            send("queue add eqbal get " .. Botany.CleaverID .. " from " .. Botany.CleaverContainer)
        end
        send("queue add eqbal wield " .. Botany.CleaverID)
    end

    Botany.doNextButcher()
  end
end

function Botany.doNextButcher()
  if not Botany.IsButchering then return end

  if #Botany.ButcheryQueue == 0 then
    Botany.stopButcher(true)
    return
  end

  local id = table.remove(Botany.ButcheryQueue, 1)
  local cmd = "butcher " .. id
  if Botany.ActiveButcherMode == "skins" then cmd = cmd .. " for skins"
  elseif Botany.ActiveButcherMode == "reagents" then cmd = cmd .. " for reagent"
  elseif Botany.ActiveButcherMode == "meat" then cmd = cmd .. " for meat"
  end

  send("queue add eqbal " .. cmd)
end

function Botany.stopButcher(finished)
    if not Botany.IsButchering then return end
    Botany.IsButchering = false
    Botany.ButcheryQueue = {}
    
    send("clearqueue all")

    if finished then 
        Botany.echo("Finished butchering all corpses.")
    else 
        Botany.echo("<botanyAlert>Butchering sequence cancelled.") 
    end

    -- Clean up Cleaver
    if Botany.CleaverID then
        send("queue add eqbal unwield " .. Botany.CleaverID)
        if Botany.CleaverContainer then
            send("queue add eqbal put " .. Botany.CleaverID .. " in " .. Botany.CleaverContainer)
        end
    end
    send("queue add eqbal inr all")
end

function Botany.initButcheryTriggers()
    for _, id in pairs(Botany.ButcherTriggers) do killTrigger(id) end
    Botany.ButcherTriggers = {}

    -- Progress on balance
    table.insert(Botany.ButcherTriggers, tempRegexTrigger("^You have recovered balance on all limbs\\.$", [[
        if Botany.IsButchering then Botany.doNextButcher() end
    ]]))
    
    -- Bypass stalled failures, mutilations, and empty inventories
    table.insert(Botany.ButcherTriggers, tempRegexTrigger("^(You cannot butcher that|That corpse is too degraded|What do you wish to butcher|As you set about butchering the corpse|You have no corpse suitable).*$", [[
        if Botany.IsButchering then Botany.doNextButcher() end
    ]]))
end

if Botany.butcheryHandler then killAnonymousEventHandler(Botany.butcheryHandler) end
Botany.butcheryHandler = registerAnonymousEventHandler("gmcp.Char.Items.List", "Botany.onItemsListButchery")
Botany.initButcheryTriggers()