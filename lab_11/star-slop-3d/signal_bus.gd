# Signal Bus służy do rejestrowania sygnałów one-to-many oraz many-to-many; na podstawie notatki w dokumentacji Godotaa
# (https://github.com/godotengine/godot-docs-user-notes/discussions/5#discussioncomment-8124099)
extends Node

signal target_hit()
signal bullet_dead(bullet)
signal died(points: int)
