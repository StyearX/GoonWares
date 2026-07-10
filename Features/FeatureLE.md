# GoonWares | Evade — Feature List

A complete overview of every feature available in the script, organized by tab.

---

## Main

### Nextbot ESP *(collapsible section, red)*
- Billboard Nextbots — floating name tag above every nextbot
- Tracer Nextbots — draws a line from your screen to every nextbot
- Box ESP — highlight/box outline around nextbots
- Box Model — choose between 2D (highlight) and 3D (wireframe box) style

### Survivor ESP *(collapsible section, blue)*
- Billboard Survivors — floating name tag above every survivor
- Tracer Survivors — draws a line from your screen to every survivor
- Box ESP — highlight/box outline around survivors
- Box Model — choose between 2D (highlight) and 3D (wireframe box) style

### Downed Player ESP *(collapsible section, green)*
- Downed Billboard — floating "DOWNED" tag above any downed survivor
- Box ESP — highlight/box outline specifically for downed survivors
- Box Model — choose between 2D (highlight) and 3D (wireframe box) style

### Game Modification
- Auto Respawn — automatically respawns you on a loop
- Respawn (Button) — spawns a floating button that respawns you on click
- Force Respawn — manual one-click respawn action
- Respawn Type — choose between Spawnpoint or Fake Revive

### Whistle
- Auto Whistle — automatically uses the whistle ability on a loop

### Alternative Settings
- Anti-AFK — prevents being kicked for inactivity
- Disable Camera Shake — removes camera shake effects
- Quick Revive — shortens the revive time for downed survivors

### Map Modification
- Remove Damage Objects — removes map hazards that deal damage
- Remove Invisible Walls — heuristically detects and destroys invisible/transparent blocking parts (excludes player characters and known gameplay geometry), with real-time detection for newly spawned parts plus a periodic safety-net scan and an **R** keybind for manual re-scan

### Player Modification
- Noclip — walk through walls and obstacles
- Fly (Button) — spawns a floating button that toggles free-flight movement (Keybind supported)
- Fly Speed — adjustable flight speed

### TAS (Tool-Assisted Speedrun)
- Play Mode — choose Single or Loop playback
- Show Rec Button — floating button to start/stop recording your movement (Keybind supported)
- Show Clear Button — floating button to clear the current recording (Keybind supported)
- Show Play Button — floating button to play back the recorded movement (Keybind supported)

---

## Anti Nextbots

### Nextbot Modification
- Anti Nextbot Toggle — teleports you away when a nextbot gets too close
- Anti Nextbot Teleport Type — choose teleport destination (Spawn or Players)
- Anti Nextbot Distance — adjustable trigger distance

---

## Movement

### Player Adjustments
- Player Speed — adjustable walk speed
- Player Jump — adjustable jump power
- Player Strafe Acceleration — adjustable strafing acceleration

### Walkspeed
- Walkspeed Toggle — enables the custom walkspeed override
- Player Walkspeed — adjustable walkspeed value

### Utilities
- Lag Switch (Button) — spawns a floating button that manually triggers a lag switch (Keybind: **F12**)
- Delay MS — adjustable lag switch delay
- Lag Mode — choose between Normal, Demon, or FastFlag lag methods

### Bounce Modification
- Modify Bounce — overrides emote/bounce launch values
- Player Bounce — adjustable player bounce strength
- Emote Bounce — adjustable emote bounce strength

### Easy Bounce
- Easy Bounce Mode — choose Forward or Back bounce direction
- Base Speed — adjustable base bounce speed
- Extra Speed (Boost) — adjustable extra bounce boost
- Easy Bounce (Button) — spawns a floating button that toggles Easy Bounce (Keybind supported)

### Platform Spawner
- Cactus Platform — spawns a temporary platform beneath you
- Platform Transparency (0–1) — adjustable platform transparency
- Platform Size — adjustable platform size

### Camera Adjustment
- Stretch — adjustable camera stretch value
- Player FOV — adjustable field of view (default 100, min 30 / max 120)

### Game Automations
- Macro Button Toggle — enables the Emote/Crouch macro floating buttons (Keybind supported, Crouch/Uncrouch bound to **Ctrl** by default)
- Select Emote Slots — dropdown (search-enabled) to choose which emote slot to use

### Movement Modification
- Aggressive Emote Dash — automatically dashes using an emote for extra speed
- Aggressive Emote Type — choose Legit or Blatant dash style
- Aggressive Emote Speed — adjustable dash speed
- Aggressive Emote Acceleration (Negative Only) — fine-tune negative acceleration for the dash

### Emote Movement
- Modify Emote Movement — overrides emote rotation behavior for movement tricks
- Emote Rotation Speed — adjustable rotation speed

### Gravity
- Gravity Button — spawns a floating button that toggles custom gravity (Keybind supported)
- Gravity Adjustment — adjustable gravity value

### BHOP / Auto Jump
- BHOP (Button) — spawns a floating button that toggles bunny-hop auto jump (Keybind supported)
- BHOP (Jump Button) — touch-friendly jump trigger
- Select BHOP Version — choose Acceleration, Ground Acceleration, or No Acceleration
- Select Jump Type — choose the jump simulation method
- BHOP Acceleration / Max Speed Acceleration — adjustable acceleration values

