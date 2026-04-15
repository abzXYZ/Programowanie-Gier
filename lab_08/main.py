import pyray as rl
import random
import time

import utils
from state import State

import ship
import asteroid
import bullet
import explosion

# Inicjalizacja okna
rl.init_window(utils.SCREEN_W, utils.SCREEN_H, "Asteroids")

fps = utils.TARGET_FPS
if utils.DEBUG:
    fps = utils.DEBUG_FPS
rl.set_target_fps(fps)

# Inicjalizacja biblioteki dźwięków
rl.init_audio_device()
sounds = {
  "shoot": rl.load_sound("assets/shoot.wav"),
  "hurt": rl.load_sound("assets/hurt.wav"),
  "explode": rl.load_sound("assets/explode.wav")
}

# Obraz tła
background = rl.load_texture("assets/stars.png")

# Zmienne globalne
score = 0
best = 0
wave = 1
next_wave_text_timer = 0 # Czas wyświetlania tekstu fali
spaceship = None
asteroids = []
bullets = []
explosions = []

# Inicjalizacja asteroid
def spawn_asteroids():
    asteroids = []
    sizes_pool = utils.DIFFICULTY * wave # Pula rozmiarów asteroid (aby zawsze łączny poziom wszystkich asteroid był równy wartościowi poziomu trudności)
    while sizes_pool > 0:
        aster_level = random.randint(1, min(utils.MAX_ASTEROID_LEVEL, sizes_pool)) # Losowy poziom asteroidy od 1 do MAX_ASTEROID_LEVEL
        sizes_pool -= aster_level
        random_pos = rl.Vector2(random.randint(0, utils.SCREEN_W), random.randint(0, utils.SCREEN_H))
        # Ponownie losuj pozycję tak długo jak asteroida spawnuje się w kolizji ze statkiem.
        while utils.check_circle_collision(rl.Vector2(spaceship.x, spaceship.y), 15, random_pos, aster_level * utils.ASTEROID_SIZE * 1.5):
            random_pos = rl.Vector2(random.randint(0, utils.SCREEN_W), random.randint(0, utils.SCREEN_H))
        asteroids.append(asteroid.Asteroid(random_pos.x, random_pos.y, aster_level))
    return asteroids

# Inicjalizacja obiektów gry (zmiennych)
def init_game():
    global score, asteroids, bullets, explosions, wave, next_wave_text_timer, spaceship

    score = 0
    wave = 1
    next_wave_text_timer = 0

    x = utils.SCREEN_W // 2
    y = utils.SCREEN_H // 2
    rot = 270
    spaceship = ship.Ship(x, y, rot)

    asteroids = spawn_asteroids()

    bullets = []
    explosions = []

# Obrażenia statku
def damage_ship():
    if spaceship.alive:
        spaceship.alive = False
        rl.play_sound(sounds["hurt"])
        explosions.append(explosion.Explosion(spaceship.x, spaceship.y, 30))

