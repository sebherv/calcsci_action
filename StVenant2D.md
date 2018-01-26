# Projet Calcul Scientifique en action.

# Equations de Saint-Venant en 2D.

## Le but du projet

Développer un code dans le cas de la dimension 2 pour les équations de Saint-Venant. On pourra au choix développer soi-même un code sur maillage structuré, soit développer à partir d'un programme C++ / FreeFem++ un code sur un maillage non structuré.

## Les étapes du projet

- Commencer par faire un schéma 1D - programmer en Matlab -> être en mesure d'avoir des résultats simplement, sans passer par des choses complexes
- Implémenter le schema 1D en C++, comparer à Matlab
- Faire évoluter le schema C++ vers 2D, tester avec des exemples inspirés du 1D.

## Implémentation 1D Matlab.

Je m'inspire de mes notes de cours:

### Paramètres de discrétisation

- $N\in \mathbb{N}$: nombre de mailles (internes)

- D'où le delta x
  $$
  \Longrightarrow \Delta x = \frac{b-a}{N}, (x_{i+\frac{1}{2}})_{i=0,\dots,N}
  $$

- $t^0=0, n = 0$ , $\alpha \in \big]0,1\big[$ 

- Initialisation du schéma avec la condition initiale.

- $$
  u_i^0 = u_0\Bigg(\frac{x_{i-\frac{1}{2}} + x_{i+\frac{1}{2}}}{2}\Bigg)
  $$

  ​

### Choix du schema de stabilité

Je pars dans un premier temps sur du Rusanov:

$L = \max\limits_{i} c(u_i, u_{i+1})$





