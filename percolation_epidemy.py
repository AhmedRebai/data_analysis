# -*- coding: utf-8 -*-
"""


On pose:

0 pour une personne saine
1 pour une personne malade
2 pour une personne décédée 

Dans ce code, on utilisera 3 bibliothéques: numpy, random et PIL 

Plan: 
1) On définit une population modélisée par une matrice carrée n*n
2) 

"""

from numpy import *
from random import *
from PIL import Image


def population_ini(n):
    "Cette fonction permet de créer une population de taille n*n"
    P=zeros((n,n),int) #matrice d'ordre n remplie de 0
    return P

def boundary_conditions(P,n):
    "Cette fonction permet de définir les conditions aux limites"
    line = 2 + zeros((1,n),int) #on ajoute des morts en haut en en bas de P
    P = concatenate((P,line))
    P = concatenate((line,P))
    col = 2 + zeros((n+2,1),int) #on ajoute des morts à gauche et à droite de P
    P = concatenate((P,col),1)
    P = concatenate((col,P),1)
    return P
    
def virus_intro(P,n):
    "On introduit un virus au niveau d'une personne de pos. aléatoire dans P"
    x = randint(1,n)
    y = randint(1,n)
    V=[]
    V.append([x,y])
    P[x,y]=1
    return P,V
    
def virus_intro_center(P,n):
    "On introduit un virus au centre de la population"
    P[n/2,n/2] = 1
    V=[]
    V.append([n/2,n/2])
    return P,V    
    
"""Remarque: dans la fonction suivante
 on peut mettre P[i,1] ou P[n+1,i] ou P[i,n+1]"""    
def virus_intro_front(P,n):
    "On introduit le virus sur un ensemble de personne (en haut par exemple)"
    V=[]
    for i in range(1,n+1):
        P[1,i]=1
        V.append([1,i])
    return P,V

"Cette fonction des personnes malades et sera utilisée après pour tracer"
"le front de la propagation du virus"

def kill(P,n,p):
    for i in range(1,n+1):
        for j in range(1,n+1):
            if (random()<p):
                P[i,j]=2
    return P

""" 
Les deux fonctions suivantes sont les plus importantes dans le code
puisque elles définissent les modèles de propagation

step(P,V,n,p) utilise un modèle de propagation de proche en proche ==>
les proches voisins.

step_8(P,V,n,p) utilise un modèle de propagation proches voisins + voisins 
lointains ==> on parle d'une super-diffusion.

"""

def step(P,V,n,p):
    P1 = copy(P)
    V1 = []
    for virus in V:
        i = virus[0] # on peut mettre aussi i,j=virus[0],virus[1]
        j = virus[1]
        for k in [-1,1]:
            if ((random()<p) and P1[i+k,j] == 0):
                P1[i+k,j] = 1
                V1.append([i+k,j])
                
            if ((random()<p) and P1[i,j+k] == 0):
                P1[i,j+k] = 1
                V1.append([i,j+k])
        
        P1[i,j]=2

    P = copy(P1)
    return P,V1

def step_8(P,V,n,p):
    "Calcul la propagation du virus en 8 directions"
    P1 = copy(P)
    V1=[]
    for virus in V:
        i = virus[0] # on peut mettre aussi i,j=virus[0],virus[1]
        j = virus[1]
        for k in range(-1,2):
            for l in range(-1,2):
                if((k!=0 or l!=0)):
                    if((random()<p) and P1[i+k,j+l] == 0):
                        P1[i+k,j+l] = 1
                        V1.append([i+k,j+l])
        P1[i,j]=2
    P = copy(P1)
    return P,V1


def count_region(P,n,k):
    "Cette fonction compte le nombre des personnes saines, malades ou mortes"
    "On a alors le choix entre k = 0, k = 1, k = 2"
    count = 0
    for i in range(1,n+1):
        for j in range(1,n+1):
            if (P[i,j] == k ):
                count +=1
    
    return count
       
def count_reached_limit(L,m):
    "Cette fonction compte dans une liste L de longeur m le nombre de..."
    "personne malade."
    
    count = 0    
    for i in range(1,m):
        if (L[i][1]==1):
            count+=1
    
    return count 

def virus_on_bound(P,n):
    count = 0
    for i in range(1,n+1):
        if ((P[i,1]==1) or (P[1,i]==1) or (P[i,n+1]==1) or (P[n+1,i]==1)):
            count += 1
    return count



def obtaining_figure(P,n,name_file):
    "Cette fonction fabrique une image de l'état de la population dans un..."
    "fichier .png obtenu dans le même répertoire de travail"
    "la fonction join: convert a list of characters into a string"
    
    colors = [(124,210,15),(224,210,15),(219,15,32)]
    colors = [''.join([chr(x) for x in color]) for color in colors]
    img_str = ''
    for line in range(n):
        for col in range(n):
            img_str +=colors[P[line,col]]
    img = Image.fromstring('RGB',(n,n),img_str)
    img.save(name_file,'PNG')
    
    return True
    
def name_figure(n,nom):
    Name = nom+(len(nom)-len(str(n)))*'0'+str(n)+'.png'
    return Name


def name_file_data_csv(n,p):
    name = 'population'+str(n)+'x'+str(n)+'avec_proba_de'+str(p)+'.csv'
    return name    

"""
On arrive maintenant aux fonctions qui vont appeler les fonctions précédentes
pour réaliser l'étude de la propagation

"""

def movie(n,p,model):
    P = population_ini(n)
    P = boundary_conditions(P,n)    
    "[P,V] = virus_intro_center(P,n+2)" 
    "On pourra aussi utiliser"
    [P,V] = virus_intro(P,n+2)
    "[P,V] = virus_intro_front(P,n+2)"
    
    print(P)
    print(V)
    i=-1

    while(V!=[]):
        i+=1
        if model==0:
            [P,V] = step(P,V,n,p)
            print( "step :" , i ," with ", count_region(P,n,1))
            obtaining_figure(P,n+2,name_figure(i,'Population'))
        if model==1:
            [P,V]=step_8(P,V,n,p)
            print( "step :",i,"with ",count_region(A,n,1)," virus regions et V : ",V)
            obtaining_figure(P,n+2,name_figure(i,'Population'))
    return P,V
    


def movie_front(n,p):
    P = population_ini(n)
    P = boundary_conditions(P,n)
    P = kill(P,n,p)    
    [P,V] = virus_intro_front(P,n)
    i=-1
    while (V!=[]):
        i+=1
        P,V=step(P,V,n,1)
        print("step",i," with ",count_region(P,n,1), " virus regions")
        obtaining_figure(P,n+2,name_figure(i,'Front'))
    return P,V

"""
shape(P)
size(P)
"""




 

    
    
    

    
    


