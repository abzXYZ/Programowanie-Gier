import pyray as rl
import math
import utils

class Bullet:

    def __init__(self, x = 0, y = 0, rot = 0, speed = 100, radius = 5, ttl = 3):
        self.x = x
        self.y = y
        self.rot = rot
        self.direction = rl.Vector2(math.cos(math.radians(rot - 90)),math.sin(math.radians(rot - 90)))
        self.radius = radius
        self.velocity = speed
        self.ttl = ttl
        self.alive = True

    def wrap(self):
        self.x = self.x % utils.SCREEN_W
        self.y = self.y % utils.SCREEN_H

    def update(self, dt):
        self.ttl -= dt
        if self.ttl <= 0:
            self.alive = False
        else:
            self.x += self.velocity * self.direction.x * dt
            self.y += self.velocity * self.direction.y * dt

    def draw(self):
        rl.draw_circle_v(rl.Vector2(self.x,self.y),self.radius,rl.YELLOW)
        if utils.DEBUG:
            rl.draw_text(f"TTL={"{:.2f}".format(self.ttl)}", int(self.x-(self.radius/2)), int(self.y), 12, rl.BLUE)