import time

from twisted.web import server, resource
from twisted.internet import reactor

class Simple(resource.Resource):
	isLeaf = True
	def render_GET(self, request):
		return "<html>%s Iterations!</html>" % n

def main():
	global n
	print "Starting http server on 8080 port"  
	site = server.Site(Simple())
	reactor.listenTCP(8080, site)
	reactor.startRunning(False)
	n = 0
	print "Starting loop"
	while True:
		n += 1
		if n % 100 == 0:
			print n
		time.sleep(0.1)
		reactor.iterate()

if __name__=="__main__":
	main()

