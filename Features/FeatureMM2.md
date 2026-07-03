# GoonWares | Murder Mystery 2 — Feature List

A complete overview of every feature available in the script, organized by tab.

---

## Main

### Server Information
- In Server For — live server uptime counter
- Server Started — exact time the server session started
- Game — current place name
- Current Players — live player count in the server
- Server ID — current job/server ID

### Client Information
- Script Running For — how long the script has been running
- Executed Since — the exact time the script was executed

### System Information
- OS Clock — current device clock
- Calendar — current date
- GPU — GPU frame time
- CPU — CPU frame time
- RAM — memory usage and percentage
- Sent — outgoing network data rate
- Received — incoming network data rate
- Ping — server ping in milliseconds
- FPS — current frames per second

### Player Information
- Username — your Roblox username
- Display Name — your Roblox display name
- User ID — your Roblox user ID
- Account Created — the date your account was created

### Friends Data
- Online Friends — number of friends currently online
- Offline Friends — number of friends currently offline
- Total Friends — total friend count

### Server Tools
- Rejoin — instantly rejoin the current server
- Copy Server Launch ID — copies a launch link for the current server to your clipboard
- Copy Server Link — copies a shareable server link to your clipboard

### Server Info
- Player Count — live player count with max player cap
- Player Model Server Status — detects and reports anti-exploit model brokenness

---

## Player

### Player
- Infinite Jump — jump endlessly without touching the ground
- Speed Hack — increases your walk speed with an adjustable value

### Speed Glitch
- Speed Glitch Mode — switch between Air Acceleration and Realistic glitch styles
- Speed Value — adjustable glitch speed strength
- Show Speed Glitch Button — toggles a floating button for Speed Glitch
- Speed Glitch Keybind — assign a keybind to toggle Speed Glitch
- Noclip — walk through walls and obstacles
- Fly — free-flight movement
- Fly Speed — adjustable flight speed
- Fly Button — floating button to toggle Fly
- Fly Keybind — assign a keybind to toggle Fly
- God Mode — become immune to damage
- God Mode Method — choose between Health Math.huge and other immunity methods
- TP Walk — teleport-based walking with adjustable distance
- Jump Height / Jump Power — adjust jump height
- Walk on Walls — walk vertically on wall surfaces (must reset character to stop)
- Fake Dead (lays) — fake your character as dead/knocked out on the ground
- Show Fake Dead Button — floating button for Fake Dead

---

## Combat

### Aimbot
- Aim Part — choose which body part to aim at
- Target Roles — choose which roles the aimbot should target
- Aim Lock Type — choose aim lock behavior
- Smoothness — aim smoothing strength
- Max Distance — maximum aimbot targeting distance
- Wall Check — prevents aiming through walls

### FOV Settings
- Show FOV Circle — displays an animated FOV indicator matching the floating-button visual style
- Lock FOV On Middle Screen — keeps the FOV circle centered instead of following the mouse
- FOV Radius — adjustable FOV circle size
- FOV Color — choose the FOV circle's color
- FOV Thickness — adjustable ring thickness

### Gun Combat
- Auto Shoot Murderer — automatically shoots the murderer when you have a gun
- Show Auto Shoot Murder Button — floating button for Auto Shoot Murderer
- Magic Bullet — bullets bypass walls and obstacles
- Wall Check (Prevent shooting through walls) — optional safety check for shots
- Enable Prediction — predicts target movement for more accurate shots
- Magic Bullet Side Offset — adjusts magic bullet trajectory offset
- Shoot Position Offset / Offset-to-Ping Multiplier — fine-tune shot accuracy against ping
- Shoot Murderer — manual one-click shoot action
- Shoot Murderer Keybind — assign a keybind to manually shoot
- Show Shoot Murder Button — floating button for manual shoot
- Gun System (Grab Only / Grab & Shoot Murderer) — automatically grabs nearby guns, with optional auto-shoot
- Auto Grab Gun — automatically picks up dropped guns
- Gun Aura — pulls nearby guns toward you
- Manual Grab Gun — manually grab the nearest gun
- Auto Grab Mode — choose grab-only or grab-and-shoot behavior
- Notify Gun — sends a notification when a gun spawns or is picked up

### Knife Combat
- Base module powering all knife-related automation features below

### Stab Reach
- Stab Reach Range — extends your knife's stabbing range

### Thrown Knife
- Auto Throw Knife — automatically throws your knife at nearby players once you're the murderer
- Show Auto Throw Knife Button — floating button for Auto Throw Knife
- Manual Throw Knife — manually throw your knife on demand
- Show Throw Knife Button — floating button for manual knife throw
- Throw Knife Keybind — assign a keybind to throw your knife
- Wall Check For Thrown Knife — prevents throwing through walls

