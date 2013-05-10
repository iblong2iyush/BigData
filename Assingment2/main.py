class node:
    "A class for nodes, atomic blocks of any bayesian network"

    def __init__(self, name, possible_values=(True,False) ):
        self.name = name
        self.possible_values = possible_values

    def __str__(self):
        res = "Node %s which might take one of the %i following values:" \
              % (self.name ,len(self.possible_values))
        for value in self.possible_values:
            res += " "
            res += str(value)          
        return res

    def get_possible_values(self):
        return self.possible_values

    def get_name(self):
        return self.name

class edge:
    "A class for edge which connects which connects nodes"

    def __init__(self, node1, node2):
        
        if isinstance(node1,node) and isinstance(node2,node):
            self.start_node = node1
            self.end_node = node2
        else:
            print "Unrecognised type of nodes"
            return False

        self.transition_matrix = []
        values_1 = node1.get_possible_values()
        values_2 = node2.get_possible_values()
        for i1 in range(len(values_1)):
            for i2 in range(len(values_2)):
                self.transition_matrix.append( [values_1[i1], values_2[i2], 0] )     

    def __str__(self):
        res = self.start_node.get_name() + " -> " + self.end_node.get_name()
        return res
        
class network:
    "A class for bayesian network which consists of nodes and edges between them"

    def __init__(self):
        self.nodes = []
        self.edges = []

    def __str__(self):
        res = "Network with nodes: \n"
        for node in self.nodes:
            res += str( node.get_name() )
        res += ";\n which are connected via edges:\n"
        for edge in self.edges:
            res += str(edge)
        return res

    def add_node(self, somenode):
        self.nodes.append(somenode)

    def add_edge(self, someedge):
        self.edges.append(someedge)
        
if __name__=="__main__":
    n_a = node("A")
    print(n_a)
    n_b = node("B")
    print(n_b)
    e_c = edge(n_a,n_b)
    print(e_c)

    net_X = network()
    net_X.add_node(n_a)
    net_X.add_edge(e_c)
    print(net_X)  
