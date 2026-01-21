# MOBA / RTS Demo

The purpose of this project is to learn Godot Game Engine and progmramming with Gdscript, while making an isometric 3D game with Moba / Rts controlls.

## Combat system

### UI

- Selected enemy indicator
- Healthbar
- Damage / healing indicators
- Hotbar / skills

**TODO**

- [ ] Show a circle below the selected enemy
- [ ] Make re-usable health bar
- [ ] Make damage / healing number indicators

### Weapons

- Melee or Ranged (range: x)
- Can auto-attack (damage: x)
- Has 3 skill slots (q, w, e)
- Each slot has multiple skill choices (except E maybe..)

**TODO**

- [ ] Make combat system support different kinds of weapons
- [ ] Weapons must support different skills assigned to them

### Skills

- Skills can deal damage, apply statuses on enemies, buff the user, deal damage to user, heal the user or ally, remove buffs from enemies, remove statuses from user or ally etc…
- AOE skills have hit-boxes
- Target skills don’t have hitboxes, but really only range
- Skills consume mana
