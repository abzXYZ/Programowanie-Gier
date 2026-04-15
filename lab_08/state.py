from enum import Enum, auto

# Stany dla FSM
class State(Enum):
    MENU      = auto()
    GAME      = auto()
    GAME_OVER = auto()