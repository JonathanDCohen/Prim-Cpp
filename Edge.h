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
	void Print() const;
	Edge(char node1, char node2, int weight);
};

bool operator< (Edge const &left, Edge const &right);
#endif