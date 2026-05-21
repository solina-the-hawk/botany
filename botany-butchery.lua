-- =========================================================================
-- BOTANY EXTENSION: Butchery Module
-- A dynamic extension for the Botany collection system.
-- Author: Solina (https://github.com/solina-the-hawk/Botany/)
-- Version: 1.0.0
-- =========================================================================

Botany = Botany or {}

function Botany.startButcher(mode)
  mode = mode and mode:lower() or ""
  if mode == "reagent" then mode = "reagents" end
  if mode == "skin" then mode = "skins" end

  if mode ~= "meat" and mode ~= "skins" and mode ~= "reagents" then
    Botany.echo("<botanyAlert>Error: <botanyText>Please specify meat, skins, or reagents. (e.g., 'bot butcher meat')")
    return
  end

  Botany.butcherMode = mode
  Botany.echo("Scanning inventory for corpses to butcher for " .. mode .. "...")
  sendGMCP('Char.Items.Inv ""')
end

function Botany.onItemsListButchery()
  if gmcp.Char.Items.List.location == "inv" and Botany.butcherMode then
    local corpses = {}
    local reagent_keywords = {"scorpion", "squid", "fish", "shark", "buffalo", "wyrm"}

    for _, item in ipairs(gmcp.Char.Items.List.items) do
      if item.name:lower():find("corpse") then
        local is_reagent_mob = false
        for _, kw in ipairs(reagent_keywords) do
          if item.name:lower():find(kw) then is_reagent_mob = true; break end
        end

        if Botany.butcherMode == "reagents" then
          if is_reagent_mob then table.insert(corpses, item.id) end
        else
          table.insert(corpses, item.id)
        end
      end
    end

    if #corpses == 0 then
      Botany.echo("No suitable corpses found in your inventory for " .. Botany.butcherMode .. ".")
      Botany.butcherMode = nil
      return
    end

    for _, id in ipairs(corpses) do
      local cmd = "butcher " .. id
      if Botany.butcherMode == "skins" then cmd = cmd .. " for skins"
      elseif Botany.butcherMode == "reagents" then cmd = cmd .. " for reagent"
      elseif Botany.butcherMode == "meat" then cmd = cmd .. " for meat"
      end
      send("queue add eqbal " .. cmd)
    end

    send("queue add eqbal inr all")
    Botany.echo("Queued butchering for <botanyMain>" .. #corpses .. "<botanyText> corpse(s) and rifting ingredients.")
    Botany.butcherMode = nil
  end
end

if Botany.butcheryHandler then killAnonymousEventHandler(Botany.butcheryHandler) end
Botany.butcheryHandler = registerAnonymousEventHandler("gmcp.Char.Items.List", "Botany.onItemsListButchery")