### Thrown Hitbox
- Enable Thrown Hitbox — expands the hitbox of thrown knives
- Hitbox Radius — adjustable thrown-knife hitbox size
- Hit Multiple Targets — allows a single throw to hit more than one player

### Auto Kill
- Auto Equip Knife — automatically equips your knife
- Kill Mode — choose the auto-kill targeting behavior
- Knife Kill Aura Range — kill aura radius around you
- Show Aura Circle — displays the kill aura radius visually
- Kill All — instantly attempts to kill all valid targets

---

## Visuals

### Visual
- Camera Stretch (+ Horizontal/Vertical) — stretches the camera view for a wider field of vision
- Full Bright — removes shadows and darkness from the map
- Field of View — adjustable camera FOV
- Round Timer Display — floating round-timer HUD, styled like a floating button, always locked in place
- X-ray Vision — see through walls and obstacles
- Show X-ray Vision Button — floating button for X-ray Vision
- Remove Footsteps — hides footstep decals
- Remove Stuck Knife — removes knife-stuck visual effects
- Auto Remove Dead Body — automatically clears dead bodies from view
- Disable Coin Visualizer — hides coin collection visual effects
- Force Spectate / Custom Spectate Selected Player — spectate a chosen player after death
- Select Player To Spectate — dropdown of currently available players
- Shit Render — lowers rendering quality to reduce lag

### Weapon Visuals
- Duplication range (Min/Max) — configurable weapon duplication value range
- Visuals Enabled — toggles random Godly weapon visual spawning

### Item Spawner
- Weapon Name — choose a weapon to visually spawn
- Weapon Spawned — confirms the spawned weapon

### Weapon Dupe / Duplication Options
- Duplication Multiplier — how many times an item is duplicated
- Specific Item to Duplicate — choose a specific inventory item to duplicate
- Duplicate Inventory — visually duplicates your entire inventory

### Skybox Changer
- Built-in Skybox — dropdown of 11 pre-made anime-themed skyboxes
- Apply Skybox — applies the selected built-in skybox
- Built-in Skybox Info — usage notes (requires read/write file access; some skyboxes take ~20 seconds to load)

### Custom Skybox
- 6 direction inputs (Left, Right, Up, Down, Front, Back) — accept an asset ID or a direct image URL for each cube face
- Apply Custom Skybox — builds and applies a fully custom skybox from your 6 inputs
- Custom Skybox Info — usage notes for building your own cubemap

### Extra
- Fake Headless — visually removes your head, mimicking the Headless Horseman
- Fake Korblox — visually applies Korblox-style legs

---

## ESP

### Per-Role ESP (one collapsible section per in-game role, each color-coded)
- Boxes — draws a box around players of that role
- Box Type — choose between 2D and 3D box style
- Names — displays the player's name
- Distance — displays distance to the player
- Highlights — full-body highlight outline

### Gun ESP
- Gun Boxes — draws a box around dropped guns
- Gun Box Type — choose between 2D and 3D box style
- Gun Names — displays gun names
- Gun Distance — displays distance to guns
- Gun Highlights — highlight outline around guns

---

## Teleport

- Select Player — dropdown of players to teleport to
- Teleport to Player — teleport to the selected player
- Teleport to Random Player — teleport to a random player in the server
- Teleport to Innocent / Murderer / Sheriff — teleport directly to a player of that role
- Teleport to Dropped Gun — teleport to the nearest dropped gun
- Teleport to Coin — teleport to the nearest coin
- Teleport to Map — teleport to the map's spawn area
- Teleport Above Map — teleport high above the map
- Teleport to Lobby — return to the lobby
- Teleport to Security Part — teleport to the map's security/vote area

---

## Trolls

External troll-feature module (loaded separately), containing extra fun/prank tools on top of the base script.

---

## Misc

### Misc
- Anti AFK — prevents being kicked for inactivity

### Auto Glitch Vote Map
- Auto Vote Teleport — automatically votes for a chosen map
- Map Selection — choose which map to auto-vote for

### Auto Farm
- Enable Auto Farm — automatically collects coins
- Coin Collect Type — choose the coin-collection method
- Auto Farm Type — choose the farming behavior
- Action Do When Full Bag — choose what happens once your coin bag is full
- Underground Farm — farm coins from underground/hidden areas
- Farm Speed — adjustable farming speed
- Teleport Delay — delay between farm teleports
- Coin Aura — pulls nearby coins toward you
- Exp Farm — automatically farms experience

