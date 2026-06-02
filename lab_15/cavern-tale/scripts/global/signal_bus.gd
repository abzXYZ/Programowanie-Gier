extends Node

@warning_ignore("unused_signal")
signal ammo_changed(ammo : int, max_ammo : int)
@warning_ignore("unused_signal")
signal enemy_killed(xp : float)
@warning_ignore("unused_signal")
signal wpn_level_changed(lvl : float, max_lvl : float)
@warning_ignore("unused_signal")
signal hp_changed(hp : int, max_hp : int)
@warning_ignore("unused_signal")
signal change_wpn_icon(region_offset : int)
@warning_ignore("unused_signal")
signal room_transition_started
@warning_ignore("unused_signal")
signal room_transition_finished(prepared_room : Node2D, entry_point : Vector2)
@warning_ignore("unused_signal")
signal hud_transition_finished
@warning_ignore("unused_signal")
signal player_died
@warning_ignore("unused_signal")
signal safehouse_status_changed(is_in_safehouse : bool)
@warning_ignore("unused_signal")
signal fireplace_lit
@warning_ignore("unused_signal")
signal blizzard_timer_changed()
@warning_ignore("unused_signal")
signal blizzard_damage(damage : int)
@warning_ignore("unused_signal")
signal end_demo()
