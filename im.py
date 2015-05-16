# Lifeline 
# Copyright 2015 Fabian Enos and Sachin Sancheti
# Licensed under MIT (https://github.com/sachinsancheti1/Lifeline/blob/master/LICENSE)

import json
from py2neo import Graph, Node, Relationship

# files to use
file = 'import.json'
rel_file = 'rel.json'

# connect to the default graph
graph = Graph()

# DEBUG FUNCTION: delete all nodes and relationships
def delete_all():
	graph.cypher.execute("MATCH n-[r]-() DELETE n,r")
	graph.cypher.execute("MATCH n DELETE n")

# find a node with the given set of properties
def find_node(label, properties):
	# form the cypher query
	q = 'MATCH (a:'+label+') WHERE '

	# add all the properties
	for key,value in properties.iteritems():
		q = q+"a."+key+' = "'+value+'" AND '

	# remove the last AND and return the node
	q = q[:-4]+" RETURN a"

	# execute the query
	return graph.cypher.execute(q)

delete_all()

# read the json file
data = json.load(open(file, 'r'))

for person in data:
	n = Node.cast(person)
	n.labels.add("Person")
	graph.create(n)

# read the json file
data = json.load(open(rel_file, 'r'))

for rel in data:
	# find the first node
	person1 = find_node("Person", rel['person1'])
	# find the second node
	person2 = find_node("Person", rel['person2'])

	if(len(person1) != 1):
		print "Singleton node not found for person1: "+json.dumps(rel['person1'])
	elif(len(person2) != 1):
		print "Singleton node not found for person2: "+json.dumps(rel['person1'])
	else:
		# create the relationship
		r = Relationship(person1.one, rel['relationship'], person2.one)
		graph.create(r)
