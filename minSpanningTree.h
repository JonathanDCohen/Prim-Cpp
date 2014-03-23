#ifndef MIN_SPANNING_TREE_H
#define MIN_SPANNING_TREE_H

#include <iostream>
#include <set>
#include <map>
#include <string>
#include <vector>
#include <queue>
#include <utility>
#include <sstream>
#include <fstream>
#include <stdexcept>
#include "Edge.h"

const int EXPECTED_NUM_INPUTS = 2, ADJACENCY_MATRIX_FILENAME_INPUT_NUMBER = 1;
const std::string NO_EDGE = "-1";

typedef std::map<char, std::vector<Edge> > AdjacencyList;
typedef std::set<Edge> EdgeSet;

class SpanningTree {
	int weight_ = 0;
	int const num_nodes_;
	EdgeSet edge_set_;
	std::set<char> nodes_in_subtree_;
	AdjacencyList const adjacency_;

	bool MakesACycle(Edge const &prospective_edge) const;
	bool SubtreeIncludesNode(char node) const;
	void AddEdgeToSubtree(Edge const &edge, std::priority_queue<Edge> *edge_queue, EdgeSet *prospective_edge_set);
	
public:
	SpanningTree(int num_nodes, AdjacencyList const &adjacency);

	EdgeSet const *GetOptimalEdgeList() const;
	int GetWeight() const;
	bool BuildMinSpanningTree();
};

int ReadInputOrDie(int argc, char *argv[], AdjacencyList *adjacency);
void AddToEdgeList(char row, char col, std::string const &weight, std::vector<Edge> &edges_from_row);

#endif
