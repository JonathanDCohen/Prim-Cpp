#include "Edge.h"
std::vector<char> Edge::GetNodes() const {
	return nodes_;
}

int Edge::GetWeight() const {
	return weight_;
}

void Edge::Print(bool negative_edge) const {
	std::cout << nodes_[0] << "-- " << (negative_edge ? -weight_ : weight_) << " --" << nodes_[1] << "\n";
}

Edge::Edge(char node1, char node2, int weight) : nodes_{node1, node2} {
	if (node1 == node2) {
		throw std::runtime_error("Invalid edge: no loops allowed");
	}
	weight_ = weight;
}

//Ordering on edges is by weight, with node names breaking ties.
bool operator< (Edge const &left, Edge const &right) {
	auto left_as_pair = std::make_pair(left.GetWeight(), left.GetNodes());
	auto right_as_pair = std::make_pair(right.GetWeight(), right.GetNodes());
	return left_as_pair < right_as_pair;
}