-- =========================================================================
-- BOTANY EXTENSION: Refining Module
-- A dynamic extension for the Botany collection system.
-- Author: Solina (https://github.com/solina-the-hawk/Botany/)
-- Version: 1.0.0
-- =========================================================================

Botany = Botany or {}
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
    amount = tonumber(amount) or 1
    
    local refData = Botany.RefiningMap[target]
    if not refData then
        Botany.echo("<botanyAlert>Error: <botanyText>Unknown target. Valid targets: salt, sugar, flour, oil, spices, chocolate.")
        return
    end
    
    Botany.echo("Queueing <botanyMain>" .. amount .. "<botanyText>x refinement for " .. target .. " from " .. refData.source .. ".")
    
    send("queue add eqbal outr " .. amount .. " " .. refData.source)
    
    for i = 1, amount do
        local cmd = "refine for " .. target
        if refData.vial then cmd = cmd .. " into vial" end
        send("queue add eqbal " .. cmd)
    end
    
    send("queue add eqbal inr all")
end