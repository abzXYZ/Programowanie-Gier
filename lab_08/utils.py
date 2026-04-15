import pyray as rl
import math

DEBUG = False
DEBUG_FPS = 60
TARGET_FPS = 60

SCREEN_W = 800
SCREEN_H = 600

# Dane asteroid
EDGES = 9               # Ilość kątów wielokąta
EDGE_OFFSET = 0.25      # Wariancja pozycji rogów wielokąta
ASTEROID_SIZE = 20      # Rozmiar asteroidy +- ⅓ per jeden poziom
ASTEROID_SPEED = 35     # Prędkość asteroidy per jeden poziom
MAX_ASTEROID_LEVEL = 3  # Maksymalny poziom asteroidy
DIFFICULTY = 10         # Początkowy poziom trudności; Wartość, od której nie bezpośrednio zależna jest ilość i rozmiary asteroid
POINTS_PER_KILL = 10    # Punkty za zniszczenie asteroidy per jej poziom

# Dane statku
THRUST = 1          # Siła przyspieszenia. Wartość 1 skutkuje umiarkowanym, mało gwałtownym rozpędem. 
MAX_SPEED = 100     # Maksymalna prędkość. Wartość 50 nie jest za szybka, ale na ten moment nie widzę potrzeby na większą.
ROT_SPEED = 3       # Szybkość obrotu. Wartość 3 pozwala na kontrolowane sterowanie.
FRICTION = 1        # Tarcie. Wartość 1 sprawia, że hamuje gładko, ale zdecydowanie.

# Dane pocisków
BULLET_SPEED = 300
BULLET_RAD = 3
BULLET_TTL = 2
MAX_BULLETS = 5

def ghost_positions(x, y, size):
    ghosts = []

    near_right = x + size > SCREEN_W
    near_left = x < size
    near_bottom = y + size > SCREEN_H
    near_top = y < size

    if near_right:
        gx = x - SCREEN_W
    elif near_left:
        gx = x + SCREEN_W
    else:
        gx = None

    if near_bottom:
        gy = y - SCREEN_H
    elif near_top:
        gy = y + SCREEN_H
    else:
        gy = None

    if gx is not None:
        ghosts.append(rl.Vector2(gx, y))   # prawo/lewo
    if gy is not None:
        ghosts.append(rl.Vector2(x, gy))   # góra/dół
    if gx is not None and gy is not None:
        ghosts.append(rl.Vector2(gx, gy))  # rogi

    return ghosts

# Funkcja do obrotu punktu tym macierzowym sposobem
def rotate_point(point, rot):
    cos_a = math.cos(math.radians(rot))
    sin_a = math.sin(math.radians(rot))
    return rl.Vector2(point.x * cos_a - point.y * sin_a, point.x * sin_a + point.y * cos_a)

# Funkcja do otrzymywania globalnej pozycji lokalnego punktu
def point_pos(point, x, y):
    return rl.Vector2(point.x + x, point.y + y)

# Usuwanie ,,martwych'' obiektów (bulletów, asteroid)
def clear_corpses(arr):
    arr_alive = []
    for x in arr:
        arr_alive = [x for x in arr if x.alive]
    return arr_alive

# Kolizja dwóch kół
def check_circle_collision(pointA,rA,pointB,rB):
    return math.hypot(abs(pointA.x - pointB.x), abs(pointA.y - pointB.y)) < rA + rB