# Rysuj HUD
def draw_hud():
    color = rl.WHITE
    if score > best:
        color = rl.Color(255, 255, 192, 255)
    rl.draw_text(f"SCORE: {score} BEST: {best}", 10, 10, 18, color)
    if next_wave_text_timer > 0:
        title = f"WAVE: {wave}"
        title_size = 50
        title_w = rl.measure_text(title, title_size)
        rl.draw_text(title, (utils.SCREEN_W - title_w) // 2, utils.SCREEN_H // 2 - 80, title_size, rl.WHITE)

# Stan MENU
def updatemenu():
    if rl.is_key_pressed(rl.KeyboardKey.KEY_ENTER):
        init_game()
        return State.GAME
    return State.MENU

def drawmenu():
    rl.begin_drawing()
    rl.clear_background(rl.BLACK)
    rl.draw_texture(background, 0, 0, rl.WHITE)

    title = "ASTEROIDS"
    title_size = 60
    title_w = rl.measure_text(title, title_size)
    rl.draw_text(title, (utils.SCREEN_W - title_w) // 2, utils.SCREEN_H // 2 - 80, title_size, rl.WHITE)

    prompt = "Press >ENTER< to play"
    prompt_size = 24
    prompt_w = rl.measure_text(prompt, prompt_size)
    rl.draw_text(prompt, (utils.SCREEN_W - prompt_w) // 2, utils.SCREEN_H // 2 + 10, prompt_size, rl.LIGHTGRAY)

    if best > 0:
        best_text = f"BEST: {best}"
        best_size = 20
        best_w = rl.measure_text(best_text, best_size)
        rl.draw_text(best_text, (utils.SCREEN_W - best_w) // 2, utils.SCREEN_H // 2 + 50, best_size, rl.YELLOW)

    rl.end_drawing()

# Stan GAME
def updategame(dt):
    global score, bullets, asteroids, explosions, next_wave_text_timer, wave

    if spaceship.alive:
        spaceship.update(dt)
        spaceship.wrap()

    for a in asteroids:
        a.update(dt)
        a.wrap()

    # Strzelanie
    if (rl.is_key_pressed(32) and len(bullets) < utils.MAX_BULLETS): # Spacja
        if utils.DEBUG:
            print("STRZAŁ")
        bullet_pos = spaceship.get_nose()
        bullets.append(bullet.Bullet(bullet_pos.x, bullet_pos.y, spaceship.rot, utils.BULLET_SPEED, utils.BULLET_RAD, utils.BULLET_TTL))
        rl.play_sound(sounds["shoot"])

    # Aktualizuj pociski i sprawdź kolizję pocisk-statek
    for b in bullets:
        b.update(dt)
        b.wrap()
        # Kolizja pociski-statek
        if utils.check_circle_collision(rl.Vector2(spaceship.x, spaceship.y), 15, rl.Vector2(b.x, b.y), b.radius):
            damage_ship()

    for a in asteroids:
        # Kolizja asteroidy-pociski
        for b in bullets:
            if utils.check_circle_collision(rl.Vector2(b.x, b.y), b.radius, rl.Vector2(a.x, a.y), a.radius):
                b.alive = False
                a.alive = False
                score += a.level * utils.POINTS_PER_KILL
                asteroids.extend(a.split())
                rl.play_sound(sounds["explode"])
                explosions.append(explosion.Explosion(a.x, a.y, a.radius * 1.5))
        # Kolizja asteroidy-statek
        if utils.check_circle_collision(rl.Vector2(spaceship.x, spaceship.y), 15, rl.Vector2(a.x, a.y), a.radius):
            damage_ship()

    for e in explosions:
        e.update(dt)

    # Czyszczenie „martwych" obiektów
    bullets = utils.clear_corpses(bullets)
    asteroids = utils.clear_corpses(asteroids)
    explosions = utils.clear_corpses(explosions)

    # Przejście do GAME_OVER gdy statek martwy i wszystkie eksplozje się skończyły (żeby gracz zobaczył eksplozję własnego statku)
    if not spaceship.alive and len(explosions) == 0:
        return State.GAME_OVER
    elif next_wave_text_timer > 0:
        next_wave_text_timer -= dt
        if next_wave_text_timer <= 0:
            asteroids = spawn_asteroids()
    elif len(asteroids) == 0:
        next_wave_text_timer = 1
        wave += 1
    return State.GAME

def drawgame():
    rl.begin_drawing()
    rl.clear_background(rl.BLACK)
    rl.draw_texture(background, 0, 0, rl.WHITE)

    if spaceship.alive:
        spaceship.draw()

    for a in asteroids:
        a.draw()

    for b in bullets:
        b.draw()

    for e in explosions:
        e.draw()

    # Rysuj HUD
    draw_hud()

    rl.end_drawing()

# Stan GAME_OVER
def updategameover():
    global best
    if score > best:
        best = score
    if rl.is_key_pressed(rl.KeyboardKey.KEY_ENTER):
        return State.MENU
    return State.GAME_OVER

def drawgameover():
    rl.begin_drawing()
    rl.clear_background(rl.BLACK)
    rl.draw_texture(background, 0, 0, rl.WHITE)

    title = "GAME OVER"
    title_size = 60
    title_w = rl.measure_text(title, title_size)
    rl.draw_text(title, (utils.SCREEN_W - title_w) // 2, utils.SCREEN_H // 2 - 80, title_size, rl.RED)

    score_text = f"SCORE: {score}"
    score_size = 30
    score_w = rl.measure_text(score_text, score_size)
    rl.draw_text(score_text, (utils.SCREEN_W - score_w) // 2, utils.SCREEN_H // 2, score_size, rl.WHITE)

    if score >= best:
        new_best_text = "NEW BEST!"
        nb_size = 22
        nb_w = rl.measure_text(new_best_text, nb_size)
        rl.draw_text(new_best_text, (utils.SCREEN_W - nb_w) // 2, utils.SCREEN_H // 2 + 40, nb_size, rl.Color(255, 255, 192, 255))

    prompt = "Press ENTER to return to menu"
    prompt_size = 20
    prompt_w = rl.measure_text(prompt, prompt_size)
    rl.draw_text(prompt, (utils.SCREEN_W - prompt_w) // 2, utils.SCREEN_H // 2 + 80, prompt_size, rl.LIGHTGRAY)

    rl.end_drawing()


state = State.MENU

# Główna pętla gry (FSM)
while not rl.window_should_close():
    dt = rl.get_frame_time()

    if state == State.MENU:
        state = updatemenu()
        drawmenu()

    elif state == State.GAME:
        state = updategame(dt)
        drawgame()

    elif state == State.GAME_OVER:
        state = updategameover()
        drawgameover()

# Zwolnij dźwięki
for snd in sounds:
    rl.unload_sound(sounds[snd])
rl.close_audio_device()

# Zwolnij teksturę
rl.unload_texture(background)

rl.close_window()