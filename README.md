# Botany
**A comprehensive, modular environmental collection system for Achaea and Mudlet.**

Botany is a robust upgrade and complete refactor of legacy harvesting scripts. It manages the collection of herbs, commodities, and butchery reagents, organizing them into a smart, environment-aware automation system so you can maximize your yields while traveling across the continent.

Unlike older systems, Botany utilizes a smart JSON-based memory ledger to remember exactly where you have harvested and prevents redundant tracking, all without relying on external dependencies.

---
## Features

* **Smart Environment Scanning:** Automatically detects your room's environment via GMCP and queues the exact commands needed to gather or harvest available plants and commodities.
* **Area Memory Ledger:** Silently tracks which areas you have harvested and automatically expires them after a configurable amount of real-life hours. Prints a clean, non-intrusive reminder above your prompt when you enter a previously harvested room.
* **Modular Architecture:** Only load what you need. Includes modular extensions for **Butchering** (corpses, skins, reagents) and **Refining** (salt, sugar, oil, etc.).
* **Situational Alerts:** Passively monitors your environment and alerts you when rare, harvestable creatures (like eagles, sidewinders, or reagent-dropping fish and scorpions) enter the room.
* **Auto-Mode:** Enable Auto-Mode to have Botany silently scan and collect resources every time you walk into a new, unharvested room.
* **Safe Profile Storage:** Saves your configuration and memory ledger to a local JSON file, ensuring your data is never wiped out during a script reload or Mudlet update.

---
## Installation

1. Download the `Botany.mpackage` and install it via Mudlet's Package Manager, OR import the scripts directly into your Mudlet Script Editor.
2. Save the scripts. The system will initialize automatically.
3. Edit the `Botany.config` block at the top of the core script to adjust your thematic colors.
4. Type `bot help` in the game for a list of helpful commands!

---
## Usage & Commands

Botany uses the `bot` (or `botany`) prefix for all commands.

* `bot harvesting` - Toggle herb harvesting on/off.
* `bot gathering` - Toggle commodity gathering on/off.
* `bot auto` - Toggle auto-scan on movement.
* `bot show` - Display your configuration and see which plants are enabled/disabled.
* `bot toggle <plant>` - Manually enable or disable a specific plant or commodity.
* `bot butcher <type>` - Automatically butcher all valid corpses in your inventory for meat, skins, or reagents.
* `bot refine <item> <amount>` - Automatically pulls raw materials from your rift, refines them, and stashes the products.
