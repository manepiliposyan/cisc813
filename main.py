import numpy as np
import os


class Grid:
    def __init__(self, x_size, y_size, file):
        self.file = file  # output file name
        if os.path.exists(self.file):
            os.remove(self.file)

        # grid sizes
        self.x_size = x_size
        self.y_size = y_size

        # [[L_00, L_01, ..., L_0[y_size-1]],[L_21, ..., L_2[y_size-1]],...,[L_[x_size-1]0,...,L_[x_size-1][y_size-1]]
        self.location_objects = np.empty((x_size, y_size), dtype="U4")

        self.right_connections = []
        self.left_connections = []
        self.up_connections = []
        self.down_connections = []

        self.right_edges = []
        self.left_edges = []
        self.up_edges = []
        self.down_edges = []

    # L_00 L_01 ...... L_[x_size-1][y_size-1] - [object type]
    def create_location_objects(self):
        for i in range(self.x_size):
            for j in range(self.y_size):
                self.location_objects[i][j] = ''.join(["L_", str(i), str(j)])

    # ---------------------------------------------------------
    def create_right_connections(self):
        for i in range(self.x_size):
            for j in range(self.y_size - 1):
                self.right_connections.append((self.location_objects[i][j], self.location_objects[i][j + 1]))

    def create_left_connections(self):
        for i in range(self.x_size):
            for j in reversed(range(1, self.y_size)):
                self.left_connections.append((self.location_objects[i][j], self.location_objects[i][j - 1]))

    def create_up_connections(self):
        for j in range(self.y_size):
            for i in reversed(range(1, self.x_size)):
                self.up_connections.append((self.location_objects[i][j], self.location_objects[i - 1][j]))

    def create_down_connections(self):
        for j in range(self.y_size):
            for i in range(self.x_size - 1):
                self.down_connections.append((self.location_objects[i][j], self.location_objects[i + 1][j]))

    # ---------------------------------------------------------
    def create_right_left_edges(self):
        for i in range(self.x_size):
            self.right_edges.append(self.location_objects[i][self.y_size - 1])
            self.left_edges.append(self.location_objects[i][0])

    def create_up_down_edges(self):
        for j in range(self.y_size):
            self.up_edges.append(self.location_objects[0][j])
            self.down_edges.append(self.location_objects[self.x_size - 1][j])

    # ---------------------------------------------------------
    def stream_out_location_objects(self):
        locations = " ".join([location for row in self.location_objects for location in row])

        f = open(self.file, "a")
        f.write(":(objects\n")
        f.write("   " + locations + " - location\n")
        f.write(")\n\n")
        f.close()

    def stream_out_connections(self):
        f = open(self.file, "a")
        f.write(":(init\n")

        for i in range(len(self.right_connections)):
            predicate = " ".join(
                [" (right_connected", self.right_connections[i][0], self.right_connections[i][1], ")\n"])
            f.write(predicate)
        f.write("\n")

        for i in range(len(self.left_connections)):
            predicate = " ".join([" (left_connected", self.left_connections[i][0], self.left_connections[i][1], ")\n"])
            f.write(predicate)
        f.write("\n")

        for i in range(len(self.up_connections)):
            predicate = " ".join([" (up_connected", self.up_connections[i][0], self.up_connections[i][1], ")\n"])
            f.write(predicate)
        f.write("\n")

        for i in range(len(self.down_connections)):
            predicate = " ".join([" (down_connected", self.down_connections[i][0], self.down_connections[i][1], ")\n"])
            f.write(predicate)
        f.write("\n")

        f.close()

    def stream_out_edges(self):
        f = open(self.file, "a")

        for i in range(len(self.right_edges)):
            predicate = " ".join([" (right_edge", self.right_edges[i], ")\n"])
            f.write(predicate)
        f.write("\n")

        for i in range(len(self.left_edges)):
            predicate = " ".join([" (left_edge", self.left_edges[i], ")\n"])
            f.write(predicate)
        f.write("\n")

        for i in range(len(self.up_edges)):
            predicate = " ".join([" (up_edge", self.up_edges[i], ")\n"])
            f.write(predicate)
        f.write("\n")

        for i in range(len(self.down_edges)):
            predicate = " ".join([" (down_edge", self.down_edges[i], ")\n"])
            f.write(predicate)
        f.write(")")

        f.close()

    # ---------------------------------------------------------
    def create(self):
        self.create_location_objects()

        self.create_right_connections()
        self.create_left_connections()
        self.create_up_connections()
        self.create_down_connections()

        self.create_right_left_edges()
        self.create_up_down_edges()

    def stream_out(self):
        self.stream_out_location_objects()
        self.stream_out_connections()
        self.stream_out_edges()

    def generate_file(self):
        self.create()
        self.stream_out()


if __name__ == '__main__':
    g = Grid(4, 4, "grid.txt")
    g.generate_file()
