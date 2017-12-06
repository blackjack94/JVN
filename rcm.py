def ordered_vertices_of(graph):
    vertices_with_degree = {}

    for v in range(len(graph)):
        degree = 0
        for i in range(len(graph[v])):
            if graph[v][i] == 1:
                degree += 1
        vertices_with_degree[v+1] = degree

    vertices = sorted(vertices_with_degree.items(), key=lambda v: v[1])
    return [v for (v, _) in vertices]


def adjacent_vertices_of(vertice, graph, ordered_vertices):
    vertice_data = graph[vertice-1]

    adjacent_vertices = []
    for v in range(len(vertice_data)):
        if vertice_data[v] == 1:
            adjacent_vertices.append(v+1)

    return [v for v in ordered_vertices if v in adjacent_vertices]


def RCM(graph_matrix):
    queue = []
    R = []
    ordered_vertices = ordered_vertices_of(graph_matrix)

    while len(R) < len(graph_matrix):
        P = ordered_vertices.pop(0)
        R.append(P)
        P_adjacent_vertices = adjacent_vertices_of(P, graph_matrix,
                                                   ordered_vertices)
        queue.extend(P_adjacent_vertices)

        while len(queue) != 0:
            C = queue.pop(0)
            if C not in R:
                R.append(C)
                C_adjacent_vertices = adjacent_vertices_of(C, graph_matrix,
                                                           ordered_vertices)
                queue.extend([v for v in C_adjacent_vertices if v not in R])

    return R[::-1]


graph_4 = [[0, 1, 1, 0],
           [1, 0, 1, 0],
           [1, 1, 0, 1],
           [0, 0, 1, 0]]
print(f"Graph 4: {RCM(graph_4)}")

graph_5 = [[1, 1, 1, 1, 0],
           [1, 1, 1, 0, 0],
           [1, 1, 1, 1, 0],
           [1, 0, 1, 1, 0],
           [0, 0, 0, 0, 1]]
print(f"Graph 5: {RCM(graph_5)}")

graph_A = [[1, 1, 0, 0, 1, 0, 0, 1],
           [1, 1, 1, 0, 0, 1, 0, 0],
           [0, 1, 1, 1, 0, 0, 1, 0],
           [0, 0, 1, 1, 1, 0, 0, 1],
           [1, 0, 0, 1, 1, 1, 0, 0],
           [0, 1, 0, 0, 1, 1, 1, 0],
           [0, 0, 1, 0, 0, 1, 1, 1],
           [1, 0, 0, 1, 0, 0, 1, 1]]
print(f"Graph A: {RCM(graph_A)}")
