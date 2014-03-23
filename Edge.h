#ifndef EDGE_H
#define EDGE_H
#include <iostream>
#include <vector>
#include <stdexcept>

class Edge {
	std::vector<char> nodes_;
	int weight_ = 0;

public:
	// will only ever have two elements, so this is a cheap copy
	std::vector<char> GetNodes() const; 
	int GetWeight() const;
	//true is the default because C++ priority queues are max queues, so 
	//edge weights need to be negative for min spanning trees.
	void Print(bool negative_edge = true) const;
	Edge(char node1, char node2, int weight);
};

bool operator< (Edge const &left, Edge const &right);
#endif