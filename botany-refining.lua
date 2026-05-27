-- =========================================================================
-- BOTANY EXTENSION: Refining Module
-- A dynamic extension for the Botany collection system.
-- Author: Solina (https://github.com/solina-the-hawk/Botany/)
-- Version: 1.0.0
-- =========================================================================

Botany = Botany or {}
Botany.IsRefining = false
Botany.RefiningTarget = ""
Botany.RefiningAmount = 0
Botany.RefinedCount = 0
Botany.RefiningTriggers = Botany.RefiningTriggers or {}

Botany.RefiningMap = {
    salt      = {source = "saltwater", vial = false},
    sugar     = {source = "sugarcane", vial = false},
    flour     = {source = "grain",     vial = false},
    oil       = {source = "olives",    vial = true},
    spices    = {source = "seeds",     vial = false},
    chocolate = {source = "cacao",     vial = false}
}

function Botany.startRefine(target, amount)
    target = target and target:lower() or ""
    
    local refData = Botany.RefiningMap[target]
    if not refData then
        Botany.echo("<botanyAlert>Error: <botanyText>Unknown target. Valid targets: salt, sugar, flour, oil, spices, chocolate.")
        return
    end

    Botany.RefiningTarget = target
    
    if not amount or amount:lower() == "all" then 
        Botany.RefiningAmount = math.huge
        Botany.echo("Initiating continuous refining loop for " .. target .. " from " .. refData.source .. ".")
    else 
        Botany.RefiningAmount = tonumber(amount) or 1 
        Botany.echo("Queueing <botanyMain>" .. Botany.RefiningAmount .. "<botanyText>x refinement for " .. target .. " from " .. refData.source .. ".")
    end
    
    Botany.RefinedCount = 0
    Botany.IsRefining = true
    Botany.doNextRefine()
end

function Botany.doNextRefine()
    if not Botany.IsRefining then return end
    
    if Botany.RefinedCount >= Botany.RefiningAmount then
        Botany.stopRefine(true)
        return
    end

    local refData = Botany.RefiningMap[Botany.RefiningTarget]
    
    send("queue add eqbal outr 1 " .. refData.source)
    
    local cmd = "refine for " .. Botany.RefiningTarget
    if refData.vial then cmd = cmd .. " into vial" end
    send("queue add eqbal " .. cmd)
    
    Botany.RefinedCount = Botany.RefinedCount + 1
end

function Botany.stopRefine(finished)
    if not Botany.IsRefining then return end
    Botany.IsRefining = false
    send("clearqueue all")
    
    if finished then 
        Botany.echo("Finished refining task.")
    else 
        Botany.echo("<botanyAlert>Refining sequence cancelled.") 
    end
    send("queue add eqbal inr all")
end

function Botany.initRefiningTriggers()
    for _, id in pairs(Botany.RefiningTriggers) do killTrigger(id) end
    Botany.RefiningTriggers = {}

    table.insert(Botany.RefiningTriggers, tempRegexTrigger("^You have recovered balance on all limbs\\.$", [[
        if Botany.IsRefining then Botany.doNextRefine() end
    ]]))
    
    -- Stop gracefully if out of base commodities
    table.insert(Botany.RefiningTriggers, tempRegexTrigger("^(You do not have any|You have no|You cannot refine).*$", [[
        if Botany.IsRefining then Botany.stopRefine(true) end
    ]]))
end

Botany.initRefiningTriggers()