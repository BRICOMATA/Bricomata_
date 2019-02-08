from itertools import combinations
comb1 = combinations([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50], 5)
comb2 = combinations([1,2,3,4,5,6,7,8,9,10,11,12], 2)

#from contextlib import contextmanager

## on fait une exception qui hérite de StopIteration car c'est ce qui est utilisé
## de toute façon pour arrêter une boucle
#class MultiStopIteration(StopIteration):
#	# la classe est capable de se lever elle même comme exception
#	def throw(self):
#		raise self

#@contextmanager
#def multibreak():
#	# le seul boulot de notre context manager c'est de donne le moyen de lever
#	# l'exception tout en l'attrapant
#	try:
#		yield MultiStopIteration().throw
#	except MultiStopIteration:
#		pass

#with multibreak() as stop:
#	for x in range(1, 4):
#		for z in range(1, 4):
#			for w in range(1, 4):
#				print(w)
#				if x * z * w == 2 * 2 * 2:
#					print ('stop')
#					stop() # appel MultiStopIteration().throw()


#for i in comb1:
#	for j in comb2:
#	print(i,j)

#import sys
#matrix = [1,2,3,4,5,6,7,8,9,10,11,12]
#for multiplier in range(1,13):
#	for counter in range(0,12):
#		print(counter, multiplier)
#	print("")
	
i = 0
k=0
wordList = list(comb1)
sizeofList = len(wordList)
wordList2 = list(comb2)
sizeofList2 = len(wordList2)

while i < sizeofList :
	j = 0
	while j < sizeofList2 :
#		l = list(wordList[i])
#		m = list(wordList2[j])
		k+=1
##		l.append(m)
#		print(l + m) 
		j += 1
	i += 1


#[(i,j) for i in list(comb1) for j in list(comb2)]

# ,'P','Q','R','S','T','U','V','W','X','Y','Z','0'
