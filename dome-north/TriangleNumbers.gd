extends Node3D

var SpiralOfLocations = [[ 0,  1,  1,  0, -1, -1, -1,  0,  1,  2,  2,  2,  2,  1,  0, -1, -2, -2, -2, -2, -2, -1,  0,  1,
   2,  3,  3,  3,  3],
 [ 0,  0,  1,  1,  1,  0, -1, -1, -1, -1,  0,  1,  2,  2,  2,  2,  2,  1,  0, -1, -2, -2, -2, -2,
  -2, -2, -1,  0,  1]]

func detspawnlocs(Night):
	'''Determine per night when and where enemies will spawn'''
	var Place = Vector3()
	for i in range(10):
		print(i)
		Place = Vector3(i%1,i%2,0)
		print(Place)
	pass
