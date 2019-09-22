extends Polygon2D

func resize():
	self.scale.x = .3
	self.scale.y = .3
	var pol = self.polygon

	pol.resize(self.polygon.size())
	self.polygon = pol
	
	return self.polygon