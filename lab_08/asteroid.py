import pyray as rl
import math
import random
import utils

class Asteroid:
    def __init__(self, x=0, y=0, level=utils.MAX_ASTEROID_LEVEL):
        self.x = x
        self.y = y
        self.level = level
        
        base_size = level * utils.ASTEROID_SIZE
        self.radius = random.uniform(base_size - (utils.ASTEROID_SIZE/3),base_size + (utils.ASTEROID_SIZE/3))
        self.velocity = (utils.MAX_ASTEROID_LEVEL-level) * utils.ASTEROID_SPEED
        self.direction = rl.Vector2(random.random() - 0.5, random.random() - 0.5)
        self.rot = 0
        self.rot_speed = random.uniform(-40, 40) * (1 - (self.radius / 100) + 0.2)
        self.alive = True

        self.vertices = []
        min_r = self.radius * (1.0 - utils.EDGE_OFFSET)
        for i in range(utils.EDGES):
            angle = (2 * math.pi / utils.EDGES) * i
            r = random.uniform(min_r, self.radius)
            self.vertices.append(rl.Vector2(math.cos(angle) * r, math.sin(angle) * r))

    # Funkcja do otrzymywania globalnej pozycji rogów wielokąta
    def vertices_pos(self, point):
        vertices = []
        for v in self.vertices:
            rotated = utils.rotate_point(v,self.rot)
            vertices.append(rl.Vector2(rotated.x + point.x, rotated.y + point.y))
        return vertices

    # Rysuj wielokąt
    def draw_polygon(self, center):
        wv = self.vertices_pos(center)
        n = len(wv)
        for i in range(n):
            rl.draw_line_v(wv[i], wv[(i + 1) % n], rl.LIME)

    def split(self):
        fragments = []
        if self.level > 1:
            for i in range(2):
                fragments.append(Asteroid(self.x,self.y,self.level-1))
        return fragments

    def wrap(self):
        self.x = self.x % utils.SCREEN_W
        self.y = self.y % utils.SCREEN_H

    def update(self, dt):
        self.x += self.velocity * self.direction.x * dt
        self.y += self.velocity * self.direction.y * dt
        self.rot = (self.rot + self.rot_speed * dt) % 360

    def draw(self):
        self.draw_polygon(rl.Vector2(self.x, self.y))
        for g in utils.ghost_positions(self.x, self.y, self.radius):
            self.draw_polygon(g)
        if utils.DEBUG:
            rl.draw_text(f"v={"{:.2f}".format(self.velocity)} r={"{:.2f}".format(self.radius)}", int(self.x-(self.radius/2)), int(self.y), 12, rl.LIME)