### Auto Acceleration
- Auto Acceleration (Legit) — gradually accelerates your speed while bunny-hopping, without relying on the floating button system
- Max Speed Acceleration — adjustable acceleration cap

### Edge Trimp
- Edge Trimp — automatically bounces you off ledges/edges for a speed and height boost
- Edge Mode — choose between **Realistic** (based on actual fall velocity) and **Simulated** (based on your horizontal approach speed toward the edge — the faster you run at the edge, the higher the boost, and vice versa)
- Bounce Height Multiplier — adjustable multiplier for Realistic mode
- Falling Threshold — minimum fall speed required to trigger Realistic mode
- Simulated Height Multiplier — adjustable multiplier for Simulated mode

---

## Visual

### Lighting Modification
- Custom Time — enables manual control of the in-game clock
- Time of Day — slider (0–24) to set the exact time of day

### Timer Display
- Timer Display — floating round-timer HUD synced to the game's real round timer; text and stroke are animated and follow your selected theme's accent color, turning red automatically when 5 seconds or less remain

### Skin/Cosmetics Changer
- Current Cosmetics — shows your currently equipped cosmetic ID
- Select Cosmetics — enter a cosmetic ID to change into
- Change Cosmetics — applies the selected cosmetic

### Emote Changer
- 1–6 Current Emote — shows your currently equipped emote in each of the 6 slots
- 1–6 Select Emote — enter an emote ID for each of the 6 slots
- Change Emotes — applies all 6 selected emotes at once

### Skybox Changer
- Built-in Skybox — dropdown (search-enabled) of pre-made skyboxes, including Evernight and Waguri
- Apply Skybox — downloads and applies the selected built-in skybox

### Custom Skybox
- Left / Right / Up / Down / Front / Back — 6 direction inputs accepting an asset ID or direct image URL for each cube face
- Apply Custom Skybox — builds and applies a fully custom skybox from your 6 inputs

---

## Info

### Discord
- Server invite embed

### TikTok
- Creator profile, image preview, and copyable profile link

### YouTube
- Creator channel, image preview, and copyable channel link

### GitHub
- Creator GitHub, image preview, and copyable profile link

### UI Library
- Credits and copyable link for the Fluent-modded UI library used in this script

---

## Configuration (Settings)

### Performance
- FPS & Ping Counter — toggles a floating FPS/ping/client-uptime display

### Theme & Interface *(built into the UI library)*
- Theme selector, including 2 exclusive custom themes: Azure and Scarlet
- Animated window toggle, transparency toggle, background image toggle, acrylic toggle
- Font manager, minimize keybind

### Config
- Create / Load / Overwrite / Refresh config list
- Set as Autoload — automatically loads a config on next script execution

### Floating Button Layouts
- Create / Load / Overwrite / Refresh floating button layout list
- Set as Autoload — automatically loads a floating button layout on next script execution

---

## Universal (Extension)

### Character Extension
- Korblox (Right) / Korblox (Left) — visually apply Korblox-style legs
- Headless — visually removes your head, mimicking the Headless Horseman

### Accessory Effects
- Angelic Wings — visual wing accessory effect
- Poisonous Horns — visual poison horn effect
- Frozen Horn — visual frozen horn effect
- Fire Horn — visual fire horn effect
- Doomsekkar — visual Doomsekkar accessory effect

### Delete Hats
- Remove Accessories — strips all worn accessories from your character
- AvatarChanger — applies an avatar/appearance change

### Shader Extension
- Day / Sunset / Shore / Cloudy / Night — one-click lighting presets that fully replace the current Lighting environment

### Ambient Effects
- Rainbow Ambient — cycles the ambient lighting color continuously

### Lightning Extension
- Full Bright — removes shadows and darkness from the map
- Full Bright Brightness — adjustable brightness value
- Disable Fog — removes map fog, including haze reset

### Anti Lags Extension
- Anti Lag 1 / 2 / 3 — three separate lag-reduction presets
- No Render — strips rendering-heavy elements to reduce lag

### Shadows / Technology
- Remove All Shadows — disables shadow casting map-wide
- Disable Light — disables in-game lighting technology
- Anti Gameplay Paused — prevents the game's network-pause popup
- Unlock FPS — removes the client's frame-rate cap

### Fast Flag Extension
- Blox Strap Script — loads an external Bloxstrap initialization script
- Accurate Low Quality — applies FastFlag-based low-quality/performance tweaks (executor-dependent, only shown if `setfflag` is supported)

---

## Injector Notify

- On script load, automatically detects and notifies your Roblox username plus your executor's name and version (via `identifyexecutor`/`getexecutorname`)

---

## Floating Buttons

Every major toggleable feature below can spawn its own independent, draggable, resizable floating button on-screen — each with adjustable real-pixel size (`WidthxHeight` format, base 200x70), independent show/hide control, and an optional keybind:

- Respawn
- Fly *(Keybind supported)*
- TAS Rec / Clear / Play *(Keybind supported)*
- Lag Switch *(Keybind: F12)*
- Easy Bounce *(Keybind supported)*
- Macro 1 (Emote or Crouch) *(Keybind supported)*
- Macro 2 (Crouch/Uncrouch) *(Keybind: Ctrl)*
- Gravity *(Keybind supported)*
- BHOP / Auto Jump *(Keybind supported)*