### Role Revealer
- Reveal Murderer — announces the murderer's name in chat
- Reveal Sheriff/Hero — announces the sheriff or hero's name in chat
- Trade Helper — assists with in-game trading
- Show Bomb MLG Button — floating button for the Bomb MLG meme feature
- Bomb MLG Keybind — assign a keybind to trigger it
- Fake Bomb — triggers a fake bomb visual effect

---

## Utility

### Anti AFK
- Disable Invisible Walls — continuously disables collision on invisible walls, including ones that appear after the toggle is enabled
- Unlock All Emotes — unlocks every emote for use
- Emote Name / Play Emote By Name — play any emote by typing its name

### Fling
- Touch Fling — flings players you touch
- Fling Power — adjustable fling strength
- Fling Tool — choose the fling delivery method
- Fling Role — choose which role to target with fling

### Fling Settings
- Fling Target — choose fling targeting mode
- Fling Mode — choose the fling technique
- Fling Players — fling all valid players
- Fling Murderer / Fling Sheriff/Hero — fling a specific role directly

### Anti Void
- Anti Void Damage — prevents fall/void damage

### Misc
- Infinite Position Lock — locks your character to a fixed position
- Set Time (HH:MM) — changes the in-game lighting time

### Lag Switch
- Show Lag Switch Button — floating button for Lag Switch
- Trigger Lag Switch — manually trigger a lag switch
- Lag Method — choose the lag switch technique
- Lag Duration — adjustable lag switch duration

### Gravity
- Custom Gravity — override the world's gravity value
- Show Gravity Button — floating button for Gravity
- Toggle Gravity — enable/disable custom gravity
- Gravity Value — adjustable gravity strength

### No Render
- No Render Color — choose the color used for simplified rendering
- Remove Textures — strips map textures for performance
- Low Quality — lowers overall visual quality

### Anti Fling
- Disable Player Collisions — prevents other players from colliding with (and flinging) you

### Hitbox
- Hitbox Expanding — expands player hitboxes
- Hitbox Size — adjustable hitbox expansion size
- Show Hitbox — visually displays expanded hitboxes
- Hitbox Color — choose the hitbox visual color

### Invisible
- Show Invisible Button — floating button for Invisible
- Invisible Toggle — turns your character invisible

---

## Settings

### FPS Counter
- Show FPS Counter — toggles a floating FPS/ping/uptime display that automatically matches your selected theme's colors

### GUI Size
- Reset All Scales — resets every element's UI scale back to default

### Theme & Interface (built into the UI library)
- Theme selector, including 2 exclusive custom themes: Crimson and Bloomings
- Animated window toggle
- Transparency toggle
- Disable background images toggle
- Acrylic toggle
- Font Manager
- Minimize keybind

### Config
- Config Name / Config List — name and browse saved configs
- Create Config — save your current settings as a new config
- Load Config — load a saved config
- Overwrite Config — overwrite an existing config
- Refresh List — refresh the config list
- Set As Autoload — automatically load a config on next script execution

### Floating Button Layouts
- Layout Name / Layouts List — name and browse saved floating button layouts
- Create / Load / Overwrite / Delete Layout — manage floating button position presets
- Refresh List — refresh the layout list
- Set As Autoload — automatically load a floating button layout on next script execution

---

## Others

### Cleostrap
- Execute Cleostrap — runs the Cleostrap loader

### Avatar
- Avatar Stealer — copies another player's avatar appearance onto your character

### Replace Death Sounds
- Custom Death Sounds — replaces the default death sound
- Sound ID or HTTP URL — accepts a Roblox asset ID or a direct audio link
- Test Sound — previews the selected sound
- Apply to Existing Sounds — applies the replacement to sounds already in the game

### Map Loader
- Map Asset ID — enter a custom map's asset ID
- Initial Height — set the height you spawn at while the map loads
- Load Map — loads the custom map into the game
- Reset Position — resets your character's position

### Fixes
- Remove Game Pause UI — removes Roblox's network-pause interruption popup

### Desync
- Visualise Server Desync Position — shows a ghost outline representing your position as the server sees it, accounting for ping

---

## Floating Buttons

Every major toggleable feature below can spawn its own independent, draggable, resizable floating button on-screen — each with adjustable real-pixel size (`WidthxHeight` format), independent show/hide control, and persistent lock/position saving:

- Speed Glitch
- Fly
- Fake Dead
- Auto Shoot Murder
- Shoot Murder (manual)
- Auto Throw Knife
- Throw Knife (manual)
- Bomb MLG
- Lag Switch
- Gravity
- Invisible
- X-ray Vision

---

## Custom Themes

- **Crimson** — a dark red/black bloodshed-inspired theme with a rotating shine border and randomized background art
- **Bloomings** — a soft pink/magenta theme with a colorful rotating shine border
