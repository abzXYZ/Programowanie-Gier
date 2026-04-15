import pyray as rl
import math
import utils

class Explosion:

    def __init__(self, x = 0, y = 0, radius = 25):
        self.x = x
        self.y = y
        self.max_radius = radius
        self.radius = 0
        ttl = radius/30
        self.ttl = ttl
        self.max_ttl = ttl
        self.alive = True
 
    def update(self, dt):
        self.ttl -= dt
        if self.ttl <= 0:
            self.alive = False
        else:
            progress = 1.0 - (self.ttl / self.max_ttl)
            self.radius = self.max_radius * progress
 
    def draw(self):
        # Efekt zanikania eksplozji
        alpha = max(0.0, self.ttl / self.max_ttl)
        color = rl.fade(rl.RED, alpha)
        rl.draw_circle_lines_v(rl.Vector2(self.x, self.y), max(self.radius, 1), color)
        if utils.DEBUG:
            rl.draw_text(f"TTL={"{:.2f}".format(self.ttl)}", int(self.x-(self.radius/2)), int(self.y), 12, rl.RED)